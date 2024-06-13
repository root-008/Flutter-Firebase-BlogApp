import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/blog_card_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UIWidgets widgets = UIWidgets();
  final UserService userService = UserService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: widgets.customAppBar(context, 'Ana Sayfa', true, true),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: UIColor.primaryColor,
          child: StreamBuilder(
            stream: BlogService().getBlogs(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == null) {
                return const SizedBox();
              }

              if (snapshot.hasData) {
                List<Blog> blogs = [];

                for (var doc in snapshot.data!.docs) {
                  final blog =
                      Blog.fromJson(doc.data() as Map<String, dynamic>);

                  blogs.add(blog);
                }

                return ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    return blogCard(blogs[index], context);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      bottomNavigationBar: widgets.customBottomNavigationBar(context, 1),
      floatingActionButton: widgets.addBlogIcon(context, true),
    );
  }
}
