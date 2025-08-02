import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';


class FazerReportPage extends StatefulWidget {
  const FazerReportPage({super.key});

  @override
  State<FazerReportPage> createState() => _FazerReportPageState();
}

class _FazerReportPageState extends State<FazerReportPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<File> _attachedImages = [];
  bool _isSending = false;

  /// Escolher imagens da galeria
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _attachedImages = images.map((img) => File(img.path)).toList();
      });
    }
  }

  /// Simula envio do reporte para backend
  Future<void> _sendReport() async {
  if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha ao menos o título e descrição!')),
    );
    return;
  }

  setState(() => _isSending = true);
  await Future.delayed(const Duration(seconds: 1));

  // Cria o objeto de reporte
  final newReport = Report(
    title: _titleController.text,
    description: _descriptionController.text,
    location: _locationController.text,
    date: DateTime.now(),
    images: List.from(_attachedImages),
  );

  // Salva no serviço global
  ReportService().addReport(newReport);

  setState(() {
    _isSending = false;
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _attachedImages.clear();
  });

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Reporte enviado com sucesso!')),
  );
}

  /// Diálogo de confirmação de cancelamento
  Future<void> _showCancelDialog() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancelar reporte?', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 60),
            SizedBox(height: 12),
            Text(
              'Se você cancelar, todas as informações preenchidas serão perdidas.',
              style: TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      setState(() => _attachedImages.clear());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte cancelado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Botão voltar
                Row(
                  children: [
                    GestureDetector(
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
                  ],
                ),
                const SizedBox(height: 20),

                // Área de anexar imagens
                GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color:Color(0xFF9747FF).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _attachedImages.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_circle_outline, color: Colors.white, size: 40),
                              SizedBox(height: 8),
                              Text(
                                'Clique para anexar imagens',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(8),
                            itemCount: _attachedImages.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _attachedImages[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Título e subtítulo
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Reportar um problema',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Não esqueça as principais informações',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 20),

                // Campos de texto
                _buildTextField(_titleController, 'Título', false),
                const SizedBox(height: 16),
                _buildTextField(_descriptionController, 'Descreva o problema', false, maxLines: 5),
                const SizedBox(height: 16),
                _buildTextField(_locationController, 'Local', false),
                const SizedBox(height: 30),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _isSending ? null : _sendReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Color(0xFF9747FF),
                          side: const BorderSide(color: Color(0xFF9747FF), width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _isSending
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Confirmar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: 140,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _showCancelDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white10,
                          foregroundColor: Colors.white54,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('Cancelar', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Campo de texto customizado
  Widget _buildTextField(TextEditingController controller, String label, bool isPassword,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF9747FF)),
        filled: true,
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9747FF)),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }
}
