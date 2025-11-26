import 'package:a_green/aGreen/models/journal_model_firebase.dart';
import 'package:a_green/aGreen/models/plant_model_firebase.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final _firestore = FirebaseFirestore.instance;
  static int extractDays(String freq) {
    final match = RegExp(r'\d+').firstMatch(freq);
    return match != null ? int.parse(match.group(0)!) : 3;
  }

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

      final snap = await firestore.collection('users').doc(user.uid).get();

      if (!snap.exists) return null;

      return UserFirebaseModel.fromMap({'uid': user.uid, ...snap.data()!});
    } on FirebaseAuthException {
      return null;
    }
  }

  // GET USER DATA
  static Future<UserFirebaseModel?> getUserData(String uid) async {
    final snap = await firestore.collection('users').doc(uid).get();
    if (!snap.exists) return null;

    return UserFirebaseModel.fromMap({'uid': uid, ...snap.data()!});
  }

  // UPDATE USER DATA (TIDAK DIUBAH)
  static Future<void> updateUserData(
    String uid,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection('users').doc(uid).update(data);
  }

  // ADD PLANT  (FIXED)
  static Future<void> addPlant(PlantModelFirebase plant) async {
    if (plant.userUid.isEmpty) {
      throw Exception("ERROR: userUid kosong saat addPlant()");
    }

    await _firestore.collection("plants").add(plant.ToFirestore());
  }

  // UPDATE PLANT  (AMAN)
  static Future<void> updatePlant(PlantModelFirebase plant) async {
    if (plant.id == null) return;

    await _firestore
        .collection("plants")
        .doc(plant.id)
        .update(plant.ToFirestore());
  }

  // DELETE PLANT
  static Future<void> deletePlant(String id) async {
    await _firestore.collection("plants").doc(id).delete();
  }

  // GET PLANTS BY USER UID (FULL FIX)
  static Future<List<PlantModelFirebase>> getPlantsByUser(
    String userUid,
  ) async {
    final query = await _firestore
        .collection("plants")
        .where("userUid", isEqualTo: userUid) // FIXED FIELD
        .get();

    return query.docs
        .map(
          (doc) => PlantModelFirebase.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  // JOURNAL SECTION

  /// ADD JOURNAL (dipakai di JournalPage)
  static Future<void> addJournal(JournalModelFirebase journal) async {
    await _firestore.collection("journals").add(journal.toFirestore());
  }

  /// GET JOURNAL BY PLANT + DATE (dipakai buat last note di JournalPage)
  static Future<JournalModelFirebase?> getJournalByPlantAndDate(
    String userUid,
    String plantName,
    String date,
  ) async {
    final query = await _firestore
        .collection("journals")
        .where("userUid", isEqualTo: userUid)
        .where("title", isEqualTo: plantName)
        .where("date", isEqualTo: date)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;

    return JournalModelFirebase.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  /// (Optional) GET ALL JOURNALS USER – mungkin kepake nanti
  static Future<List<JournalModelFirebase>> getJournalsByUser(
    String userUid,
  ) async {
    final query = await _firestore
        .collection("journals")
        .where("userUid", isEqualTo: userUid)
        .orderBy("date", descending: true)
        .get();

    return query.docs
        .map(
          (doc) => JournalModelFirebase.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }
}
