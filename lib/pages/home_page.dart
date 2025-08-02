import 'package:flutter/material.dart';
// Importe aqui as páginas que serão abertas ao clicar nos cards/avatar
import 'fazer_report_page.dart';
import 'meus_reports_page.dart';
import 'perfil_page.dart';
import 'termos_uso_page.dart';

class HomePage extends StatelessWidget {
  final String username; // adiciona essa variável

  const HomePage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B0B4E), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar customizada...
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Homepage',
                      style: TextStyle(color: Colors.purpleAccent, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        // exemplo de navegação
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/avatar.png'),
                      ),
                    ),
                  ],
                ),
              ),

              // Saudação dinâmica
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Olá,\n$username', // usa a variável recebida
                  style: const TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botões em cards com navegação
              _buildButton(
                context,
                'Fazer Report',
                'Fazer um novo report',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FazerReportPage()),
                ),
              ),
              _buildButton(
                context,
                'Meus Report',
                'Visualizar os reports já feitos',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MeusReportsPage()),
                ),
              ),
              _buildButton(
                context,
                'Meu Perfil',
                'Visualize e edite suas informações',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilPage()),
                ),
              ),
              _buildButton(
                context,
                'Termos de uso',
                'Leia os termos de uso do aplicativo',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TermosUsoPage()),
                ),
              ),

              const Spacer(),

              // Bottom Navigation
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                height: 70,
                decoration: const BoxDecoration(color: Colors.black),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home, color: Colors.white),
                      onPressed: () {},
                    ),
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Color(0xFF9747FF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => const FazerReportPage(),
      transitionsBuilder: (_, animation, __, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    ),
  );

                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.article_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MeusReportsPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Card genérico com função de navegação
  Widget _buildButton(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:40, vertical: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.88, // 88% da tela
        child: Card(
          color: Colors.white10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            subtitle: Text(subtitle, style: const TextStyle(color: Colors.white54)),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
