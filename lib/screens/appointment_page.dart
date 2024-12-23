import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  final String userEmail;
  static List<Map<String, dynamic>> appointments =
      []; // Static liste sınıf seviyesinde

  const AppointmentPage({super.key, required this.userEmail});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedTimeString;
  String? selectedDoctor;
  String? selectedTreatment;

  final Map<String, List<String>> doctorAvailability = {
    'Dr. Ahmet Yılmaz': ['09:00', '10:00', '11:00', '14:00', '15:00'],
    'Dr. Ayşe Demir': ['08:30', '10:30', '12:00', '13:30', '16:00'],
    'Dr. Mehmet Kaya': ['09:30', '11:30', '13:00', '14:30', '15:30'],
  };

  final List<String> treatments = [
    'Genel Kontrol',
    'Diş Çekimi',
    'Dolgu',
    'Kanal Tedavisi',
    'Diş Temizliği',
  ];

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

  void _makeAppointment() {
    if (selectedDoctor == null ||
        selectedTreatment == null ||
        selectedTimeString == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen tüm alanları doldurun'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Yeni randevu oluştur
    final appointment = {
      'userEmail': widget.userEmail,
      'date': selectedDate,
      'time': selectedTimeString!,
      'doctor': selectedDoctor,
      'treatment': selectedTreatment,
    };

    setState(() {
      AppointmentPage.appointments.add(
          appointment); // appointments yerine AppointmentPage.appointments kullanıyoruz
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Randevunuz başarıyla oluşturuldu'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'Tamam',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );

    // Form alanlarını sıfırla
    setState(() {
      selectedDoctor = null;
      selectedTreatment = null;
      selectedDate = DateTime.now();
      selectedTimeString = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Al'),
        backgroundColor: Colors.blue.shade300,
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
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Doktor Seçin',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            value: selectedDoctor,
                            items: doctorAvailability.keys.map((String doctor) {
                              return DropdownMenuItem<String>(
                                value: doctor,
                                child: Text(doctor),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedDoctor = value;
                                selectedTimeString = null;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Tedavi Seçin',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.medical_services),
                            ),
                            value: selectedTreatment,
                            items: treatments.map((String treatment) {
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
                          if (selectedDoctor != null) ...[
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Saat Seçin',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.access_time),
                              ),
                              value: selectedTimeString,
                              items: doctorAvailability[selectedDoctor]!
                                  .map((String time) {
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
                          ...AppointmentPage
                              .appointments // appointments yerine AppointmentPage.appointments kullanıyoruz
                              .where(
                                  (apt) => apt['userEmail'] == widget.userEmail)
                              .map((apt) => ListTile(
                                    title: Text('${apt['doctor']}'),
                                    subtitle: Text(
                                        '${apt['treatment']}\nTarih: ${apt['date'].day}/${apt['date'].month}/${apt['date'].year} Saat: ${apt['time']}'),
                                    leading: const Icon(Icons.assignment),
                                  ))
                              .toList(),
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
