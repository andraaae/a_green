import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReminderAgreen extends StatefulWidget {
  const ReminderAgreen({super.key});

  @override
  State<ReminderAgreen> createState() => _ReminderAgreenState();
}

class _ReminderAgreenState extends State<ReminderAgreen> {
  List<PlantModel>? userPlants = [];
  bool isActive = false;
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    getReminderData();
    loadNotificationStatus();
  }

  Future<void> getReminderData() async {
    var id = await PreferenceHandler.getId();
    if (id != null) {
      List<PlantModel> plantsData = await DbHelper.getPlantsByUser(id);
      setState(() {
        userPlants = plantsData;
      });
    }
  }

  Future<void> loadNotificationStatus() async {
    bool status = await PreferenceHandler.getNotificationEnabled();
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
    await PreferenceHandler.setNotificationEnabled(value);
  }

  bool isTimeToWater(String? lastWateredDate, String frequency) {
    if (lastWateredDate == null) return true;
    final lastWatered = DateTime.tryParse(lastWateredDate);
    if (lastWatered == null) return true;
    final freqMatch = RegExp(r'\d+').firstMatch(frequency);
    int freqDays = freqMatch != null ? int.parse(freqMatch.group(0)!) : 3;
    return DateTime.now().difference(lastWatered).inDays >= freqDays;
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

              // Toggle notification container
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
                          ? (isDark
                              ? Colors.greenAccent
                              : const Color(0xffABE7B2))
                          : (isDark
                              ? Colors.grey[600]
                              : const Color(0xffB7B89F)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            isOn ? 'Active' : 'Inactive',
                            style: TextStyle(
                              color: isDark ? Colors.grey[400] : Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        updateNotificationStatus(value);
                      },
                      inactiveThumbColor: const Color(0xffA0C878),
                      activeTrackColor: const Color(0xffCBF3BB),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              Text(
                'Upcoming Schedule',
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),

              // Container list scrollable
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
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
                                  'No plants yet 🌱',
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: userPlants!.length,
                              itemBuilder: (context, index) {
                                final data = userPlants![index];
                                final shouldWater = isTimeToWater(
                                    data.lastWateredDate, data.frequency);

                                return Card(
                                  color: isDark
                                      ? Colors.grey[900]
                                      : Colors.grey[50],
                                  elevation: 3,
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    data.name,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  if (shouldWater)
                                                    const Icon(
                                                      Icons
                                                          .warning_amber_rounded,
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
                                                'Frequency: ${data.frequency}',
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.grey[500]
                                                      : Colors.grey[600],
                                                ),
                                              ),
                                              if (data.lastWateredDate != null)
                                                Text(
                                                  'Last watered: ${DateFormat('dd MMM yyyy').format(DateTime.parse(data.lastWateredDate!))}',
                                                  style: TextStyle(
                                                    color: isDark
                                                        ? Colors.grey[500]
                                                        : Colors.grey,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                            ],
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
