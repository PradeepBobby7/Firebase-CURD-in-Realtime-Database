import 'package:firebase_database/firebase_database.dart';

class Profile {
  String? id;
  String name;
  String dob;
  String address;

  Profile(
      {this.id, required this.name, required this.dob, required this.address});

  factory Profile.fromSnapshot(DataSnapshot snapshot) {
    final dynamic value = snapshot.value;
    if (value is Map<dynamic, dynamic>) {
      final data = value.cast<String, dynamic>();
      return Profile(
          id: snapshot.key,
          name: data['name'] ?? '',
          dob: data['dob'] ?? '',
          address: data['address'] ?? '');
    } else {
      print('Error data is not a map: $value');
      return Profile(id: snapshot.key,name: '', dob: '', address: '');
    }
  }
}
