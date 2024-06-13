import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/blog_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';

class SpecCategoryScreen extends StatefulWidget {
  const SpecCategoryScreen({super.key, required this.category});

  final String category;

  @override
  State<SpecCategoryScreen> createState() => _SpecCategoryScreenState();
}

class _SpecCategoryScreenState extends State<SpecCategoryScreen> {
  late String category;

  @override
  void initState() {
    super.initState();
    category = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: UIWidgets().customAppBar(context, category, true, false),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: UIColor.primaryColor,
          child:
              FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
            future: BlogService().getBlogsByCategory(category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Bu kategoriye ait henüz bir blog bulunmuyor.',
                    style: TextStyle(
                      fontSize: 19,
                      color: UIColor.fourthColor,
                    ),
                  ),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var blogData = snapshot.data![index].data();
                    Blog blog = Blog.fromJson(blogData);
                    return blogCard(blog, context);
                  },
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: UIWidgets().customBottomNavigationBar(context, 0),
    );
  }
}
