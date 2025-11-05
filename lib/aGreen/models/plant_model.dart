// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlantModel {
  int? id;
  int? userId;
  final String name;
  final String plant;
  final String status;
  final String frequency;

  PlantModel({
    this.id,
    this.userId,
    required this.name,
    required this.plant,
    required this.status,
    required this.frequency,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'name': name,
      'plant': plant,
      'status': status,
      'frequency': frequency,
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
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) =>
      PlantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
