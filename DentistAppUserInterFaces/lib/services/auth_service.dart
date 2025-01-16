import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Profil fotoğrafını yükle
  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Storage referansını oluştur
      final storageRef = _storage.ref().child('profile_images/$userId.jpg');

      // Resmi yükle
      await storageRef.putFile(imageFile);

      // Resmin URL'sini al
      final downloadUrl = await storageRef.getDownloadURL();

      // Firestore'daki kullanıcı dokümanını güncelle
      await _firestore.collection('users').doc(userId).update({
        'profileImageUrl': downloadUrl,
      });

      return downloadUrl;
    } catch (e) {
      print('Profil fotoğrafı yükleme hatası: $e');
      return null;
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String ssid,
    required BuildContext context,
    File? profileImage, // Profil fotoğrafı parametresi eklendi
  }) async {
    try {
      // Loading göster
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Kullanıcı oluştur
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String? profileImageUrl;

        // Eğer profil fotoğrafı seçildiyse yükle
        if (profileImage != null) {
          profileImageUrl = await uploadProfileImage(
            profileImage,
            userCredential.user!.uid,
          );
        }

        // Firestore'a kullanıcı bilgilerini kaydet
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'dateOfBirth': dateOfBirth,
          'ssid': ssid,
          'createdAt': FieldValue.serverTimestamp(),
          'role': 'patient',
          'profileImageUrl': profileImageUrl, // Profil fotoğrafı URL'si
        });

        // Loading'i kapat
        if (context.mounted) {
          Navigator.of(context).pop();
        }

        // Başarı mesajı göster
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kayıt başarılı! Giriş yapabilirsiniz.'),
              backgroundColor: Colors.green,
            ),
          );
        }

        // Login sayfasına yönlendir
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bir hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Profil fotoğrafını güncelle
  Future<void> updateProfileImage({
    required File imageFile,
    required BuildContext context,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw 'Kullanıcı oturum açmamış';

      // Loading göster
      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      // Profil fotoğrafını yükle
      final downloadUrl = await uploadProfileImage(imageFile, user.uid);

      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (downloadUrl != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil fotoğrafı güncellendi'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil fotoğrafı güncellenirken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> signout() async {
    await _auth.signOut();
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/appointment',
          arguments: email,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Giriş hatası: $e')),
        );
      }
    }
  }
}
