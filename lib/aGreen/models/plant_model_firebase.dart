import 'dart:convert';

class PlantModelFirebase {
  String? id; // Firestore Document ID
  String userUid; // UID User pemilik tanaman
  final String name;
  final String plant;
  final String status;
  final String frequency;
  final String? lastWateredDate;

  bool hasNotified; // <-- untuk mencegah notif berulang

  PlantModelFirebase({
    this.id,
    required this.userUid,
    required this.name,
    required this.plant,
    required this.status,
    required this.frequency,
    this.lastWateredDate,
    this.hasNotified = false, // <-- default false
  });

  // Convert ke Firestore
  Map<String, dynamic> ToFirestore() {
    return {
      'userUid': userUid,
      'name': name,
      'plant': plant,
      'status': status,
      'frequency': frequency,
      'lastWateredDate': lastWateredDate,
      'hasNotified': hasNotified, // <-- ikut disimpan
    };
  }

  // Convert dari Firestore
  factory PlantModelFirebase.fromMap(Map<String, dynamic> map, String docId) {
    return PlantModelFirebase(
      id: docId,
      userUid: map['userUid'] ?? '',
      name: map['name'] ?? '',
      plant: map['plant'] ?? '',
      status: map['status'] ?? '',
      frequency: map['frequency'] ?? '',
      lastWateredDate: map['lastWateredDate'],
      hasNotified: map['hasNotified'] ?? false, // <-- aman meski tidak ada
    );
  }

  String toJson() => json.encode(ToFirestore());

  factory PlantModelFirebase.fromJson(String source) =>
      PlantModelFirebase.fromMap(json.decode(source), '');
}
