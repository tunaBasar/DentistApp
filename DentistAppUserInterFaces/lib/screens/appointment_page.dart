import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appointment_project/services/auth_service.dart';

class AppointmentPage extends StatefulWidget {
  final String userEmail;

  const AppointmentPage({super.key, required this.userEmail});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeString;
  String? selectedDoctor;
  String? selectedTreatment;

  final List<String> treatmentOptions = [
    'Diş Temizliği',
    'Dolgu',
    'Kanal Tedavisi',
    'Diş Çekimi',
  ];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  Stream<QuerySnapshot> get doctorsStream =>
      _firestore.collection('doctors').snapshots();

  Stream<QuerySnapshot> get appointmentsStream => _firestore
      .collection('appointments')
      .where('userEmail', isEqualTo: widget.userEmail)
      .snapshots();

  Future<void> _handleSignOut() async {
    try {
      await _authService.signout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      _showMessage('Çıkış yapılırken bir hata oluştu: $e', isError: true);
    }
  }

  Future<void> _showSignOutConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Çıkış Yap'),
          content: const Text(
              'Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleSignOut();
              },
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            colorScheme: ColorScheme.light(primary: Colors.blue.shade300),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _makeAppointment() async {
    if (selectedDoctor == null ||
        selectedTimeString == null ||
        selectedTreatment == null) {
      _showMessage('Lütfen tüm alanları doldurun', isError: true);
      return;
    }

    try {
      final existingAppointment = await _firestore
          .collection('appointments')
          .where('doctor', isEqualTo: selectedDoctor)
          .where('date',
              isEqualTo: Timestamp.fromDate(DateTime(
                  selectedDate.year, selectedDate.month, selectedDate.day)))
          .where('time', isEqualTo: selectedTimeString)
          .get();

      if (existingAppointment.docs.isNotEmpty) {
        _showMessage('Bu randevu saati dolu', isError: true);
        return;
      }

      await _firestore.collection('appointments').add({
        'userEmail': widget.userEmail,
        'userId': _auth.currentUser?.uid,
        'doctor': selectedDoctor,
        'date': Timestamp.fromDate(
            DateTime(selectedDate.year, selectedDate.month, selectedDate.day)),
        'time': selectedTimeString,
        'treatment': selectedTreatment,
        'status': 'beklemede',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _showMessage('Randevunuz başarıyla oluşturuldu');

      setState(() {
        selectedDoctor = null;
        selectedDate = DateTime.now();
        selectedTimeString = null;
        selectedTreatment = null;
      });
    } catch (e) {
      _showMessage('Bir hata oluştu: $e', isError: true);
    }
  }

  Future<void> _updateAppointment(
      String appointmentId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update(updatedData);
      _showMessage('Randevu güncellendi');
    } catch (e) {
      _showMessage('Randevu güncellenemedi: $e', isError: true);
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    try {
      await _firestore.collection('appointments').doc(appointmentId).delete();
      _showMessage('Randevu iptal edildi');
    } catch (e) {
      _showMessage('Randevu iptal edilemedi: $e', isError: true);
    }
  }

  void _showUpdateDialog(
      String appointmentId, Map<String, dynamic> currentData) {
    String? newDoctor = currentData['doctor'];
    String? newTime = currentData['time'];
    String? newTreatment = currentData['treatment'];
    DateTime newDate = (currentData['date'] as Timestamp).toDate();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Randevuyu Güncelle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: doctorsStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }

                    final doctors = snapshot.data!.docs;
                    return DropdownButtonFormField<String>(
                      value: newDoctor,
                      decoration: const InputDecoration(
                        labelText: 'Doktor',
                        border: OutlineInputBorder(),
                      ),
                      items: doctors.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return DropdownMenuItem<String>(
                          value: data['name'],
                          child: Text(data['name']),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() {
                        newDoctor = value;
                        newTime = null;
                      }),
                    );
                  },
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Tarih Seçin'),
                  subtitle: Text(
                    '${newDate.day}/${newDate.month}/${newDate.year}',
                  ),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: newDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (picked != null) {
                      setState(() => newDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 16),
                if (newDoctor != null) ...[
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('doctors')
                        .where('name', isEqualTo: newDoctor)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const CircularProgressIndicator();
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return const Text('Doktor bulunamadı');
                      }

                      final doctorData = snapshot.data!.docs.first.data()
                          as Map<String, dynamic>;
                      final availableTimes =
                          List<String>.from(doctorData['availability'] ?? []);

                      if (newDoctor == currentData['doctor'] &&
                          !availableTimes.contains(newTime)) {
                        availableTimes.add(newTime!);
                        availableTimes.sort();
                      }

                      return DropdownButtonFormField<String>(
                        value:
                            availableTimes.contains(newTime) ? newTime : null,
                        decoration: const InputDecoration(
                          labelText: 'Saat',
                          border: OutlineInputBorder(),
                        ),
                        items: availableTimes.map((time) {
                          return DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => newTime = value),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: newTreatment,
                  decoration: const InputDecoration(
                    labelText: 'Tedavi',
                    border: OutlineInputBorder(),
                  ),
                  items: treatmentOptions.map((treatment) {
                    return DropdownMenuItem<String>(
                      value: treatment,
                      child: Text(treatment),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => newTreatment = value),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (newDoctor != null &&
                    newTime != null &&
                    newTreatment != null) {
                  _updateAppointment(appointmentId, {
                    'doctor': newDoctor,
                    'date': Timestamp.fromDate(newDate),
                    'time': newTime,
                    'treatment': newTreatment,
                  });
                  Navigator.pop(context);
                } else {
                  _showMessage('Lütfen tüm alanları doldurun', isError: true);
                }
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Al'),
        backgroundColor: Colors.blue.shade300,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _showSignOutConfirmationDialog,
            tooltip: 'Çıkış Yap',
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.purple.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Randevu Bilgileri',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 20),
                          StreamBuilder<QuerySnapshot>(
                            stream: doctorsStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Bir hata oluştu');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              final doctors = snapshot.data?.docs ?? [];

                              return DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Doktor Seçin',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.person),
                                ),
                                value: selectedDoctor,
                                items: doctors.map((doc) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return DropdownMenuItem<String>(
                                    value: data['name'],
                                    child: Text(data['name']),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedDoctor = value;
                                    selectedTimeString = null;
                                  });
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: const Text('Tarih Seçin'),
                            subtitle: Text(
                              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            ),
                            onTap: () => _selectDate(context),
                            tileColor: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Tedavi Yöntemi Seçin',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.healing),
                            ),
                            value: selectedTreatment,
                            items: treatmentOptions.map((treatment) {
                              return DropdownMenuItem<String>(
                                value: treatment,
                                child: Text(treatment),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedTreatment = value;
                              });
                            },
                          ),
                          if (selectedDoctor != null) ...[
                            const SizedBox(height: 16),
                            StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('doctors')
                                  .where('name', isEqualTo: selectedDoctor)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Bir hata oluştu');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                final data = snapshot.data?.docs.first.data()
                                    as Map<String, dynamic>?;
                                final availableTimes = List<String>.from(
                                    data?['availability'] ?? []);

                                return DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    labelText: 'Saat Seçin',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.access_time),
                                  ),
                                  value: selectedTimeString,
                                  items: availableTimes.map((time) {
                                    return DropdownMenuItem<String>(
                                      value: time,
                                      child: Text(time),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedTimeString = value;
                                    });
                                  },
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _makeAppointment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade400,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Randevu Al',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Randevularım',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot>(
                            stream: appointmentsStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Bir hata oluştu');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              final appointments = snapshot.data?.docs ?? [];

                              if (appointments.isEmpty) {
                                return const Center(
                                  child: Text('Henüz randevunuz bulunmuyor'),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointments[index].data()
                                      as Map<String, dynamic>;
                                  final appointmentId = appointments[index].id;
                                  final date =
                                      (appointment['date'] as Timestamp)
                                          .toDate();

                                  return ListTile(
                                    title: Text(appointment['doctor']),
                                    subtitle: Text(
                                      'Tarih: ${date.day}/${date.month}/${date.year}\n'
                                      'Saat: ${appointment['time']}\n'
                                      'Tedavi: ${appointment['treatment']}\n'
                                      'Durum: ${appointment['status']}',
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () => _showUpdateDialog(
                                              appointmentId, appointment),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.cancel,
                                              color: Colors.red),
                                          onPressed: () =>
                                              _cancelAppointment(appointmentId),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
