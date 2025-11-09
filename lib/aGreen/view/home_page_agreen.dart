import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePageAgreen extends StatefulWidget {
  const HomePageAgreen({super.key});

  @override
  State<HomePageAgreen> createState() => _HomePageAgreenState();
}

class _HomePageAgreenState extends State<HomePageAgreen> {
  UserModel? dataUser;
  List<PlantModel>? userPlants = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 🔹 Load user & plant data
  Future<void> loadData() async {
    int? id = await PreferenceHandler.getId();

    if (id != null) {
      final user = await DbHelper.getUser(id);
      final plants = await DbHelper.getPlantsByUser(id);
      setState(() {
        dataUser = user;
        userPlants = plants;
      });
    }
  }

  // 🔹 Calculate watering progress
  double calculateProgress(PlantModel plant) {
    if (plant.lastWateredDate == null) return 0.0;

    final lastWatered = DateTime.tryParse(plant.lastWateredDate!);
    if (lastWatered == null) return 0.0;

    // extract number from frequency (e.g., "3 days" → 3)
    final freqMatch = RegExp(r'\d+').firstMatch(plant.frequency);
    int freqDays = freqMatch != null ? int.parse(freqMatch.group(0)!) : 3;

    final now = DateTime.now();
    final diffDays = now.difference(lastWatered).inDays;

    double progress = diffDays / freqDays;
    if (progress > 1.0) progress = 1.0;
    return progress;
  }

  // 🔹 Update last watered date to today
  Future<void> waterPlant(PlantModel plant) async {
    final updated = PlantModel(
      id: plant.id,
      userId: plant.userId,
      name: plant.name,
      plant: plant.plant,
      status: plant.status,
      frequency: plant.frequency,
      lastWateredDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    await DbHelper.updatePlant(updated);
    loadData();
  }

  // 🔹 Edit plant dialog
  void showUpdateDialog(PlantModel plant) {
    final TextEditingController nameController =
        TextEditingController(text: plant.name);
    final TextEditingController typeController =
        TextEditingController(text: plant.plant);
    final TextEditingController frequencyController =
        TextEditingController(text: plant.frequency);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Plant Name'),
              ),
              TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Plant Type'),
              ),
              TextField(
                controller: frequencyController,
                decoration: const InputDecoration(labelText: 'Watering Frequency'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () async {
                final updatedPlant = PlantModel(
                  id: plant.id,
                  name: nameController.text,
                  plant: typeController.text,
                  frequency: frequencyController.text,
                  status: plant.status,
                  userId: plant.userId,
                  lastWateredDate: plant.lastWateredDate,
                );

                await DbHelper.updatePlant(updatedPlant);
                Navigator.pop(context);
                loadData();
              },
            ),
          ],
        );
      },
    );
  }

  // 🔹 Delete confirmation
  Future<void> deletePlantWithConfirm(PlantModel plant) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plant'),
        content: Text('Are you sure you want to delete "${plant.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DbHelper.deletePlant(plant.id!);
      loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Plant "${plant.name}" deleted successfully.'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              dataUser == null
                  ? const CircularProgressIndicator()
                  : Text(
                      'Hello, ${dataUser?.username ?? ""}!',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color(0xff777C6D),
                      ),
                    ),
              const SizedBox(height: 10),
              const Text(
                'How are your plants today?',
                style: TextStyle(fontSize: 18, color: Color(0xff819067)),
              ),
              const SizedBox(height: 25),
              const Text(
                'Your Plants',
                style: TextStyle(fontSize: 16, color: Color(0xff819067)),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: userPlants == null || userPlants!.isEmpty
                      ? const Center(child: Text('No plants added yet!'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userPlants?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = userPlants![index];
                            final progress = calculateProgress(data);
                            final progressPercent = (progress * 100).toInt();

                            final canWater = progress >= 1.0;

                            return ListTile(
                              title: Text(
                                data.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff748873),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.plant,
                                    style: const TextStyle(
                                        color: Color(0xff748873)),
                                  ),
                                  Text(
                                    'Watering frequency: ${data.frequency}',
                                    style: const TextStyle(
                                        color: Color(0xff748873)),
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: progress,
                                    borderRadius: BorderRadius.circular(11),
                                    backgroundColor: const Color(0x80A6AD88),
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                            Color(0xffA6AD88)),
                                  ),
                                  Text(
                                    'Progress: $progressPercent%',
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xff748873)),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.water_drop, size: 18),
                                    color: canWater
                                        ? const Color(0xff758A93)
                                        : Colors.grey.shade400,
                                    onPressed: canWater
                                        ? () => waterPlant(data)
                                        : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    color: const Color(0xff758A93),
                                    onPressed: () => showUpdateDialog(data),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    color: const Color(0xff758A93),
                                    onPressed: () =>
                                        deletePlantWithConfirm(data),
                                  ),
                                ],
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
