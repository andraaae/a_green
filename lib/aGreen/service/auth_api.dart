import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';

class AuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // REGISTER
  static Future<UserFirebaseModel?> registerUser({
    required String email,
    required String username,
    required String password,
    required String phone,
  }) async {
    try {
      // Create Auth account
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user!;

      // Create model
      final model = UserFirebaseModel(
        uid: user.uid,
        username: username,
        email: email,
        phone: phone,
        createdAt: DateTime.now().toIso8601String(),
        updateAt: DateTime.now().toIso8601String(),
      );

      // Save to Firestore
      await firestore.collection('users').doc(user.uid).set(model.toMap());

      return model;
    } catch (e) {
      print("REGISTER ERROR: $e");
      return null;
    }
  }

  // LOGIN
  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Login with Auth
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user!;

      // Get data from Firestore
      final snapshot =
          await firestore.collection('users').doc(user.uid).get();

      if (!snapshot.exists) return null;

      return UserFirebaseModel.fromMap(snapshot.data()!);
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }
}
