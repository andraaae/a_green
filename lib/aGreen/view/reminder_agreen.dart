import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:flutter/material.dart';

class ReminderAgreen extends StatefulWidget {
  const ReminderAgreen({super.key});

  @override
  State<ReminderAgreen> createState() => _ReminderAgreenState();
}

class _ReminderAgreenState extends State<ReminderAgreen> {
  List<PlantModel>? userPlants = [];
  bool isActive = false;
  bool isOn = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getReminderData();
  }

  Future<void> getReminderData() async {
    var id = await PreferenceHandler.getId();
    print(id);
    if (id != null) {
      List<PlantModel> plantsData = await DbHelper.getPlantsByUser(id);
      print("Loaded reminderPlants: $plantsData");
      setState(() {
        userPlants = plantsData;
      });
    }
    return; // keluar dari fungsi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Text(
                'Reminder',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff658C58),
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Don't forget to water your plants",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(
                      isOn
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: isOn ? Color(0xffABE7B2) : Color(0xffB7B89F),
                    ),
                    SizedBox(width: 12),

                    /// Bagian teks notifikasi
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notification',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isOn ? 'Active' : 'Inactive',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    // Switch on/off untuk mengaktifkan notifikasi
                    Switch(
                      value: isActive,
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                          isOn = value;
                        });
                      },
                      inactiveThumbColor: Color(0xffA0C878),
                      activeTrackColor: Color(0xffCBF3BB),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              Text('Upcoming Schedule', style: TextStyle(fontSize: 15)),
              SizedBox(height: 12),

              // Bagian card masing-masing tanaman
              Container(
                padding: EdgeInsets.all(8),
                width: double.infinity,
                height: 200, // pastikan ini cukup untuk scroll list
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: userPlants == null
                    ? Center(child: CircularProgressIndicator())
                    // List builder untuk menampilkan tiap tanaman
                    : ListView.builder(
                        itemCount: userPlants!.length,
                        itemBuilder: (context, index) {
                          final data = userPlants![index];

                          // Card untuk tiap tanaman
                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(data.plant),
                                  SizedBox(height: 4),
                                  Text(
                                    'Frequency: ${data.frequency}',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              ),
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
}
