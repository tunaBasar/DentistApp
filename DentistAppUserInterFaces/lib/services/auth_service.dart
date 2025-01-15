import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String dateOfBirth,
    required String ssid,
    required BuildContext context,
  }) async {
    try {
      print('Kayıt işlemi başlıyor...'); // Debug log

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

      print('Firebase Authentication başlıyor...'); // Debug log

      // Kullanıcı oluştur
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('Kullanıcı oluşturuldu: ${userCredential.user?.uid}'); // Debug log

      // Firestore'a kullanıcı bilgilerini kaydet
      if (userCredential.user != null) {
        try {
          print('Firestore\'a veri kaydediliyor...'); // Debug log

          final userData = {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'dateOfBirth': dateOfBirth,
            'ssid': ssid,
            'createdAt': Timestamp.now(),
            'role': 'patient',
            'userId': userCredential.user!.uid,
          };

          print('Veri yapısı hazırlandı: $userData'); // Debug log

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userData)
              .then((_) => print('Firestore\'a veri kaydedildi')) // Debug log
              .catchError(
                  (error) => print('Firestore hatası: $error')); // Debug log

          print('Kayıt işlemi tamamlandı'); // Debug log

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
                duration: Duration(seconds: 2),
              ),
            );
          }

          // Login sayfasına yönlendir
          if (context.mounted) {
            await Future.delayed(const Duration(seconds: 2));
            Navigator.pushReplacementNamed(context, '/login');
          }
        } catch (e) {
          print('Firestore işlemi sırasında hata: $e'); // Debug log

          // Firestore hatası durumunda kullanıcıyı sil
          await userCredential.user?.delete();

          // Loading'i kapat
          if (context.mounted) {
            Navigator.of(context).pop();
          }

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Veri kaydedilirken hata oluştu: $e'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth hatası: ${e.code} - ${e.message}'); // Debug log

      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Şifre en az 6 karakter olmalıdır';
          break;
        case 'email-already-in-use':
          errorMessage = 'Bu email adresi zaten kullanımda';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz email formatı';
          break;
        default:
          errorMessage = 'Bir hata oluştu: ${e.message}';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('Genel hata: $e'); // Debug log

      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Beklenmeyen bir hata oluştu: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Loading göster
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Giriş yap
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Kullanıcı bilgilerini kontrol et
      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (userDoc.exists) {
        // Ana sayfaya yönlendir
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        await _auth.signOut();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kullanıcı bilgileri bulunamadı'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Kullanıcı bulunamadı';
          break;
        case 'wrong-password':
          errorMessage = 'Yanlış şifre';
          break;
        case 'invalid-email':
          errorMessage = 'Geçersiz email formatı';
          break;
        case 'user-disabled':
          errorMessage = 'Kullanıcı hesabı devre dışı bırakılmış';
          break;
        default:
          errorMessage = 'Giriş başarısız: ${e.message}';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Loading'i kapat
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Giriş yapılamadı: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> signout() async {
    await _auth.signOut();
  }
}
