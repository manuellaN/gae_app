import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/home_page.dart';
import 'pages/fazer_report_page.dart';
import 'pages/meus_reports_page.dart';
import 'pages/perfil_page.dart';
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
      ),
      // Tela inicial
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(username: '',),
        '/fazer-report': (context) => const FazerReportPage(),
        '/meus-reports': (context) => const MeusReportsPage(),
        '/perfil': (context) => const PerfilPage(),
        '/termos-uso': (context) => const TermosUsoPage(),
      },
    );
  }
}