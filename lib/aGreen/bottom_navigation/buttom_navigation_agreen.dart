import 'package:a_green/aGreen/view/add_plants_firebase.dart';
import 'package:a_green/aGreen/view/home_page_firebase.dart';
import 'package:a_green/aGreen/view/journal_firebase.dart';
import 'package:a_green/aGreen/view/profile_firebase.dart';
import 'package:a_green/aGreen/view/reminder_firebase.dart';
import 'package:flutter/material.dart';

class ButtomNavigationAgreen extends StatefulWidget {
  const ButtomNavigationAgreen({super.key});

  @override
  State<ButtomNavigationAgreen> createState() => _ButtomNavigationAgreenState();
}

class _ButtomNavigationAgreenState extends State<ButtomNavigationAgreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  @override
  void initState() {
    super.initState();
    _pages = [
      HomePageFirebase(),
      ReminderFirebase(),
      const SizedBox(), // kosong untuk posisi tombol add
      JournalFirebase(),
      ProfileFirebase(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
  children: [
    Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        height: 70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navigationItem(Icons.home_outlined, "Home", 0),
            navigationItem(Icons.watch_later, "Reminder", 1),
            const SizedBox(width: 40), // UNTUK FAB
            navigationItem(Icons.menu_book_rounded, "Journal", 3),
            navigationItem(Icons.person_outline, "Profile", 4),
          ],
        ),
      ),
    ),

    Positioned(
      bottom: 45,
      left: 0,
      right: 0,
      child: Center(
          child: FloatingActionButton(
            backgroundColor: const Color(0xffA8D69F),
            shape: const CircleBorder(),
            elevation: 4,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddPlantsFirebase()),
              );
            },
            child: const Icon(Icons.add, size: 30),
          ),
        ),
      ),
    
  ],
);
}

  Widget navigationItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Color(0xffA8D69F) : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Color(0xffA8D69F) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
