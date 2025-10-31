import 'package:a_green/aGreen/models/user_model.dart';
import 'package:flutter/material.dart';

class HomePageAgreen extends StatefulWidget {
  //final UserModel user;
  //const HomePageAgreen({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePageAgreen> createState() => _HomePageAgreenState();
}

class _HomePageAgreenState extends State<HomePageAgreen> {
  int _selectedIndex = 0;
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
              SizedBox(height: 12),
              Text('Hello,  !', style: TextStyle(fontSize: 15)),
              Text(
                'How is your green friends today?',
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 20),
              Text('Your plant(s)', style: TextStyle(fontSize: 14)),
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
                            Text(
                              "61% humidity",
                              style: TextStyle(fontSize: 10),
                            ),
                            LinearProgressIndicator(
                              borderRadius: BorderRadius.circular(11),
                              value: 0.6,
                              backgroundColor: Color(0x80A6AD88),
                            ),
                            Text(
                              "Day 0 has not been watered",
                              style: TextStyle(fontSize: 11),
                            ),
                          ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF9ACDA3),
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          print(index);
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, color: Color(0xFF9ACDA3)),
            label: 'home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time, color: Color(0xFF9ACDA3)),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded, color: Color(0xFF9ACDA3)),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Color(0xFF9ACDA3)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
