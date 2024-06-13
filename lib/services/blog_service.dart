import 'package:blog_app/model/blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogService {
  final db = FirebaseFirestore.instance;

  void addBlog({required Blog blog}) async {
    final docRef = db.collection('blogs').doc();
    Blog appt = Blog(
        title: blog.title,
        text: blog.text,
        author: blog.author,
        time: blog.time,
        category: blog.category,
        authorId: blog.authorId,
        id: docRef.id,
        views: blog.views);

    await docRef.set(appt.toJson());
  }

  getBlogs() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection('blogs').orderBy('time', descending: true).snapshots();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getBlogsByCategory(
    String category,
  ) async {
    final db = FirebaseFirestore.instance;

    final query = db
        .collection('blogs')
        .where('category', isEqualTo: category)
        .orderBy('time', descending: true);

    final querySnapshot = await query.get();

    return querySnapshot.docs;
  }

  Future<List<Blog>> getSavedBlogs() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    try {
      String userId = user!.uid;

      QuerySnapshot savedBlogsSnapshot = await db
          .collection('savedBlogs')
          .where('userId', isEqualTo: userId)
          .get();

      List<String> blogIds = savedBlogsSnapshot.docs
          .map((doc) => doc['blogId'] as String)
          .toList();

      if (blogIds.isEmpty) {
        return []; // Return an empty list if no saved blogs found
      }

      QuerySnapshot blogsSnapshot = await db
          .collection('blogs')
          .where(FieldPath.documentId, whereIn: blogIds)
          .get();

      List<Blog> savedBlogs = blogsSnapshot.docs
          .map((doc) => Blog.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return savedBlogs; // Return the list of saved blogs
    } catch (e) {
      //print("Error fetching saved blogs: $e");
      return []; // Return an empty list in case of any errors
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getContent(String id) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    var collection = db.collection('blogs');
    var docSnapshot = await collection.doc(id).get();
    // Okunma sayısını artır
    var currentViews = docSnapshot.data()?['views'] ?? 0;
    await collection.doc(id).update({'views': currentViews + 1});

    // Güncellenmiş belgeyi döndür
    var updatedDocSnapshot = await collection.doc(id).get();
    return updatedDocSnapshot;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getBlogsByTrend() async {
    final db = FirebaseFirestore.instance;
    final querySnapshot = await db
        .collection('blogs')
        .orderBy('views', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs;
  }
}
