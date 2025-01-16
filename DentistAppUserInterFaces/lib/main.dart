import 'package:appointment_project/screens/appointment_page.dart';
import 'package:appointment_project/screens/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointment_project/screens/login_page.dart';
import 'package:appointment_project/screens/register_page.dart';
import 'firebase_options.dart';
import 'package:appointment_project/screens/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Firebase Auth ayarlarını yapılandır
    await FirebaseAuth.instance.setSettings(
      appVerificationDisabledForTesting: true,
    );

    print('Firebase başarıyla başlatıldı'); // Debug için
  } catch (e) {
    print('Firebase başlatma hatası: $e'); // Debug için
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dentist Appointment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/appointment': (context) => const AppointmentPage(userEmail: ''),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
