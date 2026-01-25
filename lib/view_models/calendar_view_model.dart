// lib/view_models/calendar_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/holiday.dart'; // Model 임포트 필수!

// 1. 기준일 (어제가 근무일!)
final workBaseDateProvider = Provider<DateTime>((ref) => DateTime(2026, 1, 24));

// 2. 배달부 (Provider)
final holidayProvider = Provider((ref) {
  final baseDate = ref.watch(workBaseDateProvider); // 24일

  return (DateTime day) {
    final cleanDay = DateTime(day.year, day.month, day.day);
    final cleanBase = DateTime(baseDate.year, baseDate.month, baseDate.day);
    final diff = cleanDay.difference(cleanBase).inDays;

    // 변경 전: diff % 2 != 0 (홀수 - 25일이 빨간색)
    // 변경 후: diff % 2 == 0 (짝수 - 24일, 26일...이 빨간색)
    return diff % 2 == 0;
  };
});