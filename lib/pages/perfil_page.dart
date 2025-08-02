import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final TextEditingController _nameController = TextEditingController(text: 'TesterApp123');
  final TextEditingController _emailController = TextEditingController(text: 'TesterApp123@gmail.com');
  final TextEditingController _passwordController = TextEditingController(text: '********');

  bool _isSaving = false;
  File? _avatarImage;

  // Guarda os valores originais para restaurar caso cancele
  late String _originalName;
  late String _originalEmail;
  late String _originalPassword;

  @override
  void initState() {
    super.initState();
    _originalName = _nameController.text;
    _originalEmail = _emailController.text;
    _originalPassword = _passwordController.text;
  }

  /// Escolhe imagem para o avatar
  Future<void> _pickAvatar() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });
    }
  }

  /// Simula envio para backend
  Future<void> _updateProfile() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1)); // simulação de request

    // Aqui você enviaria os dados e o avatar para o backend
    // await ApiService.updateProfile(name, email, password, _avatarImage);

    setState(() {
      _isSaving = false;
      _originalName = name;
      _originalEmail = email;
      _originalPassword = password;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil atualizado com sucesso!')),
    );
  }

  /// Mostra diálogo de confirmação ao cancelar
  Future<void> _showCancelDialog() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancelar alterações?', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 60),
            SizedBox(height: 12),
            Text(
              'Se você cancelar, todas as alterações feitas serão perdidas.',
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
      setState(() {
        _nameController.text = _originalName;
        _emailController.text = _originalEmail;
        _passwordController.text = _originalPassword;
        _avatarImage = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alterações canceladas.')),
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
                // Botão de voltar
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
                const SizedBox(height: 30),

                // Avatar editável
                GestureDetector(
                  onTap: _pickAvatar,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.purple, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.edit, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Campos de perfil
                _buildTextField(controller: _nameController, label: 'Nome', isPassword: false),
                const SizedBox(height: 16),
                _buildTextField(controller: _emailController, label: 'E-mail', isPassword: false),
                const SizedBox(height: 16),
                _buildTextField(controller: _passwordController, label: 'Senha', isPassword: true),
                const SizedBox(height: 40),

                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.purple,
                          side: const BorderSide(color: Colors.purple, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        child: _isSaving
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
                          backgroundColor: Colors.grey.shade800,
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
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool isPassword,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white54),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.purple),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}