import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  _AgendaScreenState createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<dynamic> _agendaList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgenda();
  }

  Future<void> _fetchAgenda() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/school_app/agenda.php'));

    if (response.statusCode == 200) {
      setState(() {
        _agendaList = json.decode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching agenda')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchAgenda,
              child: ListView.builder(
                itemCount: _agendaList.length,
                itemBuilder: (context, index) {
                  final agenda = _agendaList[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          DateFormat('dd')
                              .format(DateTime.parse(agenda['tgl_agenda'])),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        agenda['judul_agenda'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMMM yyyy')
                            .format(DateTime.parse(agenda['tgl_agenda'])),
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agenda['isi_agenda'],
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Posted on: ${DateFormat('dd MMMM yyyy').format(DateTime.parse(agenda['tgl_post_agenda']))}',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
