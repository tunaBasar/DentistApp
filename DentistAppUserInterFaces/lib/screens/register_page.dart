import 'dart:io';
import 'package:flutter/material.dart';
import 'package:appointment_project/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController ssidController = TextEditingController();

  final AuthService _authService = AuthService();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      _showMessage('Resim seçilirken hata oluştu: $e');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profil Fotoğrafı Seçici
                GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[400],
                        backgroundImage:
                            _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.add_a_photo,
                                size: 40, color: Colors.white)
                            : null,
                      ),
                      if (_imageFile != null)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 18,
                            child: IconButton(
                              icon: const Icon(Icons.edit,
                                  size: 18, color: Colors.white),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'KAYIT OL',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25),
                _buildTextField(
                  controller: firstNameController,
                  hintText: 'Ad',
                  icon: Icons.person,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: lastNameController,
                  hintText: 'Soyad',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: passwordController,
                  hintText: 'Şifre',
                  icon: Icons.lock,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: confirmPasswordController,
                  hintText: 'Şifre Tekrar',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: dateOfBirthController,
                  hintText: 'Doğum Tarihi (GG.AA.YYYY)',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: ssidController,
                  hintText: 'TC Kimlik No',
                  icon: Icons.badge,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : () => _handleRegister(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (!_validateForm(context)) return;

    setState(() => _isLoading = true);

    try {
      // Önce kullanıcıyı kaydet ve Firebase Auth UID'sini al
      await _authService.signup(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        dateOfBirth: dateOfBirthController.text.trim(),
        ssid: ssidController.text.trim(),
        profileImage: _imageFile,
        context: context,
      );
    } catch (e) {
      _showMessage('Kayıt olurken hata oluştu: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateForm(BuildContext context) {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty ||
        dateOfBirthController.text.trim().isEmpty ||
        ssidController.text.trim().isEmpty) {
      _showMessage('Lütfen tüm alanları doldurun');
      return false;
    }

    if (passwordController.text != confirmPasswordController.text) {
      _showMessage('Şifreler eşleşmiyor');
      return false;
    }

    if (ssidController.text.length != 11) {
      _showMessage('TC Kimlik No 11 haneli olmalıdır');
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dateOfBirthController.dispose();
    ssidController.dispose();
    super.dispose();
  }
}
