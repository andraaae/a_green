import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:a_green/aGreen/models/user_model.dart';
import 'package:flutter/material.dart';

class HomePageAgreen extends StatefulWidget {
  @override
  const HomePageAgreen({Key? key}) : super(key: key);

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

  // getData() async {
  //   var id = await PreferenceHandler.getId();
  //   UserModel? result = await DbHelper.getUser(id);
  //   dataUser = result;
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
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
              SizedBox(height: 14),
              Center(
                child: Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        // child: Image.asset(
                        //   'assets/images/orchid.jpg',
                        //   width: 60,
                        //   height: 60,
                        //   fit: BoxFit.cover,
                        // ),
                      ),

                      SizedBox(height: 5),
                      userPlants == null
                          ? CircularProgressIndicator()
                          : Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: userPlants?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = userPlants![index];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data.name}', //sampe sini

                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(height: 10),
                                      Text('${data.plant}'),
                                      SizedBox(height: 10),
                                      Text('${data.frequency}'),
                                      // Text("Orchid", style: TextStyle(fontSize: 13)),
                                      // Text(
                                      //   "61% humidity",
                                      //   style: TextStyle(fontSize: 12),
                                      // ),
                                      LinearProgressIndicator(
                                        borderRadius: BorderRadius.circular(11),
                                        backgroundColor: Color(0x80A6AD88),
                                      ),
                                      // SizedBox(height: 8),
                                      // Text(
                                      //   "Day 0 has not been watered",
                                      //   style: TextStyle(fontSize: 13),
                                      // ),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ],
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
