import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_storage.dart';
import 'fazer_report_page.dart';
import 'meus_reports_page.dart';
import 'termos_uso_page.dart';
import 'redefinir_senha_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final savedUser = await AuthStorage.getUser();
    setState(() {
      _user = savedUser;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      // Home
    } else if (index == 1) {
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
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MeusReportsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = _user?["name"] ?? "Usuário";

    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
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
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 20),
                  child: Text(
                    'Homepage',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9360FF),
                      fontSize: 14,
                    ),
                  ),
                ),

                // Saudação
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Olá,\n$username',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Botões
                _buildButton(
                  context,
                  'Fazer Report',
                  'Realizar um novo report',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FazerReportPage()),
                  ),
                ),
                _buildButton(
                  context,
                  'Meus Reports',
                  'Visualizar os reports já feitos',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MeusReportsPage()),
                  ),
                ),
                _buildButton(
                  context,
                  'Redefinir Senha',
                  'Realize a redefinição da sua senha',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RedefinirSenhaPage()),
                  ),
                ),
                _buildButton(
                  context,
                  'Termos de Uso',
                  'Leia os termos de uso do aplicativo',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TermosUsoPage()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Bottom Bar suspensa
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF2B0B4E).withOpacity(0.95),
              Colors.black.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 25,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
          selectedItemColor: const Color(0xFF9360FF),
          unselectedItemColor: Colors.white70,
          backgroundColor: Colors.transparent,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: ''),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.88,
        child: Card(
          color: Colors.white10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            title: Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            subtitle: Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
