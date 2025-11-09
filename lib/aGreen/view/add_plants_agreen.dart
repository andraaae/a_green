import 'package:a_green/aGreen/database/db_helper.dart';
import 'package:a_green/aGreen/database/preferrence.dart';
import 'package:a_green/aGreen/models/plant_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

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
  DateTime? selectedDate;

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
    "1-2 weeks",
    "Every 2-3 days",
    "Every 3-4 days",
    "Every 2 days",
    "Every day",
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
                const SizedBox(height: 15),
                const Text(
                  "Fill in the details of your new plant",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xff96A78D)),
                ),
                const SizedBox(height: 20),

                /// PLANT NAME
                _buildLabel("Plant's Name"),
                _buildTextField(
                  controller: plantname,
                  hintText: "ex. Peace Lily",
                ),

                /// TYPE OF PLANT
                const SizedBox(height: 30),
                _buildLabel("Type of Plant"),
                _buildDropdown(
                  hint: 'Choose your plant type',
                  items: typeitems,
                  value: dropDownType,
                  onChanged: (value) => setState(() => dropDownType = value),
                ),

                /// FREQUENCY
                const SizedBox(height: 30),
                _buildLabel("Watering Frequency"),
                _buildDropdown(
                  hint: 'Choose watering frequency',
                  items: frequencyitem,
                  value: dropDownFrequency,
                  onChanged: (value) =>
                      setState(() => dropDownFrequency = value),
                ),

                /// LAST WATERED DATE
                const SizedBox(height: 30),
                _buildLabel("Last Watered Date"),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selectedDate == null
                          ? 'Select date'
                          : DateFormat('dd MMMM yyyy').format(selectedDate!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedDate == null
                            ? Colors.grey.shade600
                            : const Color(0xff55695A),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                /// SAVE BUTTON
                ElevatedButton(
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    if (selectedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select last watered date!')),
                      );
                      return;
                    }

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
                      lastWateredDate: selectedDate!.toIso8601String(),
                    );

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

  /// Helper widgets biar rapi
  Widget _buildLabel(String text) => Row(
        children: [
          Text(
            text,
            style: const TextStyle(color: Color(0xff55695A)),
          ),
        ],
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 7),
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          validator: (value) =>
              value == null || value.isEmpty ? "Required" : null,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xff55695A)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
  }) =>
      Padding(
        padding: const EdgeInsets.only(top: 7),
        child: DropdownButtonFormField2<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          hint: Center(
            child: Text(
              hint,
              style: const TextStyle(fontSize: 12, color: Color(0xff55695A)),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 2,
            offset: const Offset(0, -5),
          ),
          validator: (val) => val == null ? "Select one" : null,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              alignment: Alignment.center,
              child: Text(item, textAlign: TextAlign.center),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      );
}
