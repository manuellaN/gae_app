import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/fazer_report_page.dart';
import 'pages/meus_reports_page.dart';
import 'pages/termos_uso_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      // Tela inicial
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(username: '',),
        '/fazer-report': (context) => const FazerReportPage(),
        '/meus-reports': (context) => const MeusReportsPage(),
        '/termos-uso': (context) => const TermosUsoPage(),
        '/redefinir-senha': (context) => const TermosUsoPage(),
      },
    );
  }
}