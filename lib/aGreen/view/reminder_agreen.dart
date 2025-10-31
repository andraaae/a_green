import 'package:flutter/material.dart';

class ReminderAgreen extends StatefulWidget {
  const ReminderAgreen({super.key});

  @override
  State<ReminderAgreen> createState() => _ReminderAgreenState();
}

class _ReminderAgreenState extends State<ReminderAgreen> {
  bool isActive = false;
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Don't forget to water your plants",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
          //     Center(
          //       child: Container(
          //         padding: EdgeInsets.all(8),
          //         width: double.infinity,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(15),
          //         ),
          //         child: Container(
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Icon(Icons.notifications),
          //             Text('Automatic Notification'),
          //             SizedBox(height: 5),
          //             Text('Active', style: TextStyle(fontSize: 12,
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
    
          //   Container(
          //     child: Switch(value: isActive, onChanged: (value) {
          //     setState(() {
          //       isActive = value;
          //     });
          //     }
          //     ),
          //   )
          Container( width: double.infinity,height: 50,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Kiri: ikon + teks
                  Row(
                    children: [
            Icon(Icons.notifications_none, color: Colors.green),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifikasi Otomatis',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Aktif',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ), 
            SizedBox(width: 100),
            Switch(value: isActive, onChanged: (value){
              setState(() {
                isActive = value;
              });
            })
                    ],
                    ),
                    ],
                    ),
          ), 
          SizedBox(height: 40),
          Text('Upcoming Schedule', style: TextStyle(fontSize: 15),)
        ],
        ),
        ),
      ),
    );  
  }
}
