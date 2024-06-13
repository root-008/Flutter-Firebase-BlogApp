// ignore_for_file: use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:blog_app/model/blog_model.dart';
import 'package:blog_app/services/user_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/view/screens/blog_write_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final CollectionReference blogs = db.collection('blogs');
final User? user = FirebaseAuth.instance.currentUser;
Widget blogCard(Blog blog, BuildContext context) {
  return InkWell(
    onLongPress: () async {
      bool isAdmin = await UserService().isAdmin(context);
      if (isAdmin || blog.authorId == user!.uid) {
        await AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          headerAnimationLoop: true,
          animType: AnimType.bottomSlide,
          title: "Seçiniz!",
          showCloseIcon: true,
          btnOkText: 'Güncelle',
          btnCancelText: 'Sil',
          btnCancelOnPress: () async {
            // Do delete
            await blogs.doc(blog.id).delete();
          },
          btnOkOnPress: () {
            // Do update
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlogWriteScreen(
                      blog: blog,
                    )));
          },
        ).show();
      }
    },
    onTap: () {
      Navigator.pushNamed(context, '/content', arguments: blog.id);
    },
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: UIColor.fourthColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  const Gap(5),
                  Text(
                    blog.author[0].toUpperCase() + blog.author.substring(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat('MMM yyyy').format(blog.time),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            blog.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            blog.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.remove_red_eye,
                    size: 14,
                  ),
                  const Gap(5),
                  Text(
                    '${blog.views ?? 0}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Text(
                blog.category,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
