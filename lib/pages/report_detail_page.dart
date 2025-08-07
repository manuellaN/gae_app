import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/report_model.dart';

class ReportDetailPage extends StatefulWidget {
  final Report report;
  const ReportDetailPage({super.key, required this.report});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  // Simulação de devolutivas do ADM
  final List<String> _adminMessages = [
    'Estamos analisando o problema.',
    'O eletricista foi acionado.',
    'Conserto agendado para amanhã.',
  ];

  // Simulação de status do report
  final List<String> _statusOptions = ['Pendente', 'Em andamento', 'Concluído'];

  late String _statusSimulado;

  @override
  void initState() {
    super.initState();
    // Simula o status do report de forma aleatória (ou você pode amarrar a lógica real depois)
    _statusSimulado = (_statusOptions..shuffle()).first;
  }

  Color _statusColor() {
    switch (_statusSimulado) {
      case 'Concluído':
        return Colors.green;
      case 'Em andamento':
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botão voltar
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text('Voltar',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                      const SizedBox(width: 6),
                      const Icon(Icons.home, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Card superior com status e data
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF9747FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status com cor dinâmica
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _statusSimulado,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Text(
                      '${_formatDate(report.date)}',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Card principal com descrição e imagens
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.description,
                      style: GoogleFonts.inter(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),

                    // Local
                    if (report.location.isNotEmpty)
                      Text(
                        'Local: ${report.location}',
                        style: GoogleFonts.inter(color: const Color(0xFF9747FF), fontSize: 14),
                      ),
                    const SizedBox(height: 20),

                    // Galeria de imagens
                    if (report.images.isNotEmpty)
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: report.images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  report.images[index],
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Card de devolutivas do ADM
              if (_adminMessages.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Devolutiva:',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ..._adminMessages.map((msg) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.message_rounded,
                                    size: 18, color: Color(0xFF9747FF)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    msg,
                                    style: GoogleFonts.inter(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  /// Formata a data para "Terça - 20/03"
  String _formatDate(DateTime date) {
    const weekdays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday - ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}
