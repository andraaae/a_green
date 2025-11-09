// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlantModel {
  int? id;
  int? userId;
  final String name;
  final String plant;
  final String status;
  final String frequency;
  final String? lastWateredDate; // 🔹 kolom baru

  PlantModel({
    this.id,
    this.userId,
    required this.name,
    required this.plant,
    required this.status,
    required this.frequency,
    this.lastWateredDate, // 🔹 tambahin di constructor
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'plant': plant,
      'status': status,
      'frequency': frequency,
      'lastWateredDate': lastWateredDate, // 🔹 simpan juga ke map
    };
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] as int?,
      name: map['name'] as String,
      plant: map['plant'] as String,
      status: map['status'] as String,
      frequency: map['frequency'] as String,
      lastWateredDate: map['lastWateredDate'] != null
          ? map['lastWateredDate'] as String
          : null, // 🔹 ambil dari db kalau ada
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) =>
      PlantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
