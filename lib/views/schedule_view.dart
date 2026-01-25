import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../view_models/calendar_view_model.dart';

class ScheduleView extends ConsumerWidget {
  const ScheduleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHoliday = ref.watch(holidayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('격일 근무 달력')),
      body: TableCalendar(
        // 혹은 버튼 자체를 아예 안 보이게 하고 싶다면?
        headerStyle: const HeaderStyle(
          formatButtonVisible: false, // 💡 이 줄을 추가하면 버튼이 아예 삭제됩니다.
          titleCentered: true,        // 월 이름(예: 2026년 1월)을 가운데로 정렬
        ),
        locale: 'ko_KR',
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: DateTime.now(),
        // 날짜별로 특별한 스타일을 입힐 때 사용
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            if (isHoliday(day)) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.redAccent, // 쉬는 날 빨간색
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${day.day}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            return null; // 근무일은 기본 스타일
          },
        ),
      ),
    );
  }
}