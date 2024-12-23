import 'package:flutter/material.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController ssidController = TextEditingController();

  static Map<String, Map<String, String>> userDatabase = {};

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.purple.shade300,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.person_add,
                      size: 150,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 50),
                    // First Name
                    _buildTextField(
                      controller: firstNameController,
                      label: 'First Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    // Last Name
                    _buildTextField(
                      controller: lastNameController,
                      label: 'Last Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 20),
                    // Email
                    _buildTextField(
                      controller: emailController,
                      label: 'Email',
                      icon: Icons.email,
                    ),
                    const SizedBox(height: 20),
                    // Password
                    _buildTextField(
                      controller: passwordController,
                      label: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Confirm Password
                    _buildTextField(
                      controller: confirmPasswordController,
                      label: 'Confirm Password',
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    // Date of Birth
                    _buildTextField(
                      controller: dateOfBirthController,
                      label: 'Date of Birth (DD/MM/YYYY)',
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 20),
                    // SSID (TC)
                    _buildTextField(
                      controller: ssidController,
                      label: 'SSID (TC)',
                      icon: Icons.perm_identity,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          String firstName = firstNameController.text.trim();
                          String lastName = lastNameController.text.trim();
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();
                          String confirmPassword =
                              confirmPasswordController.text.trim();
                          String dateOfBirth =
                              dateOfBirthController.text.trim();
                          String ssid = ssidController.text.trim();

                          if (firstName.isEmpty ||
                              lastName.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty ||
                              confirmPassword.isEmpty ||
                              dateOfBirth.isEmpty ||
                              ssid.isEmpty) {
                            _showMessage(context, 'Please fill all fields');
                            return;
                          }

                          if (password != confirmPassword) {
                            _showMessage(context, 'Passwords do not match');
                            return;
                          }

                          // Add the user to the database
                          userDatabase[ssid] = {
                            'firstName': firstNameController.text.trim(),
                            'lastName': lastNameController.text.trim(),
                            'email': emailController.text.trim(),
                            'dateOfBirth': dateOfBirthController.text.trim(),
                            'password': password, // Şifreyi doğru kaydediyoruz
                          };

                          print(
                              "User registered: $ssid with password $password"); // Debug için ekledim

                          _showMessage(context, 'Registration Successful',
                              success: true);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
        ),
        obscureText: obscureText,
      ),
    );
  }

  void _showMessage(BuildContext context, String message,
      {bool success = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(20),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
