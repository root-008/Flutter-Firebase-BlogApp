import 'package:blog_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SettingsDialog extends StatefulWidget {
  @override
  _SettingsDialogState createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  final TextEditingController _usernameController = TextEditingController();
  String? _selectedImagePath;
  String _defaultImageUrl =
      'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300';

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    String userId = FirebaseAuth.instance.currentUser!.uid;
    loadUserData(userId);
    loadProfileImage(userId);
  }

  Future<void> loadUserData(String userId) async {
    try {
      String user = await UserService().getUserById(userId);
      setState(() {
        _usernameController.text = user;
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> loadProfileImage(String userId) async {
    String path = 'profile_pic/$userId';
    try {
      // Firebase Storage referansını alın
      final storageRef = FirebaseStorage.instance.ref().child(path);

      // URL'yi alın
      String url = await storageRef.getDownloadURL();

      // URL'yi state'de güncelleyin
      setState(() {
        _defaultImageUrl = url;
      });
    } catch (e) {
      print('User-specific profile image not found: $e');

      // Kullanıcıya özel profil resmi bulunamazsa, varsayılan resmi kullanın
      path = 'profile_pic/defaultpp.jpg';
      try {
        final storageRef = FirebaseStorage.instance.ref().child(path);
        String url = await storageRef.getDownloadURL();
        setState(() {
          _defaultImageUrl = url;
        });
      } catch (e) {
        print('Failed to load default profile image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      scrollable: true,
      title:
          const Text('Ayarlar', style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _selectedImagePath != null
                ? FileImage(File(_selectedImagePath!))
                : NetworkImage(_defaultImageUrl) as ImageProvider<Object>?,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Kullanıcı Adı',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Resim Seç'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Kapat', style: TextStyle(fontSize: 16)),
        ),
        TextButton(
          onPressed: _saveSettings,
          child: const Text('Kaydet', style: TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  void _saveSettings() {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String username = _usernameController.text;
    String profilePic = _selectedImagePath ?? _defaultImageUrl;
    UserService().saveUsernameAndProfilePic(userId, username, profilePic);
    Navigator.of(context).pop(); // Dialog kapanır
    setState(() {}); // HomeDrawer güncellenir
  }
}
