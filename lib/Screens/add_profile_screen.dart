import 'package:firebase_curd/models/profiles_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddProfileScreen extends StatefulWidget {
  final Profile? profile;
  AddProfileScreen({Key? key, this.profile}) : super(key: key);

  @override
  State<AddProfileScreen> createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  late DatabaseReference _database;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance.ref('profiles');
    if (widget.profile != null) {
      nameController.text = widget.profile!.name;
      dobController.text = widget.profile!.dob;
      addressController.text = widget.profile!.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profile == null ? 'Add Profile' : 'update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name", border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: dobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Date of Birth",
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid Date of Birth';
                    }
                    return null;
                  },
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      setState(() {
                        dobController.text = formattedDate;
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: "Address",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter a Address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveProfile();
                    }
                  },
                  child: Text(widget.profile == null ? 'Add' : 'Update'),
                )
              ],
            )),
      ),
    );
  }

  void _saveProfile() {
    final name = nameController.text;
    final dob = dobController.text;
    final address = addressController.text;

    if (widget.profile == null) {
      _database
          .push()
          .set({'name': name, 'dob': dob, 'address': address}).then((_) {
        Navigator.pop(context);
      });
    } else {
      _database
          .child(widget.profile!.id!)
          .update({'name': name, 'dob': dob, 'address': address}).then((_) {
        Navigator.pop(context);
      }).catchError((errorr) {
        print("Error updating profile: $errorr");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to Update Profile: $errorr"),
          ),
        );
      });
    }
  }
}
