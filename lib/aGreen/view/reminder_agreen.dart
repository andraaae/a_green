import 'package:flutter/material.dart';

class ReminderAgreen extends StatefulWidget {
  const ReminderAgreen({super.key});

  @override
  State<ReminderAgreen> createState() => _ReminderAgreenState();
}

class _ReminderAgreenState extends State<ReminderAgreen> {
  bool isActive = false;
  bool isOn = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xff658C58)),
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
                      isOn ? Icons.notifications_active : Icons.notifications_off,
                      color: isOn ? Color(0xffABE7B2) : Color(0xffB7B89F),
                    ),
                    SizedBox(width: 12),

                    /// TEXT COLUMN
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Notification',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            isOn ? 'Active' : 'Inactive',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    //switch
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

    //       Container( width: double.infinity,height: 50,
    //         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               //icon + text
    //               Row(
    //                 children: [
    //         Icon(isOn? Icons.notifications_active : Icons.notifications_off, 
    //         color: isOn? Color(0xffABE7B2): Color(0xffB7B89F)), 
    //         SizedBox(width: 10),
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               'Notification',
    //               style: TextStyle(fontWeight: FontWeight.bold),
    //             ),
    //             Text(
    //               'Active',
    //               style: TextStyle(color: Colors.grey, fontSize: 12),
    //             ),
    //           ],
    //         ), 
    //         SizedBox(width: 100),
    //         Switch(value: isActive, onChanged: (value){
    //           setState(() {
    //             isActive = value;
    //             isOn = value;
    //           });
    //         },
    //         inactiveThumbColor: Color(0xffA0C878),
    //         activeTrackColor: Color(0xffCBF3BB),
    //         )
    //       ],
    //      ),
    //     ],
    //   ),
    // ), 
          SizedBox(height: 40),
          Text('Upcoming Schedule', style: TextStyle(fontSize: 15)),
          SizedBox(height: 12),
          Container(
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
                        child: Image.asset(
                          'assets/images/orchid.jpg',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Oci the Orchid",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text("Orchid", style: TextStyle(fontSize: 13)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.alarm),
                                 Text(
                                "2 days left",
                                style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),  
          ),
          
        ),
       
      );  
    }
  }
