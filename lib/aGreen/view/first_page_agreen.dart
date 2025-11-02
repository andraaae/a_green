import 'package:a_green/aGreen/bottom_navigation/buttom_navigation_agreen.dart';
import 'package:a_green/aGreen/view/home_page_agreen.dart';
import 'package:flutter/material.dart';
import 'package:a_green/aGreen/models/user_model.dart';
class FirstPageAgreen extends StatefulWidget {
  final UserModel user;
  const FirstPageAgreen({super.key, required this.user});
  
  @override
  State<FirstPageAgreen> createState() => _FirstPageAgreenState();
}

class _FirstPageAgreenState extends State<FirstPageAgreen> {
  final formKey = GlobalKey<FormState>();
  final plantname = TextEditingController();
  String? dropDownType;
  String? dropDownFrequency;
  final List<String> typeitems = [
    "Monstera",
    "Calathea",
    "Aglaonema",
    "Philodendron",
    "Alocasia",
    "Begonia Rex",
    "Coleus",
    "Dieffenbachia",
    "Pilea Peperomioides",
    "Anggrek",
    "Melati",
    "Mawar",
    "Kamboja",
    "Bougenville",
    "Hibiscus",
    "Teratai",
    "Anyelir",
    "Amarilis",
    "Flamingo Flower",
    "Kaktus mini",
    "Aloe Vera",
    "Echeveria",
    "Haworthia",
    "Crassula ovata",
    "Lithops",
    "Sirih Gading",
    "English Ivy",
    "Dischidia",
    "Spider Plant",
    "Petunia",
    "Tradescantia",
    "String of Pearls",
    "Ficus lyrata",
    "Pachira Aquatica",
    "Dracaena",
    "Sansevieria",
    "Ficus elastica",
    "Areca Palm",
    "Bonsai",
    "Syngonium podophyllum",
    "Maranta leuconeura",
    "Ctenanthe burle-marxii",
    "Fittonia",
    "Peperomia obtusifolia",
    "Stromanthe triostar",
    "Caladium",
    "Tradescantia zebrina",
    "Epipremnum aureum",
    "Xanthosoma",
    "Geranium",
    "Vinca",
    "Lantana camara",
    "Zinnia",
    "Celosia",
    "Impatiens",
    "Adenium",
    "Morning Glory",
    "Salvia",
    "Portulaca grandiflora",
    "Sedum morganianum",
    "Graptopetalum paraguayense",
    "Ariocarpus",
    "Gymnocalycium mihanovichii",
    "Notocactus",
    "Rebutia",
    "Mammillaria",
    "String of Hearts",
    "String of Bananas",
    "Fuchsia",
    "Hoya carnosa",
    "Parlor Palm",
    "Croton",
    "Hydrocotyle verticillata",
  ];
  final List<String> frequencyitem = [
    "1-2 minggu",
    "2-3 hari sekali",
    "3-4 hari sekali",
    "2 hari sekali",
    "setiap hari",
  ];
  bool isButtonEnable = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCBF3BB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      'Add your first plant(s)',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffA3CFA2),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Let's get to know your green friends and start taking care of it.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Color(0xff96A78D)),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "Nama Tanaman",
                        style: TextStyle(color: Color(0xff55695A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  TextFormField(
                    controller: plantname,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "ex. Pisi de Lily",
                      hintStyle: TextStyle(
                        fontSize: 12,
                        color: Color(0xff55695A),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),

                  //type
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        "Type of plant",
                        style: TextStyle(color: Color(0xff55695A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    initialValue: dropDownType,
                    hint: Text(
                      'choose your plants type',
                      style: TextStyle(fontSize: 12, color: Color(0xff55695A)),
                    ),
                    items: typeitems.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,

                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownType = value;
                      });
                      print(dropDownType);
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropDownType != null ? Text(dropDownType!) : SizedBox(),
                    ],
                  ),

                  //frequency
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        "Watering Frequency",
                        style: TextStyle(color: Color(0xff55695A)),
                      ),
                    ],
                  ),
                  SizedBox(height: 7),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    initialValue: dropDownFrequency,
                    hint: Text(
                      '2 hari sekali',
                      style: TextStyle(fontSize: 12, color: Color(0xff55695A)),
                    ),
                    items: frequencyitem.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,

                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropDownFrequency = value;
                      });
                      print(dropDownFrequency);
                    },
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      dropDownFrequency != null
                          ? Text(dropDownFrequency!)
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(height: 45),
                  SizedBox(width: double.infinity),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePageAgreen(user: widget.user)
                      )
                      );
                    },
                    icon: SizedBox(),
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Start caring',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Icon(Icons.arrow_forward),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnable
                          ? const Color(0xffB3E2A7)
                          : Color(0xffB3E2A7),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 120,
                        vertical: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () {
                      print('Skip for now');
                    },
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff55695A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
