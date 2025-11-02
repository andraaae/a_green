import 'package:flutter/material.dart';

class JournalPageAgreen extends StatefulWidget {
  const JournalPageAgreen({super.key});

  @override
  State<JournalPageAgreen> createState() => _JournalPageAgreenState();
}

class _JournalPageAgreenState extends State<JournalPageAgreen> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffCBF3BB),
      body: Padding(padding: EdgeInsets.all(35),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Journal", style: TextStyle(fontSize: 30, color: Color(0xff658C58), fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text("Record your green friend's journey", style: TextStyle(fontSize: 14)),
          SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 195,
                height: 130,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('1', style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 30),
                    Text('Plants total', style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
              Container( width: 195,
                height: 130,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                 child: 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('0', style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 30),
                    Text('Watered this week', style: TextStyle(fontSize: 18)),
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
            children: [
              Text('Timeline', style: TextStyle(fontSize: 15),
              ),
              ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                side: BorderSide(color: Color(0xffA0C878)),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6)
              ),
              child:
              Row(
                children: [
                  Icon(Icons.add, color: Color(0xffA0C878),),
                  Text('Add journal', style: TextStyle(fontSize: 12, color: Color(0xffA0C878))),
                ],
              ),
              ),
            ],
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(12),
                        child: Image.asset(
                          'assets/images/aloe_vera (2).jpg',
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
                              "Joel",
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 6),
                            Text("25 November 2026", style: TextStyle(fontSize: 13)),
                            SizedBox(height: 6),
                            Text(
                              "Joel has joined to your family! yippie",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }
}