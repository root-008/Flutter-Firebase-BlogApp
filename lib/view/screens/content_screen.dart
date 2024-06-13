// ignore_for_file: library_private_types_in_public_api

import 'package:blog_app/services/blog_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/home_drawer.dart';
import 'package:blog_app/view/widgets/ui_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContentScreen extends StatefulWidget {
  final String id;

  const ContentScreen({super.key, required this.id});

  @override
  _ContentScreenState createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  final UIWidgets widgets = UIWidgets();
  late String id;
  late Future<bool> isSaved;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    isSaved = isBlogSaved(id);
  }

  Future<bool> isBlogSaved(String blogId) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    CollectionReference savedBlogs =
        FirebaseFirestore.instance.collection('savedBlogs');

    QuerySnapshot querySnapshot = await savedBlogs
        .where('userId', isEqualTo: userId)
        .where('blogId', isEqualTo: blogId)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> toggleSaveBlog(String blogId) async {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user!.uid;
    CollectionReference savedBlogs =
        FirebaseFirestore.instance.collection('savedBlogs');

    QuerySnapshot querySnapshot = await savedBlogs
        .where('userId', isEqualTo: userId)
        .where('blogId', isEqualTo: blogId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Blog is already saved, remove it
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog kaydedilenlerden çıkarıldı!')),
      );
      setState(() {
        isSaved = Future.value(false);
      });
    } else {
      // Blog is not saved, add it
      await savedBlogs.add({
        'userId': userId,
        'blogId': blogId,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blog başarıyla kaydedildi!')),
      );
      setState(() {
        isSaved = Future.value(true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawer(),
      appBar: widgets.customAppBar(context, 'Blog İçeriği', true, false),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: UIColor.primaryColor,
        child: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: BlogService().getContent(id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Bir hata oluştu: ${snapshot.error}'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                var data = snapshot.data!.data();
                String blogId = data!['id'];
                String formattedDate =
                    DateFormat('MMM/yyyy').format(data['time'].toDate());

                return FutureBuilder<bool>(
                  future: isSaved,
                  builder: (context, savedSnapshot) {
                    if (savedSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    bool isSaved = savedSnapshot.data ?? false;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data['author'][0].toUpperCase() +
                                  data['author'].substring(1),
                              style: const TextStyle(
                                color: UIColor.thirdColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "$formattedDate - ${data['category']}",
                                  style: const TextStyle(
                                    color: UIColor.thirdColor,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: Icon(
                                    isSaved
                                        ? Icons.turned_in
                                        : Icons.turned_in_not,
                                    color: Colors.white,
                                  ),
                                  color: UIColor.secondaryColor,
                                  onPressed: () => toggleSaveBlog(blogId),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['title'],
                          style: const TextStyle(
                            color: UIColor.fourthColor,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['text'],
                          style: const TextStyle(
                            color: UIColor.fourthColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
