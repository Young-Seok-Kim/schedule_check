import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 💡 이 줄이 꼭 있어야 합니다!
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod 필수 임포트
import 'package:hive_flutter/hive_flutter.dart';

import 'views/schedule_view.dart'; // 우리가 만든 달력 화면

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // ⭐ Hive 초기화 필수!
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '격일 근무 달력',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),

      // --- 여기부터 추가되는 한국어 설정 코드 ---
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'), // 한국어 지원
      ],
      locale: const Locale('ko', 'KR'), // 앱 언어를 한국어로 강제 설정
      // --- 여기까지 ---

      home: const ScheduleView(),
    );
  }}