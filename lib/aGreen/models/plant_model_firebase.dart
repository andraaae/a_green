import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class PlantModelFirebase {
  String? id; // Firestore doc ID
  String userUid; // UID Firebase user
  final String name;
  final String plant;
  final String status;
  final String frequency;
  final String? lastWateredDate;

  PlantModelFirebase({
    this.id,
    required this.userUid,
    required this.name,
    required this.plant,
    required this.status,
    required this.frequency,
    this.lastWateredDate,
  });

  // Convert to Firestore map
  Map<String, dynamic> ToFirestore() {
    return {
      'userUid': userUid,
      'name': name,
      'plant': plant,
      'status': status,
      'frequency': frequency,
      'lastWateredDate': lastWateredDate,
    };
  }

  // Convert from Firestore snapshot
  factory PlantModelFirebase.fromMap(Map<String, dynamic> map, String docId) {
    return PlantModelFirebase(
      id: docId,
      userUid: map['userUid'] ?? '',
      name: map['name'] ?? '',
      plant: map['plant'] ?? '',
      status: map['status'] ?? '',
      frequency: map['frequency'] ?? '',
      lastWateredDate: map['lastWateredDate'],
    );
  }

  String toJson() => json.encode(ToFirestore());

  factory PlantModelFirebase.fromJson(String source) =>
      PlantModelFirebase.fromMap(json.decode(source), '');
}
