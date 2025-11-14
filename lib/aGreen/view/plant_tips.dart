import 'package:flutter/material.dart';

class PlantTipsPage extends StatelessWidget {
  const PlantTipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDFF6D4),
      appBar: AppBar(
        title: const Text("Plant Tips"),
        backgroundColor: const Color(0xFF8CBF75),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          TipItem(
            title: "Pencahayaan",
            desc: "Sesuaikan kebutuhan cahaya setiap tanaman.",
          ),
          TipItem(
            title: "Penyiraman",
            desc: "Jangan terlalu sering menyiram, cek tanah dulu.",
          ),
          TipItem(
            title: "Kelembapan & Suhu",
            desc: "Hindari AC atau angin dingin langsung.",
          ),
          TipItem(
            title: "Pemupukan",
            desc: "Berikan pupuk lebih banyak saat musim tumbuh.",
          ),
          TipItem(
            title: "Hama & Penyakit",
            desc: "Cek daun rutin, gunakan pestisida organik.",
          ),
          TipItem(
            title: "Pot & Drainase",
            desc: "Pastikan pot punya lubang drainase.",
          ),
        ],
      ),
    );
  }
}

class TipItem extends StatelessWidget {
  final String title;
  final String desc;

  const TipItem({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          )
        ],
      ),
    );
  }
}
