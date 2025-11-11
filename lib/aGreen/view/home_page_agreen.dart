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

  double calculateProgress(PlantModel plant) {
    if (plant.lastWateredDate == null) return 0.0;

    final lastWatered = DateTime.tryParse(plant.lastWateredDate!);
    if (lastWatered == null) return 0.0;

    final freqMatch = RegExp(r'\d+').firstMatch(plant.frequency);
    int freqDays = freqMatch != null ? int.parse(freqMatch.group(0)!) : 3;

    final now = DateTime.now();
    final diffDays = now.difference(lastWatered).inDays;

    double progress = diffDays / freqDays;
    return progress.clamp(0.0, 1.0);
  }

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
          backgroundColor: Theme.of(context).colorScheme.surface,
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
                decoration:
                    const InputDecoration(labelText: 'Watering Frequency'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
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

  Future<void> deletePlantWithConfirm(PlantModel plant) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.grey[200] : const Color(0xff748873);
    final subTextColor =
        isDark ? Colors.grey[400] : const Color(0xff748873);

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
                      style: TextStyle(
                        fontSize: 20,
                        color: textColor,
                      ),
                    ),
              const SizedBox(height: 10),
              Text(
                'How are your plants today?',
                style: TextStyle(fontSize: 18, color: subTextColor),
              ),
              const SizedBox(height: 25),
              Text(
                'Your Plants',
                style: TextStyle(fontSize: 16, color: subTextColor),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                    ],
                  ),
                  child: userPlants == null || userPlants!.isEmpty
                      ? Center(
                          child: Text(
                            'No plants added yet!',
                            style: TextStyle(color: subTextColor),
                          ),
                        )
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
                                style: TextStyle(
                                  fontSize: 18,
                                  color: textColor,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.plant, style: TextStyle(color: subTextColor)),
                                  Text('Watering frequency: ${data.frequency}',
                                      style: TextStyle(color: subTextColor)),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: progress,
                                    borderRadius: BorderRadius.circular(11),
                                    backgroundColor: isDark
                                        ? Colors.grey[700]
                                        : const Color(0x80A6AD88),
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(
                                            const Color(0xffA6AD88)),
                                  ),
                                  Text(
                                    'Progress: $progressPercent%',
                                    style: TextStyle(
                                        fontSize: 12, color: subTextColor),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon:
                                        const Icon(Icons.water_drop, size: 18),
                                    color: canWater
                                        ? const Color(0xffA6D8A8)
                                        : Colors.grey.shade500,
                                    onPressed:
                                        canWater ? () => waterPlant(data) : null,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, size: 18),
                                    color: const Color(0xffA6D8A8),
                                    onPressed: () => showUpdateDialog(data),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, size: 18),
                                    color: Color(0xffB7B89F),
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
