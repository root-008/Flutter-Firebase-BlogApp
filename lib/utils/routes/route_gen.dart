import 'package:blog_app/view/screens/admin/admin_home_screen.dart';
import 'package:blog_app/view/screens/blog_write_screen.dart';
import 'package:blog_app/view/screens/categories_screen.dart';
import 'package:blog_app/view/screens/content_screen.dart';
import 'package:blog_app/view/screens/home_screen.dart';
import 'package:blog_app/view/screens/login_screen.dart';
import 'package:blog_app/view/screens/register_screen.dart';
import 'package:blog_app/view/screens/saved_screen.dart';
import 'package:blog_app/view/screens/spec_category_screen.dart';
import 'package:blog_app/view/screens/trends_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/addBlog':
        return MaterialPageRoute(builder: (_) => const BlogWriteScreen());
      case '/categories':
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case '/trends':
        return MaterialPageRoute(builder: (_) => const TrendsScreen());
      case '/saved':
        return MaterialPageRoute(builder: (_) => const SavedScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      case '/spec_category':
        if (args is String) {
          return MaterialPageRoute(
              builder: (_) => SpecCategoryScreen(category: args));
        } else {
          return _errorRoute();
        }
      case '/content':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => ContentScreen(id: args));
        } else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
