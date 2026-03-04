import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/holiday.dart';
import 'dart:async';
import '../models/schedule.dart';

// 1. 기준일 (기존과 동일)
final workBaseDateProvider = Provider<DateTime>((_) => DateTime(2026, 1, 24));

// 2. 휴무 계산기 (기존과 동일)
final holidayProvider = Provider((ref) {
  final baseDate = ref.watch(workBaseDateProvider);
  return WorkStatus(baseDate: baseDate).isHoliday;
});

// 3. Hive 기반 스케줄 Notifier
class ScheduleNotifier extends AsyncNotifier<Map<DateTime, List<Schedule>>> {
  static const String boxName = 'scheduleBox';

  @override
  Future<Map<DateTime, List<Schedule>>> build() async {
    final box = await Hive.openBox(boxName);
    final Map<DateTime, List<Schedule>> loadedData = {};

    for (var key in box.keys) {
      final List<dynamic> rawList = box.get(key);
      final dateKey = DateTime.parse(key.toString());
      loadedData[dateKey] = rawList.map((e) => Schedule.fromMap(e)).toList();
    }
    return loadedData;
  }

  // 스케줄 추가 및 Hive 저장
  Future<void> addSchedule(DateTime date, String title, String content) async {
    final cleanDate = DateTime(date.year, date.month, date.day);
    final dateKey = cleanDate.toIso8601String();

    final newSchedule = Schedule(title: title, content: content, date: cleanDate);

    final box = Hive.box(boxName);
    final currentList = state.value?[cleanDate] ?? [];
    final updatedList = [...currentList, newSchedule];

    // 1. Hive에 영구 저장 (Map 리스트로 변환해서 저장)
    await box.put(dateKey, updatedList.map((e) => e.toMap()).toList());

    // 2. UI 상태 업데이트
    state = AsyncData({
      ...?state.value,
      cleanDate: updatedList,
    });
  }
}

final scheduleProvider = AsyncNotifierProvider<ScheduleNotifier, Map<DateTime, List<Schedule>>>(() {
  return ScheduleNotifier();
});