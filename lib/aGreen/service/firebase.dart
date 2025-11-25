import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:a_green/aGreen/models/plant_model_firebase.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _firestore = FirebaseFirestore.instance;
  // REGISTER USER
  static Future<UserFirebaseModel> registerUser({
    required String email,
    required String username,
    required String password,
    required String phone,
  }) async {
    final cred = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = cred.user!;

    final model = UserFirebaseModel(
      uid: user.uid,
      email: email,
      username: username,
      phone: phone,
      createdAt: DateTime.now().toIso8601String(),
      updateAt: DateTime.now().toIso8601String(),
    );

    // FIX: gunakan 'users' (bukan user)
    await firestore.collection('users').doc(user.uid).set(model.toMap());

    return model;
  }

  // LOGIN USER
  static Future<UserFirebaseModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;
      if (user == null) return null;

      // GET DATA FROM FIRESTORE
      final snap = await firestore.collection('users').doc(user.uid).get();

      if (!snap.exists) return null;

      return UserFirebaseModel.fromMap({
        'uid': user.uid,
        ...snap.data()!,
      });

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        return null;
      }

      print('FirebaseAuthException: ${e.code} - ${e.message}');
      rethrow;
    }
  }

  // GET USER DATA FROM FIRESTORE
  static Future<UserFirebaseModel?> getUserData(String uid) async {
    final snap = await firestore.collection('users').doc(uid).get();
    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap({
      'uid': uid,
      ...snap.data()!,
    });
  }

  // UPDATE USER DATA
  static Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await firestore.collection('users').doc(uid).update(data);
  }

// ADD PLANT
  static Future<void> addPlant(PlantModelFirebase plant) async {
    await _firestore.collection("plants").add(plant.toMap()); //error
  }

  // UPDATE PLANT
  static Future<void> updatePlant(PlantModelFirebase plant) async {
    if (plant.id == null) return;    
    await _firestore.collection("plants").doc(plant.id).update(plant.toMap()); //error
  }

  // DELETE PLANT
  static Future<void> deletePlant(String id) async {
    await _firestore.collection("plants").doc(id).delete();
  }

  // GET PLANTS BY USER UID
  static Future<List<PlantModelFirebase>> getPlantsByUser(String userId) async {
    final query = await _firestore
        .collection("plants")
        .where("userId", isEqualTo: userId)
        .get();

    return query.docs //error
        .map((doc) => PlantModel.toMap(doc.id, doc.data())) //error
        .toList();
  }
}
