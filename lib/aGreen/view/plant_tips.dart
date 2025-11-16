import 'package:a_green/aGreen/view/plant_tip_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:a_green/theme/theme_provider.dart';

class PlantTips extends StatelessWidget {
  const PlantTips({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // WARNA SESUAI MODE
    final bgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFCBF3BB);
    final appBarColor = isDark ? const Color(0xFF2B2B2B) : const Color(0xFFCBF3BB);
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    final Map<String, String> details = {
      "Pencahayaan": """
🌤️ **Pencahayaan**

Pastikan tanaman mendapat cahaya yang sesuai dengan kebutuhan spesiesnya.

• Tidak semua tanaman butuh sinar matahari langsung.  
• Tanaman tropis biasanya suka cahaya terang tidak langsung.  
• Tanaman seperti kaktus & sukulen cocok matahari langsung.  
• Jika daun memanjang & pucat → **kekurangan cahaya**.  
• Jika daun gosong → **terlalu banyak cahaya**.

➡️ Tips: Letakkan dekat jendela, gunakan tirai tipis jika cahaya terlalu terik.
""",
      "Penyiraman": """
💧 **Penyiraman**

Kunci utama adalah menyiram sesuai kebutuhan, bukan jadwal tetap.

• Cek kelembapan tanah 2–3 cm dari permukaan.  
• Jika masih lembap, **jangan disiram**.  
• Air berlebih menyebabkan akar busuk.  
• Gunakan pot dengan drainase agar air tidak menggenang.  
• “Sedikit tapi rutin lebih baik dari banyak tapi jarang.”

➡️ Tips: Gunakan moisture meter untuk memudahkan.
""",
      "Kelembapan & Suhu": """
🌡️ **Kelembapan & Suhu**

• Tanaman tropis suka kelembapan tinggi & suhu stabil 18–27°C.  
• Hindari menaruh tanaman dekat AC/kipas.  
• Jika ujung daun mengering → udara terlalu kering.  
• Semprot daun 2–3 kali seminggu atau gunakan humidifier.

➡️ Tips: Kelompokkan beberapa tanaman untuk meningkatkan kelembapan alami.
""",
      "Pemupukan": """
🌱 **Pemupukan**

• Musim tumbuh (semi & panas): pupuk 2–4 minggu sekali.  
• Musim hujan/dingin: kurangi atau hentikan.  
• Tanaman daun → nitrogen tinggi.  
• Tanaman berbunga → fosfor tinggi.  
• Jangan memupuk saat tanah kering.

➡️ Tips: Pupuk cair lebih mudah dikontrol.
""",
      "Hama & Penyakit": """
🐛 **Hama & Penyakit**

• Cek daun secara rutin.  
• Hama umum: kutu putih, thrips, tungau merah, aphid.  
• Tanda serangan: bercak putih, debu halus, jaring kecil.  
• Bersihkan dengan air sabun atau alkohol 70%.  
• Gunakan neem oil 1–2 minggu sekali.

➡️ Tips: Karantina tanaman baru selama 1 minggu.
""",
      "Pot & Drainase": """
🪴 **Pot & Drainase**

• Selalu gunakan pot dengan lubang drainase.  
• Media tanam harus sesuai jenis tanaman.  
• Jika pot dekorasi tidak ada lubang → gunakan sebagai cover pot.  
• Cek apakah akar sudah terlalu penuh.

➡️ Tips: Repotting setiap 6–12 bulan.
""",
      "Rotasi Tanaman": """
🔄 **Rotasi Tanaman**

• Tanaman tumbuh mengikuti arah cahaya.  
• Putar 90° setiap 1–2 minggu agar tumbuh seimbang.  
• Mencegah batang miring ke satu sisi.

➡️ Tips: Penting untuk tanaman besar seperti monstera atau fiddle leaf fig.
""",
    };

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          "Plant Tips",
          style: TextStyle(color: textColor),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...details.entries.map(
            (item) => Column(
              children: [
                TipItem(
                  title: item.key,
                  desc: _shortDesc(item.key),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlantTipDetail(
                          title: item.key,
                          detail: item.value,
                        ),
                      ),
                    );
                  },
                  cardColor: cardColor,
                  titleColor: textColor,
                  descColor: subTextColor,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _shortDesc(String key) {
    switch (key) {
      case "Pencahayaan":
        return "Sesuaikan kebutuhan cahaya setiap tanaman.";
      case "Penyiraman":
        return "Jangan terlalu sering menyiram, cek tanah dulu.";
      case "Kelembapan & Suhu":
        return "Jaga kelembapan dan suhu agar stabil.";
      case "Pemupukan":
        return "Sesuaikan pupuk dengan musim tumbuh.";
      case "Hama & Penyakit":
        return "Periksa daun secara rutin untuk menghindari hama.";
      case "Pot & Drainase":
        return "Pastikan pot punya drainase yang baik.";
      case "Rotasi Tanaman":
        return "Putar posisi tanaman agar tumbuh merata.";
      default:
        return "";
    }
  }
}

class TipItem extends StatelessWidget {
  final String title;
  final String desc;
  final VoidCallback onTap;

  final Color cardColor;
  final Color titleColor;
  final Color descColor;

  const TipItem({
    super.key,
    required this.title,
    required this.desc,
    required this.onTap,
    required this.cardColor,
    required this.titleColor,
    required this.descColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: cardColor,
        foregroundColor: titleColor,
        shadowColor: Colors.black26,
        elevation: 3,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              desc,
              style: TextStyle(
                fontSize: 13,
                color: descColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
