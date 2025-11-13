// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class JournalModel {
  final int? id; // id otomatis dari database
  final int userId; // id user yang nulis jurnal
  final String title; // misal: nama tanaman atau judul jurnal
  final String content; // isi jurnal
  final String date; // tanggal jurnal dibuat (format yyyy-MM-dd)

  JournalModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert ke Map untuk disimpan di database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  // Convert dari Map (saat ambil dari database)
  factory JournalModel.fromMap(Map<String, dynamic> map) {
    return JournalModel(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      content: map['content'] as String,
      date: map['date'] as String,
    );
  }

  // Tambahan opsional (biar bisa encode/decode JSON kalau dibutuhkan)
  String toJson() => json.encode(toMap());
  factory JournalModel.fromJson(String source) =>
      JournalModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
