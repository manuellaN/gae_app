import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/report_service.dart';
import '../models/report_model.dart';
import 'report_detail_page.dart';
import 'fazer_report_page.dart';
import 'home_page.dart';

class MeusReportsPage extends StatefulWidget {
  const MeusReportsPage({super.key});

  @override
  State<MeusReportsPage> createState() => _MeusReportsPageState();
}

class _MeusReportsPageState extends State<MeusReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 2; // índice para bottom bar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: 'TesterApp123')),
      );
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final reports = ReportService().reports.reversed.toList();
    final aberto = reports.where((r) => r.status == 'aberto').toList();
    final em_analise = reports.where((r) => r.status == 'em_análise').toList();
    final resolvido = reports.where((r) => r.status == 'resolvido').toList();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Botão voltar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        'Voltar',
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.home, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              // Título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Text(
                  'Meus Reports',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 12),

            
              // Abas modernas tipo botões
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: const Color(0xFF9747FF),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white54,
                    labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(text: 'Em aberto'),
                      Tab(text: 'Em análise'),
                      Tab(text: 'Resolvido'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildReportList(aberto),
                    _buildReportList(em_analise),
                    _buildReportList(resolvido),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom bar igual à da Home
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: 36),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportList(List<Report> reports) {
    if (reports.isEmpty) {
      return Center(
        child: Text(
          'Nenhum reporte nesta aba.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(Report report) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: report.images.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  report.images.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF9360FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.article_outlined,
                    color: Color(0xFF9360FF), size: 30),
              ),
        title: Text(
          report.title,
          style: GoogleFonts.inter(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              report.description.length > 40
                  ? '${report.description.substring(0, 40)}...'
                  : report.description,
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${report.date.day}/${report.date.month}/${report.date.year} - Status: ${report.status}',
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReportDetailPage(report: report)),
          );
        },
      ),
    );
  }
}
