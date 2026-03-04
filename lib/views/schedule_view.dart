import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

// 뷰모델과 모델을 가져옵니다.
import '../view_models/calendar_view_model.dart';
import '../models/holiday.dart';
import '../models/schedule.dart';

class ScheduleView extends ConsumerStatefulWidget {
  const ScheduleView({super.key});
  @override
  ConsumerState<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends ConsumerState<ScheduleView> {
  DateTime _selectedDay = DateTime.now();

  // 입력창 다이얼로그
  void _showAddDialog() {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('스케줄 추가'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(hintText: '제목')),
            TextField(controller: contentController, decoration: const InputDecoration(hintText: '내용')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소')),
          TextButton(
            onPressed: () {
              ref.read(scheduleProvider.notifier).addSchedule(
                  _selectedDay,
                  titleController.text,
                  contentController.text
              );
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isHoliday = ref.watch(holidayProvider);
    final scheduleState = ref.watch(scheduleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('격일 근무 달력')),
      body: scheduleState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('에러: $err')),
        data: (allSchedules) {
          final cleanDate = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
          final selectedSchedules = allSchedules[cleanDate] ?? [];

          return Column(
            children: [
              TableCalendar(
                locale: 'ko_KR',
                focusedDay: _selectedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) => setState(() => _selectedDay = selectedDay),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    if (isHoliday(day)) return Center(child: Text('${day.day}', style: const TextStyle(color: Colors.red)));
                    return null;
                  },
                  markerBuilder: (context, day, events) {
                    final d = DateTime(day.year, day.month, day.day);
                    if (allSchedules.containsKey(d)) {
                      return Positioned(bottom: 1, child: Container(width: 5, height: 5, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)));
                    }
                    return null;
                  },
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedSchedules.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(selectedSchedules[index].title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(selectedSchedules[index].content),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}