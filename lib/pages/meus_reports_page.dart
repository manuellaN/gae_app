import 'package:flutter/material.dart';

class MeusReportsPage extends StatelessWidget {
  const MeusReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus reports')),
      body: const Center(
        child: Text('Conteúdo da página de report'),
      ),
    );
  }
}