import 'package:a_green/aGreen/database/preference_handler_firebase.dart';
import 'package:a_green/aGreen/models/plant_model_firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderFirebase extends StatefulWidget {
  const ReminderFirebase({super.key});

  @override
  State<ReminderFirebase> createState() => _ReminderFirebaseState();
}

class _ReminderFirebaseState extends State<ReminderFirebase> {
  List<PlantModelFirebase>? userPlants = [];
  bool isActive = false;
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    getReminderData();
    loadNotificationStatus();
  }

  Future<void> getReminderData() async {
    final String? uid = await PreferenceHandlerFirebase.getUid();

    if (uid == null) return;

    final query = await FirebaseFirestore.instance
        .collection("plants")
        .where("userUid", isEqualTo: uid)
        .get();

    final plants = query.docs
        .map((doc) => PlantModelFirebase.fromMap(doc.data(), doc.id))
        .toList();

    setState(() {
      userPlants = plants;
    });
  }

  Future<void> loadNotificationStatus() async {
    bool status = await PreferenceHandlerFirebase.getNotificationEnabled();
    setState(() {
      isActive = status;
      isOn = status;
    });
  }

  Future<void> updateNotificationStatus(bool value) async {
    setState(() {
      isActive = value;
      isOn = value;
    });
    await PreferenceHandlerFirebase.setNotificationEnabled(value);
  }

  bool isTimeToWater(String? lastWateredDate, String frequency) {
    if (lastWateredDate == null) return true;
    final last = DateTime.tryParse(lastWateredDate);
    if (last == null) return true;

    final freqMatch = RegExp(r'\d+').firstMatch(frequency);
    int freqDays = freqMatch != null ? int.parse(freqMatch.group(0)!) : 3;

    return DateTime.now().difference(last).inDays >= freqDays;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getReminderData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                'Reminder',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.green[200] : const Color(0xff658C58),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Don't forget to water your plants",
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),

              // notification row
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      isOn
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: isOn
                          ? Colors.greenAccent
                          : (isDark ? Colors.grey : Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Notification",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            isOn ? "Active" : "Inactive",
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isActive,
                      onChanged: updateNotificationStatus,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Upcoming Schedule",
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[850] : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: userPlants == null
                      ? const Center(child: CircularProgressIndicator())
                      : userPlants!.isEmpty
                      ? Center(
                          child: Text(
                            "No plants yet 🌱",
                            style: TextStyle(
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: userPlants!.length,
                          itemBuilder: (context, index) {
                            final data = userPlants![index];
                            final shouldWater = isTimeToWater(
                              data.lastWateredDate,
                              data.frequency,
                            );

                            return Card(
                              color: isDark
                                  ? Colors.grey[900]
                                  : Colors.grey[50],
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          data.name,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        if (shouldWater)
                                          const Icon(
                                            Icons.warning_amber_rounded,
                                            color: Colors.redAccent,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data.plant,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Frequency: ${data.frequency}",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[500]
                                            : Colors.grey[600],
                                      ),
                                    ),
                                    if (data.lastWateredDate != null)
                                      Text(
                                        "Last watered: ${DateFormat('dd MMM yyyy').format(DateTime.parse(data.lastWateredDate!))}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.grey[500]
                                              : Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
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
