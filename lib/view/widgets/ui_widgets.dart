// ignore_for_file: use_build_context_synchronously

import 'package:blog_app/services/user_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mdi/mdi.dart';

class UIWidgets {
  UIWidgets();

  final UserService userService = UserService();
  AppBar customAppBar(
      BuildContext context, String title, showAddIcon, bool isHome) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.white),
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: UIColor.textColorWhite,
            fontFamily: 'InkFree',
            fontSize: 26,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
            height: 1),
      ),
      leading: Builder(builder: (context) {
        return IconButton(
          icon: const Icon(Mdi.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        );
      }),
      actions: [
        adminIcon(context),
        IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            )),
      ],
      centerTitle: true,
      backgroundColor: UIColor.secondaryColor,
    );
  }

  Widget addBlogIcon(BuildContext context, bool showAddIcon) {
    return FutureBuilder<bool>(
      future: userService.isWriterOrAdmin(context),
      builder: (context, snapshot) {
        if (snapshot.data == true && showAddIcon) {
          // Yazar ise add butonunu göster
          return FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/addBlog');
            },
            backgroundColor: UIColor.secondaryColor,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            child: const Icon(Icons.add),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget adminIcon(BuildContext context) {
    return FutureBuilder(
        future: userService.isAdmin(context),
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return IconButton(
                onPressed: () {
                  //go to admin actions
                  Navigator.of(context).pushNamed('/admin');
                },
                icon: const Icon(Icons.admin_panel_settings));
          } else {
            return const SizedBox.shrink();
          }
        });
  }

  Widget customBottomNavigationBar(BuildContext context, int initialIndex) {
    List<String> routeNames = ['/categories', '/home', '/trends', '/saved'];

    final localContext = context;

    return ConvexAppBar(
      style: TabStyle.flip,
      height: 60,
      backgroundColor: UIColor.secondaryColor,
      color: UIColor.fourthColor,
      curveSize: 0,
      items: const [
        TabItem(
          icon: Mdi.library,
          title: 'Kategoriler',
          fontFamily: 'InkFree',
        ),
        TabItem(
          icon: Mdi.home,
          title: 'Ana Sayfa',
          fontFamily: 'InkFree',
        ),
        TabItem(
          icon: Mdi.trendingUp,
          title: 'Trendler',
          fontFamily: 'InkFree',
        ),
        TabItem(
          icon: Icons.turned_in,
          title: 'Kaydedilenler',
          fontFamily: 'InkFree',
        ),
      ],
      initialActiveIndex: initialIndex,
      onTap: (int i) {
        if (i >= 0 && i < routeNames.length) {
          Navigator.of(localContext).pushNamed(routeNames[i]);
        }
      },
    );
  }
}
