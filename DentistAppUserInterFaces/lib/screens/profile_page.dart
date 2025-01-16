import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _ssidController = TextEditingController();

  String? _profileImageUrl;
  File? _imageFile;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          final data = userData.data()!;

          setState(() {
            _firstNameController.text = data['firstName'] ?? '';
            _lastNameController.text = data['lastName'] ?? '';
            _emailController.text = user.email ?? '';
            _ssidController.text = data['ssid'] ?? '';
            _profileImageUrl = data['profileImageUrl'];
          });

          print('Debug - Profile Image URL: $_profileImageUrl');
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      _showMessage('Kullanıcı bilgileri yüklenirken hata oluştu');
    }
  }

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

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return _profileImageUrl;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_profiles')
          .child(user.uid)
          .child('profile.jpg');

      await ref.putFile(_imageFile!);
      return await ref.getDownloadURL();
    } catch (e) {
      _showMessage('Resim yüklenirken hata oluştu: $e');
      return null;
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Şifre değişikliği kontrolü
      if (_currentPasswordController.text.isNotEmpty) {
        if (_newPasswordController.text != _confirmPasswordController.text) {
          _showMessage('Yeni şifreler eşleşmiyor');
          return;
        }

        // Mevcut şifreyi doğrula
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text);
      }

      // Profil resmini güncelle
      final imageUrl = await _uploadImage();

      // Kullanıcı bilgilerini güncelle
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        if (imageUrl != null) 'profileImageUrl': imageUrl,
      });

      setState(() {
        _profileImageUrl = imageUrl ?? _profileImageUrl;
      });

      _showMessage('Profil başarıyla güncellendi');

      // Şifre alanlarını temizle
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      _showMessage('Güncelleme sırasında hata oluştu: $e');
    } finally {
      setState(() => _isLoading = false);
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
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Profil Fotoğrafı
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[400],
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_profileImageUrl != null &&
                                  _profileImageUrl!.isNotEmpty
                              ? NetworkImage(_profileImageUrl!)
                              : null) as ImageProvider?,
                      child: (_imageFile == null &&
                              (_profileImageUrl == null ||
                                  _profileImageUrl!.isEmpty))
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt,
                              size: 18, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Ad Soyad
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Ad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Ad boş olamaz' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Soyad',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Soyad boş olamaz' : null,
              ),
              const SizedBox(height: 16),

              // Salt okunur email alanı
              TextFormField(
                controller: _emailController,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              // Salt okunur SSID alanı
              TextFormField(
                controller: _ssidController,
                readOnly: true,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'TC Kimlik No',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Color(0xFFE0E0E0),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              // Şifre Değiştirme Bölümü
              ExpansionTile(
                title: const Text('Şifre Değiştir'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Mevcut Şifre',
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() => _showPassword = !_showPassword);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: !_showPassword,
                          decoration: const InputDecoration(
                            labelText: 'Yeni Şifre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_currentPasswordController.text.isNotEmpty &&
                                (value?.length ?? 0) < 6) {
                              return 'Şifre en az 6 karakter olmalıdır';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: !_showPassword,
                          decoration: const InputDecoration(
                            labelText: 'Yeni Şifre (Tekrar)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (_currentPasswordController.text.isNotEmpty &&
                                value != _newPasswordController.text) {
                              return 'Şifreler eşleşmiyor';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Güncelle Butonu
              ElevatedButton(
                onPressed: _isLoading ? null : _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Güncelle',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _ssidController.dispose();
    super.dispose();
  }
}
