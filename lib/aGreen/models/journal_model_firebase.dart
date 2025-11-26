import 'dart:convert';

class JournalModelFirebase {
  String? id; // Firestore document ID
  final String userUid; // UID Firebase user
  final String title;
  final String content;
  final String date;

  JournalModelFirebase({
    this.id,
    required this.userUid,
    required this.title,
    required this.content,
    required this.date,
  });

  // Convert ke Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "userUid": userUid,
      "title": title,
      "content": content,
      "date": date,
    };
  }

  // Convert dari Firestore snapshot
  factory JournalModelFirebase.fromMap(
      Map<String, dynamic> map, String docId) {
    return JournalModelFirebase(
      id: docId,
      userUid: map["userUid"] ?? "",
      title: map["title"] ?? "",
      content: map["content"] ?? "",
      date: map["date"] ?? "",
    );
  }

  // Opsional: JSON encoder
  String toJson() => json.encode(toFirestore());

  factory JournalModelFirebase.fromJson(String source) =>
      JournalModelFirebase.fromMap(
        json.decode(source),
        "", // docId tidak tersedia dalam JSON biasa
      );
}
