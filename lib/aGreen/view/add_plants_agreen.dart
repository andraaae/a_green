import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:flutter/material.dart';

class AddPlantsAgreen extends StatefulWidget {
  const AddPlantsAgreen({super.key});

  @override
  State<AddPlantsAgreen> createState() => _AddPlantsAgreenState();
}

class _AddPlantsAgreenState extends State<AddPlantsAgreen> {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Add New Plants',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: Color(0xffA3CFA2),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Fill in the details of your new plant",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff96A78D)),
                ),
                SizedBox(height: 20),

                /// PLANT NAME
                Row(
                  children: [
                    Text(
                      "Plants name",
                      style: TextStyle(color: Color(0xff55695A)),
                    ),
                  ],
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller: plantname,
                  validator: (value) =>
                      value == null || value.isEmpty ? "Required" : null,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: "ex. Peace Lily",
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

                /// TYPE OF PLANT
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
                  hint: Text(
                    'choose your plant type',
                    style: TextStyle(fontSize: 12),
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null ? "Select one" : null,
                  items: typeitems.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) => dropDownType = value,
                ),

                /// FREQUENCY
                SizedBox(height: 30),
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
                  hint: Text('2-3 hari sekali', style: TextStyle(fontSize: 12)),
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) => value == null ? "Select one" : null,
                  items: frequencyitem.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (value) => dropDownFrequency = value,
                ),

                SizedBox(height: 45),

                /// SAVE BUTTON
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;

                    final int? userId = await PreferenceHandler.getId();
                    if (userId == null) {
                      print("User ID not found, please login again");
                      return;
                    }

                    final PlantModel data = PlantModel(
                      userId: userId,
                      name: plantname.text.trim(),
                      plant: dropDownType!,
                      frequency: dropDownFrequency!,
                      status: "Active",
                    );

                    print("DEBUG INSERT: ${data.toMap()}");

                    await DbHelper.addPlant(data);

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffB3E2A7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
