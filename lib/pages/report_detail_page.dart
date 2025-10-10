import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class ReportDetailPage extends StatefulWidget {
  final dynamic report; // mantém compatibilidade com MeusReportsPage
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
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();

    // extrai id do objeto report passado (compatível com o que você já tem)
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
      // busca detalhe, fotos e mensagens (mensagens agora são maps)
      final detail = await ApiService.fetchProblemDetail(_reportId);
      final photos = await ApiService.fetchProblemPhotos(_reportId);
      final messages = await ApiService.fetchProblemMessages(_reportId);

      setState(() {
        _detail = detail;
        _photos = photos;
        _messages = messages.map((m) {
          // garante que cada item seja Map<String,dynamic>
          if (m is Map<String, dynamic>) return m;
          return {'message': m.toString()};
        }).toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Color _statusColor(String status) {
    switch (status.toString().toUpperCase()) {
      case 'RESOLVIDO':
        return Colors.green;
      case 'EM ANÁLISE':
      case 'EM_ANALISE':
        return Colors.orange;
      case 'ABERTO':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  String _formatDateFromDetail() {
    final d = _detail?['createdAt'] ?? _detail?['created_at'] ?? widget.report['createdAt'] ?? widget.report['created_at'] ?? widget.report['date'];
    if (d == null) return "";
    try {
      final dt = d is String ? DateTime.parse(d) : (d is DateTime ? d : DateTime.parse(d.toString()));
      // formato dd/mm/aaaa
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return d.toString();
    }
  }

  String _formatMessageDate(String? raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw);
      final h = dt.hour.toString().padLeft(2, '0');
      final m = dt.minute.toString().padLeft(2, '0');
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} $h:$m';
    } catch (_) {
      return raw;
    }
  }

  String _toPhotoUrl(String raw) {
    if (raw.startsWith("http://") || raw.startsWith("https://")) return raw;
    // ajuste conforme seu servidor (ex.: /uploads/ ou /storage/)
    return "${ApiService.baseUrl.replaceAll('/api', '')}/uploads/$raw";
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF131313),
        body: SafeArea(child: Center(child: CircularProgressIndicator())),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFF131313),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        const SizedBox(width: 6),
                        Text('Voltar', style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Text("Erro ao carregar os dados:", style: GoogleFonts.inter(color: Colors.white)),
                const SizedBox(height: 8),
                Text(_error!, style: GoogleFonts.inter(color: Colors.redAccent)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _loadData, child: const Text("Tentar novamente")),
              ],
            ),
          ),
        ),
      );
    }

    // dados carregados com sucesso
    final reportMap = _detail ?? {};
    final statusRaw = (reportMap['status'] ?? '').toString();
    final status = statusRaw.isNotEmpty ? statusRaw : (widget.report['status']?.toString() ?? 'ABERTO');

    final category = reportMap['category'] ?? reportMap['title'] ?? widget.report['category'] ?? widget.report['title'] ?? 'Sem título';
    final description = reportMap['description'] ?? widget.report['description'] ?? '';
    final location = reportMap['local'] ?? reportMap['location'] ?? widget.report['local'] ?? widget.report['location'] ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Voltar
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                      const SizedBox(width: 6),
                      Text('Voltar', style: GoogleFonts.inter(color: Colors.white, fontSize: 16)),
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status,
                        style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                    ),
                    Text(
                      _formatDateFromDetail(),
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- GALERIA DE FOTOS (FORA DO CARD PRINCIPAL, APÓS STATUS/DATA) ---
              if (_photos.isNotEmpty)
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      final photoRaw = _photos[index];
                      final url = _toPhotoUrl(photoRaw);
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
                              return Container(width: 140, height: 140, color: Colors.white10, child: const Icon(Icons.broken_image, color: Colors.white54));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                )
              else
                // Placeholder quando não houver fotos
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.photo, size: 36, color: Colors.white38),
                        const SizedBox(height: 8),
                        Text('Sem fotos disponíveis', style: GoogleFonts.inter(color: Colors.white54)),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Card principal com descrição e imagens (agora sem a galeria dentro)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // título = category
                  Text(
                    category,
                    style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 8),
                  Text(description, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14, height: 1.4)),
                  const SizedBox(height: 16),

                  if (location.toString().isNotEmpty)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Local: ',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF9747FF),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: location.toString(),
                            style: GoogleFonts.inter(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 20),
                ]),
              ),

              const SizedBox(height: 20),

              // Mensagens / devolutivas do ADM (usa senderName e sendDate)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.35), borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Devolutiva:', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
                  const SizedBox(height: 12),
                  if (_messages.isEmpty)
                    Text('Nenhuma mensagem do admin.', style: GoogleFonts.inter(color: Colors.white54))
                  else
                    ..._messages.map((msg) {
                      final author = msg['senderName'] ?? msg['sender'] ?? 'Administrador';
                      final text = msg['message'] ?? msg['text'] ?? '';
                      final sendDateRaw = msg['sendDate'] ?? msg['sendAt'] ?? msg['createdAt'] ?? msg['date'];
                      final formattedSendDate = _formatMessageDate(sendDateRaw?.toString());
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Icon(Icons.message_rounded, size: 18, color: Color(0xFF9747FF)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: "$author", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                  if (formattedSendDate.isNotEmpty) TextSpan(text: " • $formattedSendDate", style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                                ]),
                              ),
                              const SizedBox(height: 6),
                              Text(text, style: GoogleFonts.inter(color: Colors.white70, fontSize: 14)),
                            ]),
                          ),
                        ]),
                      );
                    }),
                ]),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
