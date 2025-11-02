import 'package:a_green/aGreen/models/user_model.dart';
import 'package:a_green/aGreen/view/add_plants_agreen.dart';
import 'package:a_green/aGreen/view/home_page_agreen.dart';
import 'package:a_green/aGreen/view/journal_page_agreen.dart';
import 'package:a_green/aGreen/view/profile_agreen.dart';
import 'package:a_green/aGreen/view/reminder_agreen.dart';
import 'package:flutter/material.dart';

class ButtomNavigationAgreen extends StatefulWidget {
  final String user;
  const ButtomNavigationAgreen({super.key, required this.user});
  
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
      HomePageAgreen(user: widget.user),
      ReminderAgreen(),
      const SizedBox(), // kosong untuk posisi tombol add
      JournalPageAgreen(),
      ProfileAgreen(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: _pages[_selectedIndex],
          floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffA8D69F),
          shape: const CircleBorder(),
          elevation: 4,
          onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlantsAgreen(user: widget.user)),
            );
        },
        child: const Icon(Icons.add, size: 30),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
     bottomNavigationBar: BottomAppBar(
        height: 70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            navigationItem(Icons.home_outlined, "Home", 0),
            navigationItem(Icons.watch_later, "Reminder", 1),
            const SizedBox(width: 40), // ruang buat FAB
            navigationItem(Icons.menu_book_rounded, "Journal", 3),
            navigationItem(Icons.person_outline, "Profile", 4),
          ],
        ),
     )
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
          Icon(
            icon,
            color: isActive ? Color(0xffA8D69F) : Colors.grey,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Color(0xffA8D69F) : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}