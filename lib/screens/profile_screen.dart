import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? "User";
      _lastName = prefs.getString('lastName') ?? "";
      _phoneNumber = prefs.getString('phoneNumber') ?? "Not Set";
      _profileImage = prefs.getString('profileImage');
    });
  }

  /// Pick Image for Profile Picture
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', pickedFile.path);
      setState(() {
        _profileImage = pickedFile.path;
      });
    }
  }

  /// Edit User Profile
  Future<void> _editProfile() async {
    TextEditingController firstNameController = TextEditingController(text: _firstName);
    TextEditingController lastNameController = TextEditingController(text: _lastName);
    TextEditingController phoneController = TextEditingController(text: _phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: firstNameController, decoration: const InputDecoration(labelText: "First Name")),
            TextField(controller: lastNameController, decoration: const InputDecoration(labelText: "Last Name")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone Number")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('firstName', firstNameController.text);
              await prefs.setString('lastName', lastNameController.text);
              await prefs.setString('phoneNumber', phoneController.text);
              setState(() {
                _firstName = firstNameController.text;
                _lastName = lastNameController.text;
                _phoneNumber = phoneController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Profile Picture Section
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _profileImage != null ? FileImage(File(_profileImage!)) : null,
                child: _profileImage == null ? const Icon(Icons.person, size: 60, color: Colors.white) : null,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "$_firstName $_lastName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Phone: $_phoneNumber",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: _editProfile,
            ),
          ],
        ),
      ),
    );
  }
}
