import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> isWriter(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    bool state = false;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('rool') == "writer") {
            state = true;
          } else {
            state = false;
          }
        }
      });
      return state;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future<bool> isAdmin(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    bool state = false;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot.get('rool') == "admin") {
            state = true;
          } else {
            state = false;
          }
        }
      });
      return state;
    } catch (e) {
      //print(e);
    }
    return false;
  }

  Future<bool> isWriterOrAdmin(BuildContext context) async {
    return await isWriter(context) || await isAdmin(context);
  }

  Future<List<Map<String, String>>> getUsersEmailAndRole() async {
    List<Map<String, String>> usersList = [];

    try {
      QuerySnapshot querySnapshot = await db
          .collection('users')
          .where('rool', isNotEqualTo: 'admin')
          .get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        String email = doc['email'];
        String role = doc['rool'];

        usersList.add({'email': email, 'rool': role});
      }
    } catch (e) {
      //print('Error fetching users: $e');
    }

    return usersList;
  }

  Future<void> updateUserRoleByEmail(String email, String newRole) async {
    try {
      QuerySnapshot querySnapshot =
          await db.collection('users').where('email', isEqualTo: email).get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        await userDoc.reference.update({'rool': newRole});
      }
    } catch (e) {
      //print('$e');
    }
  }

  Future<String> getUserById(String uid) async {
    try {
      DocumentSnapshot userDoc = await db.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['username'];
      }
    } catch (e) {
      //print('$e');
    }
    return "";
  }

  Future<String> getEmailById(String uid) async {
    try {
      DocumentSnapshot userDoc = await db.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['email'];
      }
    } catch (e) {
      //print('$e');
    }
    return "";
  }

  Future<String> getProfilePic(String uid) async {
    try {
      DocumentSnapshot userDoc = await db.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['prof_pic'];
      }
    } catch (e) {
      //print('$e');
    }
    return "";
  }

  Future<void> saveUsernameAndProfilePic(
      String uid, String username, String profilePic) async {
    final path = 'profile_pic/$uid';
    final ref = FirebaseStorage.instance.ref().child(path);
    try {
      await ref.putFile(File(
          profilePic)); //profiePic pickedFile!.path! ile aldığım resmin yolu
    } catch (e) {
      //print('$e');
    }

    try {
      await db
          .collection('users')
          .doc(uid)
          .update({'username': username, 'profilePic': profilePic});
    } catch (e) {
      //print('$e');
    }
    updateAuthorNameInBlogs(uid, username);
  }
}

Future<void> updateAuthorNameInBlogs(String uid, String newUsername) async {
  try {
    final QuerySnapshot<Map<String, dynamic>> blogsSnapshot =
        await FirebaseFirestore.instance
            .collection('blogs')
            .where('authorId', isEqualTo: uid)
            .get();

    final List<DocumentSnapshot<Map<String, dynamic>>> blogsDocs =
        blogsSnapshot.docs;

    for (final blogDoc in blogsDocs) {
      await blogDoc.reference.update({'author': newUsername});
    }
  } catch (e) {
    print('Error updating author name in blogs: $e');
  }
}
