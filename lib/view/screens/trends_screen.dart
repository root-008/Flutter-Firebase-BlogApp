import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/blog_card_widget.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TrendsScreen extends StatefulWidget {
  const TrendsScreen({super.key});

  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final UIWidgets widgets = UIWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: widgets.customAppBar(context, 'Trendler', true, false),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          color: UIColor.primaryColor,
          child:
              FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
            future: BlogService().getBlogsByTrend(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
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
      bottomNavigationBar: widgets.customBottomNavigationBar(context, 2),
    );
  }
}
