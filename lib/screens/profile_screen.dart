import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart'; // ✅ Required for saving image

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _firstName;
  String? _lastName;
  String? _phoneNumber;
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  /// ✅ Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('firstName') ?? "John";
      _lastName = prefs.getString('lastName') ?? "Doe";
      _phoneNumber = prefs.getString('phoneNumber') ?? "Not Set";
      _profileImagePath = prefs.getString('profileImagePath');
    });
  }

  /// ✅ Pick Image & Save to App Directory
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final String imagePath = '${directory.path}/profile_image.png';
      final File imageFile = File(pickedFile.path);
      await imageFile.copy(imagePath); // ✅ Copy to safe directory

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', imagePath);

      setState(() {
        _profileImagePath = imagePath;
      });
    }
  }

  /// ✅ Edit User Profile
  Future<void> _editProfile() async {
    TextEditingController firstNameController = TextEditingController(text: _firstName);
    TextEditingController lastNameController = TextEditingController(text: _lastName);
    TextEditingController phoneController = TextEditingController(text: _phoneNumber);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField(firstNameController, "First Name"),
            _buildTextField(lastNameController, "Last Name"),
            _buildTextField(phoneController, "Phone Number"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
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

  /// ✅ Build Text Field Widget
  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// ✅ Profile Picture Centered at the Top (Fixed)
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade300,
                child: _profileImagePath != null && File(_profileImagePath!).existsSync()
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.file(
                          File(_profileImagePath!),
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(Icons.person, size: 70, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            /// ✅ Profile Details Section
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildProfileDetail("Name", "$_firstName $_lastName", Icons.person),
                    _buildProfileDetail("Phone Number", _phoneNumber!, Icons.phone),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ✅ Edit Profile Button
            ElevatedButton.icon(
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _editProfile,
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Build Profile Detail Row
  Widget _buildProfileDetail(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
