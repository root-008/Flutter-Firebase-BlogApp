import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/blog_card_widget.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';
import 'package:flutter/material.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final UIWidgets widgets = UIWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: widgets.customAppBar(context, 'Kaydedilenler', true, false),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: UIColor.primaryColor,
          child: FutureBuilder<List<Blog>>(
            future: BlogService().getSavedBlogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                    child: Text('Bir hata oluştu: ${snapshot.error}'));
              }

              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(child: Text('Kaydedilen blog bulunamadı.'));
              }

              List<Blog> blogs = snapshot.data!;

              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  return blogCard(blogs[index], context);
                },
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: widgets.customBottomNavigationBar(context, 3),
    );
  }
}
