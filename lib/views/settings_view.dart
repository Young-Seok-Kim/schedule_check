// lib/views/settings_view.dart  <-- 완전히 다른 파일입니다!
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../view_models/calendar_view_model.dart';
// 기준일이 선언된 파일을 임포트합니다.
class SettingsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ⭐ 여기서 다시 선언할 필요 없이, 배달부(ref)에게 시키면 끝!
    // 어느 파일에서 부르든 똑같은 '2026년 1월 24일'을 가져옵니다.
    final baseDate = ref.watch(workBaseDateProvider);

    return Scaffold(
      appBar: AppBar(title: Text("설정")),
      body: Center(
        child: Text(
          "현재 설정된 근무 기준일은\n${baseDate.year}년 ${baseDate.month}월 ${baseDate.day}일 입니다.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}