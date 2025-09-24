import 'package:flutter/material.dart';
import 'package:gae_app/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'report_detail_page.dart';
import 'fazer_report_page.dart';
import 'home_page.dart';

class MeusReportsPage extends StatefulWidget {
  const MeusReportsPage({super.key});

  @override
  State<MeusReportsPage> createState() => _MeusReportsPageState();
}

class _MeusReportsPageState extends State<MeusReportsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 2;

  List<dynamic> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchUserReports();
  }

  Future<void> _fetchUserReports() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.fetchUserReports();
      setState(() {
        _reports = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  void _onBottomNavTap(int index) {
    setState(() => _currentIndex = index);

    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
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
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              // Voltar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text('Voltar', style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
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

              // Abas
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
                      Tab(text: 'Aberto'),
                      Tab(text: 'Em análise'),
                      Tab(text: 'Resolvido'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _reports.isEmpty
                        ? Center(
                            child: Text(
                              'Nenhum reporte encontrado.',
                              style: GoogleFonts.inter(color: Colors.white54),
                            ),
                          )
                        : TabBarView(
                            controller: _tabController,
                            children: [
                              _buildReportList("ABERTO"),
                              _buildReportList("EM_ANALISE"),
                              _buildReportList("RESOLVIDO"),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation
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

  /// Cria a lista de reports para o status atual
  Widget _buildReportList(String status) {
    final filtered = _reports.where((r) => (r["status"] ?? "").toUpperCase() == status).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          'Nenhum reporte nesta aba.',
          style: GoogleFonts.inter(color: Colors.white54),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final report = filtered[index];
        return _buildReportCard(report);
      },
    );
  }

  Widget _buildReportCard(dynamic report) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF9360FF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.article_outlined, color: Color(0xFF9360FF), size: 30),
        ),
        title: Text(
          report["category"] ?? "Sem categoria",
          style: GoogleFonts.inter(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              report["description"] ?? "Sem descrição",
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Local: ${report["local"] ?? "indefinido"}",
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
            ),
            const SizedBox(height: 2),
            Text(
              "Status: ${report["status"] ?? "indefinido"}",
              style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportDetailPage(report: report),
            ),
          );
        },
      ),
    );
  }
}
