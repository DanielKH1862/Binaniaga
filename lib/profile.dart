import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> userData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/school_app/profile.php'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        setState(() {
          userData = jsonResponse['data'];
          isLoading = false;
        });
      } else {
        // Handle error
        print(jsonResponse['message']);
      }
    } else {
      // Handle error
      print('Failed to load user data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(userData['username'] ?? ''),
                    background: Image.network(
                      userData['foto_profile'] ??
                          'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bio',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(userData['bio'] ?? 'No bio available'),
                          SizedBox(height: 16),
                          Text(
                            'Contact Information',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text(userData['email'] ?? ''),
                          ),
                          // Add more user information here
                        ],
                      ),
                    ),
                  ]),
                ),
              ],
            ),
    );
  }
}
