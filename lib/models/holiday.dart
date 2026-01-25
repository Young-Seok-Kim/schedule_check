class WorkStatus {
  final DateTime baseDate; // 기준이 되는 첫 근무일

  WorkStatus({required this.baseDate});

  // 기준일로부터 차이가 짝수면 근무, 홀수면 휴무 (격일)
  bool isHoliday(DateTime day) {
    final difference = day.difference(baseDate).inDays;
    return difference.isOdd; // 홀수 번째 날을 쉬는 날로 가정
  }
}