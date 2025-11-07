import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:flutter/material.dart';

class HomePageAgreen extends StatefulWidget {
  @override
  const HomePageAgreen({super.key});

  @override
  State<HomePageAgreen> createState() => _HomePageAgreenState();
}

class _HomePageAgreenState extends State<HomePageAgreen> {
  int selectedIndex = 0;
  UserModel? dataUser;
  List<PlantModel>? userPlants = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load user data and plant list
  Future<void> loadData() async {
    int? id = await PreferenceHandler.getId();

    if (id != null) {
      print("User ID: $id");
      final user = await DbHelper.getUser(id);
      final plants = await DbHelper.getPlantsByUser(id);
      print("Fetched plants count: ${plants.length}");

      setState(() {
        dataUser = user;
        userPlants = plants;
      });
    }
  }

  // Show update form dialog
  void showUpdateDialog(PlantModel plant) {
    final TextEditingController nameController = TextEditingController(
      text: plant.name,
    );
    final TextEditingController typeController = TextEditingController(
      text: plant.plant,
    );
    final TextEditingController frequencyController = TextEditingController(
      text: plant.frequency,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Plant'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Plant Name'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Plant Type'),
              ),
              TextField(
                controller: frequencyController,
                decoration: InputDecoration(labelText: 'Watering Frequency'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                final updatedPlant = PlantModel(
                  id: plant.id,
                  name: nameController.text,
                  plant: typeController.text,
                  frequency: frequencyController.text,
                  status: plant.status,
                  userId: plant.userId,
                );

                // Call update in DB
                await DbHelper.updatePlant(updatedPlant);
                Navigator.pop(context);
                loadData(); // Refresh the list
              },
            ),
          ],
        );
      },
    );
  }

  // Delete plant and reload
  Future<void> deletePlant(int id) async {
    await DbHelper.deletePlant(id);
    loadData(); // Refresh after delete
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              dataUser == null
                  ? CircularProgressIndicator()
                  : Text(
                      'Hello, ${dataUser?.username ?? ""}!',
                      style: TextStyle(fontSize: 20, color: Color(0xff777C6D)),
                    ),
              SizedBox(height: 10),
              Text(
                'How is your green friends today?',
                style: TextStyle(fontSize: 18, color: Color(0xff819067)),
              ),
              SizedBox(height: 25),
              Text(
                'Your plant(s)',
                style: TextStyle(fontSize: 16, color: Color(0xff819067)),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  // List of plants
                  child: userPlants == null || userPlants!.isEmpty
                      ? Center(child: Text('No plants added yet!'))
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: userPlants?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final data = userPlants![index];
                            return ListTile(
                              title: Text(
                                data.name,
                                style: TextStyle(fontSize: 18, color: Color(0xff748873)),
                                '${data.name}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff748873),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data.plant, style: TextStyle(color: Color(0xff748873)),),
                                  Text('Water: ${data.frequency}', style: TextStyle(color: Color(0xff748873)),),
                                  Text(
                                    '${data.plant}',
                                    style: TextStyle(color: Color(0xff748873)),
                                  ),
                                  Text(
                                    'Water: ${data.frequency}',
                                    style: TextStyle(color: Color(0xff748873)),
                                  ),
                                  LinearProgressIndicator(
                                    borderRadius: BorderRadius.circular(11),
                                    backgroundColor: Color(0x80A6AD88),
                                  ),
                                ],
                              ),
                              // Add edit and delete actions
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, size: 18),
                                    color: Color(0xff758A93),
                                    onPressed: () => showUpdateDialog(data),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, size: 18),
                                    color: Color(0xff758A93),
                                    onPressed: () => deletePlant(data.id!),
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
