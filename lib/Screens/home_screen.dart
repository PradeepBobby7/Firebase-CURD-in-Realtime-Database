import 'package:firebase_curd/app_color/app_themes.dart';
import 'package:firebase_curd/models/profiles_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'add_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DatabaseReference _database;
  List<Profile> profiles = [];

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('profiles');
    _loadProfiles();
  }

  void _loadProfiles() {
    _database.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final dynamic data = event.snapshot.value;

        if (data is Map<dynamic, dynamic>) {
          profiles.clear();
          data.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              profiles.add(Profile.fromSnapshot(
                  event.snapshot.child(key))); // Correct way
            } else {
              print("Error: Child data is not a map: $value");
            }
          });
        } else {
          print("Error: Data is not a map: $data");
        }
      } else {
        profiles.clear();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomeScreen"),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              leading: CircleAvatar(
                backgroundColor: Apptheme.primaryGreen,
                child: Text(
                  profile.name[0].toUpperCase(),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              title: Text(
                profile.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DOB: ${profile.dob}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                    Text(
                      "Address: ${profile.address}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddProfileScreen(profile: profile),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _deleteProfile(profile.id!);
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProfileScreen()),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 35,
        ),
      ),
    );
  }

  void _deleteProfile(String id) {
    _database.child(id).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete profile: $error')),
      );
    });
  }
}
