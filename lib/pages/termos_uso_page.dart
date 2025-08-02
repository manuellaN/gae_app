import 'package:flutter/material.dart';

class TermosUsoPage extends StatelessWidget {
  const TermosUsoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B0B4E), Colors.black],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botão de voltar
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: const [
                          Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          SizedBox(width: 4),
                          Text(
                            'Voltar',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.home, color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Título
                const Text(
                  'Termos de Uso',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Do aplicativo',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF9360FF),
                  ),
                ),
                const SizedBox(height: 8),

                // Linha divisória
                Container(
                  height: 2,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                ),

                // Cláusulas
                _buildClausula(
                  '1. Primeira Clausula',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
                _buildClausula(
                  '2. Segunda Clausula',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
                _buildClausula(
                  '3. Terceira Clausula',
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget para criar cada cláusula
  Widget _buildClausula(String titulo, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 25, right: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}