import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:flutter/material.dart';

class JournalPageAgreen extends StatefulWidget {
  const JournalPageAgreen({super.key});

  @override
  State<JournalPageAgreen> createState() => _JournalPageAgreenState();
}

class _JournalPageAgreenState extends State<JournalPageAgreen> {
  UserModel? dataUser;
  List<PlantModel>? userPlants = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var id = await PreferenceHandler.getId();
    if (id != null) {
      UserModel? result = await DbHelper.getUser(id);
      List<PlantModel> plantsData = await DbHelper.getPlantsByUser(id);
      setState(() {
        dataUser = result;
        userPlants = plantsData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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

              // 🌱 Total plant summary
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
                        ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userPlants?.length.toString() ?? "0",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? Colors.green[200] : const Color(0xff658C58),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Plants total',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
              Text(
                'Friend(s)',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 14),

              // 🌿 Plant list
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: userPlants == null
                    ? const Center(child: CircularProgressIndicator())
                    : userPlants!.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Center(
                              child: Text(
                                "No plants yet 🌱",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[700],
                                ),
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: userPlants!.length,
                            itemBuilder: (context, index) {
                              final data = userPlants![index];
                              return Card(
                                color: isDark ? Colors.grey[900] : Colors.grey[50],
                                elevation: 3,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  title: Text(
                                    data.name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xff334433),
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Type: ${data.plant}\nFrequency: ${data.frequency}",
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[700],
                                    ),
                                  ),
                                  isThreeLine: true,
                                  onTap: () => _showJournalSheet(context, data),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✍️ Bottom sheet for journaling
  void _showJournalSheet(BuildContext context, PlantModel data) {
    final TextEditingController controller = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Catatan untuk ${data.name}",
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
                  hintText: "Tulis perkembangan ${data.name} di sini...",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[850] : const Color(0xffF7F7F7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  final note = controller.text.trim();
                  if (note.isNotEmpty) {
                    Navigator.pop(context);
                    _showSaveDialog(context, data.name);
                    controller.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? Colors.green[300] : const Color(0xff658C58),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🌿 Confirmation dialog
  void _showSaveDialog(BuildContext context, String plantName) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          "Catatan tersimpan! 🌿",
          style: TextStyle(
            color: isDark ? Colors.green[200] : const Color(0xff658C58),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "$plantName sudah dicatat perkembangannya.",
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Oke",
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
