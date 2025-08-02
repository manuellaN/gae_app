import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../models/report_model.dart';
import 'fazer_report_page.dart';
import 'report_detail_page.dart';

class MeusReportsPage extends StatefulWidget {
  const MeusReportsPage({super.key});

  @override
  State<MeusReportsPage> createState() => _MeusReportsPageState();
}

class _MeusReportsPageState extends State<MeusReportsPage> {
  @override
  Widget build(BuildContext context) {
    final reports = ReportService().reports.reversed.toList(); // mais recentes primeiro

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
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
                    children: const [
                      Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text('Voltar', style: TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(width: 4),
                      Icon(Icons.home, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Meus Reports',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Linha divisória
                Container(
                  height: 2,
                  color: Colors.white24,
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),

              Expanded(
                child: reports.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum reporte realizado ainda.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: reports.length + 1, // +1 para o botão final
                        itemBuilder: (context, index) {
                          if (index == reports.length) {
                            return _buildNewReportButton(context);
                          }
                          final report = reports[index];
                          return _buildReportCard(report);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportCard(Report report) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  color: Color(0xFF9747FF).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.article_outlined, color:Color(0xFF9747FF), size: 30),
              ),
        title: Text(
          report.title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              report.description.length > 40
                  ? '${report.description.substring(0, 40)}...'
                  : report.description,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              '${report.date.day}/${report.date.month}/${report.date.year}',
              style: const TextStyle(color: Colors.white38, fontSize: 12),
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

  Widget _buildNewReportButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: OutlinedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FazerReportPage()),
    ).then((_) => setState(() {}));
  },
  style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Color(0xFF9747FF), width: 2),
    foregroundColor: Color(0xFF9747FF),
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
  ),
  icon: const Icon(Icons.add),
  label: const Text('REPORTAR', style: TextStyle(fontSize: 16)),
),
      ),
    );
  }
}