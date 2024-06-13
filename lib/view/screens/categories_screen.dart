import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final UIWidgets widgets = UIWidgets();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Lifestyle', 'icon': Icons.landscape},
    {'name': 'Finance', 'icon': Icons.attach_money},
    {'name': 'News', 'icon': Icons.article},
    {'name': 'Fashion', 'icon': Icons.shopping_bag},
    {'name': 'Music', 'icon': Icons.music_note},
    {'name': 'Business', 'icon': Icons.business},
    {'name': 'Food', 'icon': Icons.restaurant},
    {'name': 'Game', 'icon': Icons.gamepad},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: widgets.customAppBar(context, 'Kategoriler', true, false),
      body: Container(
        color: UIColor.primaryColor,
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            String category = categories[index]['name'];
            return CategoryCard(
              categoryName: category,
              icon: categories[index]['icon'],
              onTap: () {
                Navigator.pushNamed(context, '/spec_category',
                    arguments: category);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: widgets.customBottomNavigationBar(context, 0),
      floatingActionButton: widgets.addBlogIcon(context, true),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 64,
                  color: UIColor.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                categoryName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
