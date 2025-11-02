import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class PlantModel {
  int? id;
  String name;
  String plant;
  String status; 

  PlantModel({
    this.id,
    required this.name,
    required this.plant,
    required this.status
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'plant': plant,
      'status': status,
    };
  }

  factory PlantModel.fromMap(Map<String, dynamic> map) {
    return PlantModel(
      id: map['id'] as int,
      name: map['name'] as String,
      plant: map['plant'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlantModel.fromJson(String source) =>
      PlantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}