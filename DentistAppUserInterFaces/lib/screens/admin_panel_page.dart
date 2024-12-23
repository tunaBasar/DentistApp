import 'package:flutter/material.dart';
import 'package:appointment_project/screens/appointment_page.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Doktor bilgileri için yeni bir Map
  final Map<String, Map<String, dynamic>> doctors = {
    'Dr. Ahmet Yılmaz': {
      'availability': ['09:00', '10:00', '11:00', '14:00', '15:00'],
      'specialty': 'Diş Hekimi',
      'phone': '555-0001'
    },
    'Dr. Ayşe Demir': {
      'availability': ['08:30', '10:30', '12:00', '13:30', '16:00'],
      'specialty': 'Ortodonti Uzmanı',
      'phone': '555-0002'
    },
    'Dr. Mehmet Kaya': {
      'availability': ['09:30', '11:30', '13:00', '14:30', '15:30'],
      'specialty': 'Periodontoloji Uzmanı',
      'phone': '555-0003'
    },
  };

  final List<String> treatments = [
    'Genel Kontrol',
    'Diş Çekimi',
    'Dolgu',
    'Kanal Tedavisi',
    'Diş Temizliği',
  ];

  // Form için controller'lar
  final nameController = TextEditingController();
  final specialtyController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: Colors.blue.shade300,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Randevular'),
            Tab(text: 'Doktorlar'),
            Tab(text: 'Tedaviler'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentsTab(),
          _buildDoctorsTab(),
          _buildTreatmentsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _addDoctor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  // Doktor ekleme dialog'u
  void _addDoctor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Doktor Ekle'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Ad Soyad',
                  prefixText: 'Dr. ',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Uzmanlık Alanı',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.clear();
              specialtyController.clear();
              phoneController.clear();
              Navigator.pop(context);
            },
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  specialtyController.text.isNotEmpty &&
                  phoneController.text.isNotEmpty) {
                setState(() {
                  doctors['Dr. ${nameController.text}'] = {
                    'availability': [],
                    'specialty': specialtyController.text,
                    'phone': phoneController.text,
                  };
                });
                nameController.clear();
                specialtyController.clear();
                phoneController.clear();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Doktor başarıyla eklendi'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade100, Colors.purple.shade100],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          String doctor = doctors.keys.elementAt(index);
          Map<String, dynamic> doctorInfo = doctors[doctor]!;
          List<String> times = List<String>.from(doctorInfo['availability']);

          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ExpansionTile(
              title: Text(doctor),
              subtitle:
                  Text('${doctorInfo['specialty']} - ${doctorInfo['phone']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteDoctor(doctor),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Müsait Saatler:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Wrap(
                        spacing: 8,
                        children: times
                            .map((time) => Chip(
                                  label: Text(time),
                                  deleteIcon: const Icon(Icons.close),
                                  onDeleted: () {
                                    setState(() {
                                      doctors[doctor]!['availability']
                                          .remove(time);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _addTimeSlot(doctor),
                        child: const Text('Yeni Saat Ekle'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _deleteDoctor(String doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Doktor Sil'),
        content:
            Text('$doctor isimli doktoru silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                doctors.remove(doctor);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Doktor başarıyla silindi'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Sil', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade100, Colors.purple.shade100],
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: AppointmentPage.appointments
            .length, // _AppointmentPageState yerine AppointmentPage
        itemBuilder: (context, index) {
          final appointment = AppointmentPage.appointments[
              index]; // _AppointmentPageState yerine AppointmentPage
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: ListTile(
              title: Text(
                  '${appointment['doctor']} - ${appointment['treatment']}'),
              subtitle: Text(
                'Hasta: ${appointment['userEmail']}\nTarih: ${appointment['date'].day}/${appointment['date'].month}/${appointment['date'].year}\nSaat: ${appointment['time']}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    AppointmentPage.appointments.removeAt(
                        index); // _AppointmentPageState yerine AppointmentPage
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Randevu silindi')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTreatmentsTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue.shade100, Colors.purple.shade100],
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: treatments.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: ListTile(
                    title: Text(treatments[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          treatments.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _addTreatment,
              child: const Text('Yeni Tedavi Ekle'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addTimeSlot(String doctor) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      String timeString =
          '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}';
      setState(() {
        doctors[doctor]!['availability'].add(timeString);
        doctors[doctor]!['availability'].sort();
      });
    }
  }

  Future<void> _addTreatment() async {
    String? newTreatment = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Tedavi Ekle'),
        content: TextField(
          decoration: const InputDecoration(
            labelText: 'Tedavi Adı',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ekle'),
          ),
        ],
      ),
    );

    if (newTreatment != null && newTreatment.isNotEmpty) {
      setState(() {
        treatments.add(newTreatment);
      });
    }
  }
}
