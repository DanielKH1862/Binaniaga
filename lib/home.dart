import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'agenda.dart'; // Assuming this is the correct import path
import 'profile.dart'; // Add this import

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required String username}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = 'Tamu'; // Default value

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2/school_app/home.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          username = data['username'] as String? ?? 'Tamu';
        });
      }
    } catch (e) {
      print('Error fetching username: $e');
      // Keep the default 'Tamu' value set initially
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang, $username!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                ),
                SizedBox(height: 20),
                _buildSummaryCard(context),
                SizedBox(height: 20),
                _buildQuickActions(context),
                SizedBox(height: 20),
                _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan aksi di sini
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
                'Ini adalah halaman beranda aplikasi Anda yang telah ditingkatkan.'),
            const SizedBox(height: 10),
            const LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 10),
            const Text('Progress: 70%',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aksi Cepat',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionButton(
                context, Icons.add_task, 'Tugas Baru', Colors.green),
            _buildActionButton(context, Icons.event, 'Jadwal', Colors.orange),
            _buildActionButton(
                context, Icons.bar_chart, 'Laporan', Colors.purple),
            _buildActionButton(context, Icons.person, 'Profil',
                Colors.blue), // New Profile button
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      BuildContext context, IconData icon, String label, Color color) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            if (label == 'Jadwal') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgendaScreen()),
              );
            } else if (label == 'Profil') {
              // New condition for Profile button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else {
              // TODO: Implementasikan aksi untuk tombol lain
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
            backgroundColor: color,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terbaru',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade200,
                child: Icon(Icons.person, color: Colors.blue.shade700),
              ),
              title: Text('Aktivitas ${index + 1}'),
              subtitle: Text('Deskripsi singkat aktivitas ${index + 1}'),
              trailing: Text('${index + 1}j yang lalu'),
            );
          },
        ),
      ],
    );
  }
}
