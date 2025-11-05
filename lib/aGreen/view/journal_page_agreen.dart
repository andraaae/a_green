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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xffCBF3BB),
      body: Padding(
        padding: EdgeInsets.all(35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Journal",
              style: TextStyle(
                fontSize: 30,
                color: Color(0xff658C58),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Record your green friend's journey",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 100,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userPlants?.length.toString() ?? "0",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text('Plants total', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Row(
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text('Timeline', style: TextStyle(fontSize: 18),
            //         ),
            //         ElevatedButton(
            //           onPressed: (){} ,
            //           style: ElevatedButton.styleFrom(
            //             backgroundColor: Colors.transparent,
            //             shadowColor: Colors.transparent,
            //             side: BorderSide(color: Color(0xffA0C878)),
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadiusGeometry.circular(12),
            //             ),
            //           ),
            //            child: Text('Add', style: TextStyle(
            //             fontSize: 12,
            //         ),
            //         )
            //         )
            //       ],
            //     ),
            //   ],
            // ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('Timeline', style: TextStyle(fontSize: 15))],
              ),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      // child: Image.asset(
                      //   'assets/images/aloe_vera (2).jpg',
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
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
          ],
        ),
      ),
    );
  }
}
