import 'package:blog_app/services/user_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/widgets/setting_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String _defaultImageUrl =
      'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300';

  String username = '';
  String strEmail = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Kullanıcı adını ve e-posta adresini yükle
      String user = await UserService().getUserById(userId);
      String email = await UserService().getEmailById(userId);

      // Profil resmini yükle
      await loadProfileImage(userId);

      setState(() {
        username = user;
        strEmail = email;
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(_defaultImageUrl),
            ),
            accountEmail: Text(strEmail),
            accountName: Text(
              username,
              style: const TextStyle(fontSize: 24.0),
            ),
            decoration: const BoxDecoration(
              color: UIColor.primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Mdi.home),
            title: const Text(
              'Ana Sayfa',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          ListTile(
            leading: const Icon(Mdi.library),
            title: const Text(
              'Kategoriler',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/categories');
            },
          ),
          ListTile(
            leading: const Icon(Mdi.trendingUp),
            title: const Text(
              'Trendler',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/trends');
            },
          ),
          ListTile(
            leading: const Icon(Icons.turned_in),
            title: const Text(
              'Kaydedilenler',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/saved');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(
              'Ayarlar',
              style: TextStyle(fontSize: 24.0),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => SettingsDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
