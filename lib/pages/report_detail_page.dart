import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class ReportDetailPage extends StatefulWidget {
  final dynamic report;
  const ReportDetailPage({super.key, required this.report});

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  bool _loading = true;
  String? _error;
  late int _reportId;

  Map<String, dynamic>? _detail;
  List<String> _photos = [];
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();

    final r = widget.report;
    if (r is Map && (r['id'] != null || r['problem_id'] != null)) {
      _reportId = (r['id'] ?? r['problem_id']) as int;
    } else if (r is int) {
      _reportId = r;
    } else {
      _error = "ID do reporte não encontrado.";
      _loading = false;
      return;
    }

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final detail = await ApiService.fetchProblemDetail(_reportId);
      final photos = await ApiService.fetchProblemPhotos(_reportId);
      final messages = await ApiService.fetchProblemMessages(_reportId);

      setState(() {
        _detail = detail;
        _photos = photos;
        _messages = messages;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Define cor conforme status
  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case 'RESOLVIDO':
        return Colors.green;
      case 'EM ANÁLISE':
        return Colors.orange;
      case 'ABERTO':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  /// Formata data (createdAt)
  String _formatDate() {
    final d = _detail?['createdAt'] ?? _detail?['created_at'];
    if (d == null) return '';
    try {
      final dt = DateTime.parse(d.toString());
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return d.toString();
    }
  }

  /// Converte caminho bruto em URL de imagem
  String _toPhotoUrl(String raw) {
    if (raw.startsWith("http")) return raw;
    return "${ApiService.baseUrl.replaceAll('/api', '')}/uploads/$raw";
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF131313),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF131313),
        body: Center(
          child: Text(
            "Erro: $_error",
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    final report = _detail!;
    final status = report['status'] ?? 'Desconhecido';
    final title = report['category'] ?? 'Sem título';
    final description = report['description'] ?? '';
    final location = report['local'] ?? '';
    final formattedDate = _formatDate();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voltar
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.white),
                    const SizedBox(width: 6),
                    Text('Voltar',
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // STATUS + DATA
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF9747FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: GoogleFonts.inter(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // CARD PRINCIPAL
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
                      title,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.inter(
                          color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 16),
                    if (location.isNotEmpty)
                      Text(
                        'Local: $location',
                        style: GoogleFonts.inter(
                            color: const Color(0xFF9747FF), fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    const SizedBox(height: 20),

                    // FOTOS
                    if (_photos.isNotEmpty)
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photos.length,
                          itemBuilder: (context, index) {
                            final url = _toPhotoUrl(_photos[index]);
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  url,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 140,
                                      height: 140,
                                      color: Colors.white10,
                                      child: const Icon(Icons.broken_image,
                                          color: Colors.white54),
                                    );
                                  },
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

              // DEVOLUTIVA
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
                    Text('Devolutiva:',
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                    const SizedBox(height: 12),
                    if (_messages.isEmpty)
                      Text('Nenhuma mensagem do admin.',
                          style: GoogleFonts.inter(color: Colors.white54))
                    else
                      ..._messages.map(
                        (msg) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.message_rounded,
                                  size: 18, color: Color(0xFF9747FF)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(msg,
                                    style: GoogleFonts.inter(
                                        color: Colors.white70, fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
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
}
