import 'package:a_green/aGreen/database/preference_handler_firebase.dart';
import 'package:a_green/aGreen/models/plant_model_firebase.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';
import 'package:a_green/aGreen/service/firebase.dart';
import 'package:a_green/aGreen/view/plant_tips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageFirebase extends StatefulWidget {
  const HomePageFirebase({super.key});

  @override
  State<HomePageFirebase> createState() => _HomePageFirebaseState();
}

class _HomePageFirebaseState extends State<HomePageFirebase> {
  UserFirebaseModel? dataUser;
  String? uid;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void confirmDelete(PlantModelFirebase plant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete Plant",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to delete \"${plant.name}\"?",
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffE57373), // soft red
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                Navigator.pop(context); // tutup dialog dulu
                await deletePlant(plant); // lalu hapus
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> loadData() async {
    final savedUid = await PreferenceHandlerFirebase.getUid();
    final authUser = FirebaseAuth.instance.currentUser;
    final finalUid = savedUid ?? authUser?.uid;

    if (finalUid == null) {
      setState(() => loading = false);
      return;
    }

    setState(() => uid = finalUid);

    try {
      final userData = await FirebaseService.getUserData(finalUid);
      setState(() {
        dataUser = userData;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  // Progress calculation
  double calculateProgress(PlantModelFirebase plant) {
    if (plant.lastWateredDate == null) return 0;

    final last = DateTime.tryParse(plant.lastWateredDate!);
    if (last == null) return 0;

    final match = RegExp(r'\d+').firstMatch(plant.frequency);
    int freq = match != null ? int.parse(match.group(0)!) : 3;

    final diff = DateTime.now().difference(last).inDays;
    return (diff / freq).clamp(0.0, 1.0);
  }

  // Helper: apakah sudah waktunya disiram?
  bool isTimeToWaterPlant(PlantModelFirebase plant) {
    if (plant.lastWateredDate == null) return true;

    final last = DateTime.tryParse(plant.lastWateredDate!);
    if (last == null) return true;

    final match = RegExp(r'\d+').firstMatch(plant.frequency);
    int freqDays = match != null ? int.parse(match.group(0)!) : 3;

    return DateTime.now().difference(last).inDays >= freqDays;
  }

  // Water plant
  Future<void> waterPlant(PlantModelFirebase plant) async {
    if (plant.id == null) return;
    await FirebaseFirestore.instance.collection("plants").doc(plant.id).update({
      ...plant.ToFirestore(),
      "lastWateredDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Plant watered")));
  }

  // EDIT PLANT
  void showEditDialog(PlantModelFirebase plant) {
    final nameCtrl = TextEditingController(text: plant.name);
    final typeCtrl = TextEditingController(text: plant.plant);
    final freqCtrl = TextEditingController(text: plant.frequency);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Plant"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Plant name"),
            ),
            TextField(
              controller: typeCtrl,
              decoration: const InputDecoration(labelText: "Plant type"),
            ),
            TextField(
              controller: freqCtrl,
              decoration: const InputDecoration(
                labelText: "Watering frequency",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("plants")
                  .doc(plant.id)
                  .update({
                    "name": nameCtrl.text.trim(),
                    "plant": typeCtrl.text.trim(),
                    "frequency": freqCtrl.text.trim(),
                  });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // DELETE PLANT
  Future<void> deletePlant(PlantModelFirebase plant) async {
    if (plant.id == null) return;
    await FirebaseFirestore.instance
        .collection("plants")
        .doc(plant.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    if (loading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    if (uid == null) {
      return const Scaffold(
        body: Center(child: Text("UID missing — please login again")),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardOuterColor = isDark ? const Color(0xff2F2F2F) : Colors.white;
    final cardInnerColor = isDark ? const Color(0xff3A3A3A) : Colors.white;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${dataUser?.username}!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "How are your plants today?",
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Your Plants",
                style: TextStyle(
                  fontSize: 15,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardOuterColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("plants")
                        .where("userUid", isEqualTo: uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "No plants added yet!",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final raw =
                              docs[index].data() as Map<String, dynamic>;
                          final plant = PlantModelFirebase.fromMap(
                            raw,
                            docs[index].id,
                          );

                          final progress = calculateProgress(plant);
                          final needsWater = isTimeToWaterPlant(plant);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardInnerColor,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // NAME
                                Text(
                                  plant.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // TYPE
                                Text(
                                  plant.plant,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // FREQUENCY
                                Text(
                                  "Watering frequency: ${plant.frequency}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // PROGRESS BAR
                                LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 6,
                                  backgroundColor: Colors.grey.shade300,
                                  color: const Color(0xff8CA08A),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  "Progress: ${(progress * 100).toInt()}%",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // ICON BUTTONS (water icon color changes when needs watering,
                                // delete icon is soft red)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.water_drop),
                                      color: needsWater
                                          ? const Color(0xff80A1BA)
                                          : const Color(0xff6A8A7A),
                                      onPressed: () => waterPlant(plant),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      color: const Color(0xff6A8A7A),
                                      onPressed: () => showEditDialog(plant),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      color: const Color(
                                        0xffE57373,
                                      ), // soft red
                                      onPressed: () {
                                        confirmDelete(plant);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
