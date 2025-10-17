import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart'; // ajuste o caminho conforme seu projeto
import 'meus_reports_page.dart';

class FazerReportPage extends StatefulWidget {
  const FazerReportPage({super.key});

  @override
  State<FazerReportPage> createState() => _FazerReportPageState();
}

class _FazerReportPageState extends State<FazerReportPage> {
  final TextEditingController _descriptionController = TextEditingController();

  List<File> _attachedImages = [];
  bool _isSending = false;

  // Dados reais da API
  List<Map<String, dynamic>> _categoriesData = [];
  List<Map<String, dynamic>> _locationsData = [];

  String? _selectedCategoryName;
  String? _selectedLocationName;

  @override
  void initState() {
    super.initState();
    _fetchDropdownData();
  }

  Future<void> _fetchDropdownData() async {
    try {
      final localRes = await http.get(Uri.parse("https://restapi.santosdev.site/local"));
      final categoryRes = await http.get(Uri.parse("https://restapi.santosdev.site/category"));

      if (localRes.statusCode == 200 && categoryRes.statusCode == 200) {
        final List<dynamic> localJson = jsonDecode(localRes.body);
        final List<dynamic> categoryJson = jsonDecode(categoryRes.body);

        setState(() {
          _locationsData = List<Map<String, dynamic>>.from(localJson);
          _categoriesData = List<Map<String, dynamic>>.from(categoryJson);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao carregar categorias/locais")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _attachedImages = images.map((img) => File(img.path)).toList();
      });
    }
  }

  /// ====> NOVO MÉTODO INTEGRADO
  Future<void> _sendReport() async {
    if (_selectedCategoryName == null ||
        _selectedLocationName == null ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios!')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      // Obter os IDs com base no nome selecionado
      final selectedCategory = _categoriesData.firstWhere(
        (cat) => cat['name'] == _selectedCategoryName,
        orElse: () => throw Exception('Categoria não encontrada'),
      );

      final selectedLocation = _locationsData.firstWhere(
        (loc) => loc['name'] == _selectedLocationName,
        orElse: () => throw Exception('Local não encontrado'),
      );

      await ApiService.sendProblemReport(
        description: _descriptionController.text,
        categoryId: selectedCategory['id'],
        locationId: selectedLocation['id'],
        images: _attachedImages,
      );

      setState(() => _isSending = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reporte enviado com sucesso!")),
      );

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (_, animation, __) => const MeusReportsPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      setState(() => _isSending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao enviar: $e")),
      );
    }
  }

  Future<void> _showCancelDialog() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Cancelar reporte?',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          'Se você cancelar, todas as informações preenchidas serão perdidas.',
          style: GoogleFonts.inter(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Não', style: GoogleFonts.inter(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Sim', style: GoogleFonts.inter(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _descriptionController.clear();
      _attachedImages.clear();
      setState(() {
        _selectedCategoryName = null;
        _selectedLocationName = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte cancelado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
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
                ],
              ),
              const SizedBox(height: 24),

              // Imagens
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9747FF).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _attachedImages.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_circle_outline,
                                color: Colors.white, size: 40),
                            const SizedBox(height: 8),
                            Text('Clique para anexar imagens',
                                style: GoogleFonts.inter(
                                    color: Colors.white, fontSize: 16)),
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
              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reportar um problema',
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              _buildDropdown(
                label: "Categoria",
                value: _selectedCategoryName,
                items: _categoriesData.map((e) => e['name'].toString()).toList(),
                onChanged: (val) => setState(() => _selectedCategoryName = val),
              ),
              const SizedBox(height: 20),

              _buildTextField(_descriptionController, 'Descreva o problema', maxLines: 5),
              const SizedBox(height: 20),

              _buildDropdown(
                label: "Local",
                value: _selectedLocationName,
                items: _locationsData.map((e) => e['name'].toString()).toList(),
                onChanged: (val) => setState(() => _selectedLocationName = val),
              ),
              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _showCancelDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white10,
                        foregroundColor: Colors.white54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Cancelar', style: GoogleFonts.inter(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 140,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSending ? null : _sendReport,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: const Color(0xFF9747FF),
                        side: const BorderSide(color: Color(0xFF9747FF), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _isSending
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text('Confirmar', style: GoogleFonts.inter(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w500),
        floatingLabelStyle:
            GoogleFonts.inter(color: const Color(0xFF9747FF), fontWeight: FontWeight.w600),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9747FF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xFF131313),
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: GoogleFonts.inter(color: Colors.white),
        floatingLabelStyle:
            GoogleFonts.inter(color: const Color(0xFF9747FF), fontWeight: FontWeight.w600),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white54, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF9747FF), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items
          .map((item) =>
              DropdownMenuItem(value: item, child: Text(item, style: GoogleFonts.inter())))
          .toList(),
      onChanged: onChanged,
    );
  }
}
