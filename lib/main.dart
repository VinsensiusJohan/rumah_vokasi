import 'package:flutter/material.dart';
import 'package:rumah_vokasi/core/config/custom_scroll.dart';
import 'package:rumah_vokasi/features/course/presentasions/quiz_work_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: CustomScrollBehavior(),
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          surface: Colors.white,
        ),
      ),
      home: QuizWorkPage(
        quizID: "preview",
        courseID: "preview",
        isPreview: true,
      ),
      //LoginRegisterPage(),
    );
  }
}
