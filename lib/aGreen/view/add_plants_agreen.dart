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
    "Orchid",
    "Jasmine",
    "Rose",
    "frangipani",
    "Bougenville",
    "Hibiscus",
    "Lotus",
    "Carnation",
    "Amarilis",
    "Flamingo Flower",
    "Mini Cactus",
    "Aloe Vera",
    "Echeveria",
    "Haworthia",
    "Crassula ovata",
    "Lithops",
    "Golden Pothos",
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                Text(
                  'Add New Plants',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xff658C58),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Fill in the details of your new plant",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.grey[300] : const Color(0xff96A78D),
                  ),
                ),
                const SizedBox(height: 20),

                //PLANT NAME
                _buildLabel("Plant's Name", isDark),
                _buildTextField(
                  controller: plantname,
                  hintText: "ex. Peace Lily",
                  theme: theme,
                ),

                //TYPE OF PLANT
                const SizedBox(height: 30),
                _buildLabel("Type of Plant", isDark),
                _buildDropdown(
                  hint: 'Choose your plant type',
                  items: typeitems,
                  value: dropDownType,
                  onChanged: (value) => setState(() => dropDownType = value),
                  theme: theme,
                ),

                //FREQUENCY
                const SizedBox(height: 30),
                _buildLabel("Watering Frequency", isDark),
                _buildDropdown(
                  hint: 'Choose watering frequency',
                  items: frequencyitem,
                  value: dropDownFrequency,
                  onChanged: (value) =>
                      setState(() => dropDownFrequency = value),
                  theme: theme,
                ),

                //LAST WATERED DATE
                const SizedBox(height: 30),
                _buildLabel("Last Watered Date", isDark),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 14),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade400,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      selectedDate == null
                          ? 'Select date'
                          : DateFormat('dd MMMM yyyy').format(selectedDate!),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedDate == null
                            ? (isDark
                                ? Colors.grey[400]
                                : Colors.grey.shade600)
                            : theme.colorScheme.onSurface,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 45),

                //SAVE BUTTON
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
                      debugPrint("User ID not found, please login again");
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
                    backgroundColor: isDark
                        ? theme.colorScheme.primary
                        : const Color(0xff658C58),
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

  Widget _buildLabel(String text, bool isDark) => Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isDark ? Colors.grey[200] : const Color(0xff55695A),
            ),
          ),
        ],
      );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required ThemeData theme,
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
            hintStyle: TextStyle(
              fontSize: 12,
              color: theme.hintColor,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            filled: true,
            fillColor: theme.cardColor,
          ),
        ),
      );

  Widget _buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    required ThemeData theme,
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
            fillColor: theme.cardColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
          hint: Center(
            child: Text(
              hint,
              style: TextStyle(
                fontSize: 12,
                color: theme.hintColor,
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.cardColor,
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
