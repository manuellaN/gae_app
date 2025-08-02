import 'package:flutter/material.dart';

class FazerReportPage extends StatelessWidget {
  const FazerReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fazer Report')),
      body: const Center(
        child: Text('Conteúdo da página de report'),
      ),
    );
  }
}