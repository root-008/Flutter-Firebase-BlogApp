import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<String?> registration(
      {required String email, required String password}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, 'reader')});
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Zayıf Parola';
      } else if (e.code == 'email-already-in-use') {
        return 'Bu E-Posta adresine sahip kullanıcı mevcut.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'asdasdasdasdas';
    }
  }

  postDetailsToFirestore(String email, String rool) async {
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({
      'email': email,
      'rool': rool,
      'username': email.split('@')[0],
      'prof_pic': 'profile_pic/defaultpp.jpg'
    });
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Kullanıcı bulunamadı.';
      } else if (e.code == 'wrong-password') {
        return 'Hatalı parola!';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
