// lib/view_models/calendar_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/holiday.dart';

final workBaseDateProvider = Provider<DateTime>((_) => DateTime(2026, 1, 24));

final holidayProvider = Provider((ref) {
  // 1. 기준일 데이터를 가져옵니다.
  final baseDate = ref.watch(workBaseDateProvider);

  // 2. ⭐ Model 객체를 생성합니다. (여기서 연결이 일어납니다!)
  final model = WorkStatus(baseDate: baseDate);

  // 3. ⭐ Model이 가진 'isHoliday' 함수 자체를 반환합니다.
  // 이제 View에서 이 함수를 호출하면 Model의 로직이 실행됩니다.
  return model.isHoliday;
});