import 'package:a_green/aGreen/database/preference_handler_firebase.dart';
import 'package:a_green/aGreen/models/plant_model_firebase.dart';
import 'package:a_green/aGreen/models/user_firebase.dart';
import 'package:a_green/aGreen/models/journal_model_firebase.dart';
import 'package:a_green/aGreen/service/firebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalFirebase extends StatefulWidget {
  const JournalFirebase({super.key});

  @override
  State<JournalFirebase> createState() => _JournalFirebaseState();
}

class _JournalFirebaseState extends State<JournalFirebase> {
  UserFirebaseModel? dataUser;
  List<PlantModelFirebase>? userPlants = [];
  List<PlantModelFirebase>? filteredPlants = [];

  Map<String, JournalModelFirebase?> lastJournalMap = {};

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  // 🔥 FIREBASE VERSION OF FETCHING DATA
  Future<void> getData() async {
    final uid = await PreferenceHandlerFirebase.getUid();
    if (uid == null) return;

    // Ambil user dari Firestore
    final userData = await FirebaseService.getUserData(uid);

    // Ambil plants user dari Firestore
    final plants = await FirebaseService.getPlantsByUser(uid);

    // Ambil jurnal plant untuk hari ini
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    Map<String, JournalModelFirebase?> lastJournalTemp = {};

    for (var plant in plants) {
      final journal = await FirebaseService.getJournalByPlantAndDate(
        uid,
        plant.name,
        today,
      );

      lastJournalTemp[plant.id!] = journal;
    }

    setState(() {
      dataUser = userData;
      userPlants = plants;
      filteredPlants = plants;
      lastJournalMap = lastJournalTemp;
    });
  }

  // FILTER SEARCH
  void _filterPlants(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        filteredPlants = userPlants;
      } else {
        filteredPlants = userPlants!
            .where(
              (plant) =>
                  plant.name.toLowerCase().contains(query.toLowerCase()) ||
                  plant.plant.toLowerCase().contains(query.toLowerCase()) ||
                  plant.frequency.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  // UI BELOW (TIDAK DIUBAH)
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Text(
                "Journal",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.green[200] : const Color(0xff658C58),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Record your green friend's journey",
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 30),

              // Summary
              Center(
                child: Container(
                  width: 220,
                  height: 100,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        userPlants?.length.toString() ?? "0",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.green[200] : const Color(0xff658C58),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Plants total",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Text(
                "Friend(s)",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 14),

              // Search bar
              TextField(
                controller: _searchController,
                onChanged: _filterPlants,
                decoration: InputDecoration(
                  hintText: "Search plant name or type...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

          
              // LIST PLANTS
          
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: filteredPlants == null
                      ? const Center(child: CircularProgressIndicator())
                      : filteredPlants!.isEmpty
                          ? Center(
                              child: Text(
                                _searchQuery.isEmpty
                                    ? "No plants yet 🌱"
                                    : "No match found 🌿",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredPlants!.length,
                              itemBuilder: (context, index) {
                                final plant = filteredPlants![index];
                                final lastJournal = lastJournalMap[plant.id];

                                return Card(
                                  color: isDark ? Colors.grey[900] : Colors.grey[50],
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      plant.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xff334433),
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Type: ${plant.plant}\nFrequency: ${plant.frequency}",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[700],
                                          ),
                                        ),
                                        if (lastJournal != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              "Last note: ${lastJournal.content}\n(${lastJournal.date})",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark
                                                    ? Colors.grey[500]
                                                    : Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    isThreeLine: lastJournal != null,
                                    onTap: () => _showJournalSheet(context, plant),
                                  ),
                                );
                              },
                            ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // BOTTOM SHEET – ADD JOURNAL (FIREBASE VERSION)
  void _showJournalSheet(BuildContext context, PlantModelFirebase plant) {
    final controller = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Journal for ${plant.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.green[200] : const Color(0xff658C58),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write down ${plant.name}'s progress here...",
                  hintStyle: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600]),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : const Color(0xffF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 14),

              ElevatedButton(
                onPressed: () async {
                  final note = controller.text.trim();
                  if (note.isEmpty) return;

                  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
                  final uid = await PreferenceHandlerFirebase.getUid();

                  if (uid == null) return;

                  final journal = JournalModelFirebase(
                    userUid: uid,
                    title: plant.name,
                    content: note,
                    date: date,
                  );

                  await FirebaseService.addJournal(journal);

                  setState(() {
                    lastJournalMap[plant.id!] = journal;
                  });

                  controller.clear();
                  Navigator.pop(context);

                  _showSaveDialog(context, plant.name);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? Colors.green[300] : const Color(0xff658C58),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Save"),
              ),
            ],
          ),
        );
      },
    );
  }

  // SAVE CONFIRMATION
  void _showSaveDialog(BuildContext context, String plantName) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Journal saved! 🌿",
          style: TextStyle(
            color: isDark ? Colors.green[200] : const Color(0xff658C58),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "$plantName progress has been recorded.",
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: TextStyle(
                color: isDark ? Colors.green[200] : const Color(0xff658C58),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
