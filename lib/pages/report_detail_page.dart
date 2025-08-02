import 'package:flutter/material.dart';
import '../models/report_model.dart';

class ReportDetailPage extends StatelessWidget {
  final Report report;
  const ReportDetailPage({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
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

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        report.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${report.date.day}/${report.date.month}/${report.date.year}',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 20),

                      // Galeria de imagens
                      if (report.images.isNotEmpty)
                        SizedBox(
                          height: 160,
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
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      if (report.images.isNotEmpty) const SizedBox(height: 20),

                      // Descrição completa
                      Text(
                        report.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.4),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),

                      // Local
                      if (report.location.isNotEmpty)
                        Text(
                          'Local: ${report.location}',
                          style: const TextStyle(color: Colors.purpleAccent, fontSize: 16),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
