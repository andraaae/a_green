// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// import 'package:a_green/aGreen/database/db_helper.dart';
// import 'package:a_green/aGreen/models/user_model.dart';
// import 'package:a_green/aGreen/view/login_agreen.dart';

// class CRWidgetDay19 extends StatefulWidget {
//   const CRWidgetDay19({super.key});

//   @override
//   State<CRWidgetDay19> createState() => _CRWidgetDay19State();
// }

// class _CRWidgetDay19State extends State<CRWidgetDay19> {
//   final usernameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   getData() {
//     DbHelper.getAllUser();
//     setState(() {});
//   }

//   Future<void> _onEdit(UserModel student) async {
//     final editusernameC = TextEditingController(text: student.email);
//     final editPasswordC= TextEditingController(text: student.password.toString());
//     final editPhoneC = TextEditingController(text: student.phone);
//     final editEmailC = TextEditingController(text: student.email);
//     final res = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Edit Data"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             spacing: 12,
//             children: [
//               buildTextField(hintText: "Name", controller: editusernameC),
//               buildTextField(hintText: "Email", controller: editEmailC),
//               buildTextField(hintText: "Password", controller: editPasswordC),
//               buildTextField(hintText: "Phone", controller: editPhoneC),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Batal"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: Text("Simpan"),
//             ),
//           ],
//         );
//       },
//     );

//     if (res == true) {
//       final updated = UserModel(
//         id: student.id,
//         username: editusernameC.text,
//         email: editEmailC.text,
//         password: editPasswordC.text,
//         phone: (editPhoneC.text),
//       );
//       DbHelper.updateUser(updated);
//       getData();
//       Fluttertoast.showToast(msg: "Data berhasil di update");
//     }
//   }

//   Future<void> _onDelete(UserModel user) async {
//     final res = await showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text("Hapus Data"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             spacing: 12,
//             children: [
//               Text(
//                 "Apakah anda yakin ingin menghapus data ${user.username}?",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text("Jangan"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: Text("Ya, hapus aja"),
//             ),
//           ],
//         );
//       },
//     );

//     if (res == true) {
//       DbHelper.deleteUser(user.id!);
//       getData();
//       Fluttertoast.showToast(msg: "Data berhasil di hapus");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           spacing: 12,
//           children: [
//             Text("Pendaftaran Siswa", style: TextStyle(fontSize: 24)),
//             buildTextField(hintText: "Username", controller: usernameController),
//             buildTextField(hintText: "Phone", controller: phoneController),
//             buildTextField(hintText: "Password", controller: passwordController),
//             buildTextField(hintText: "Email", controller: emailController),
//             LoginAgreen(
//               text: "Tambahkan",
//               onPressed: () {
//                 if (usernameController.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Nama belum diisi");
//                 } else if (emailController.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Email belum diisi");
//                 } else if (passwordController.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Class belum diisi");
//                 } else if (phoneController.text.isEmpty) {
//                   Fluttertoast.showToast(msg: "Age belum diisi");
//                 } else {
//                   final UserModel dataStudent = UserModel(
//                     username: usernameController.text,
//                     email: emailController.text,
//                     classs: classC.text,
//                     age: int.parse(ageC.text),
//                   );
//                   DbHelper.createStudent(dataStudent).then((value) {
//                     emailC.clear();
//                     ageC.clear();
//                     classC.clear();
//                     nameC.clear();
//                     getData();
//                     Fluttertoast.showToast(msg: "Data berhasil ditambahkan");
//                   });
//                 }
//               },
//             ),
//             SizedBox(height: 30),
//             FutureBuilder(
//               future: DbHelper.getAllStudent(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else if (snapshot.data == null || snapshot.data.isEmpty) {
//                   return Column(
//                     children: [
//                       Image.asset(AppImages.empty, height: 150),

//                       Text("Data belum ada"),
//                     ],
//                   );
//                 } else {
//                   final data = snapshot.data as List<StudentModel>;
//                   return Expanded(
//                     child: ListView.builder(
//                       itemCount: data.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         final items = data[index];
//                         return Column(
//                           children: [
//                             ListTile(
//                               title: Text(items.name),
//                               subtitle: Text(items.email),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       _onEdit(items);
//                                     },
//                                     icon: Icon(Icons.edit),
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       _onDelete(items);
//                                     },
//                                     icon: Icon(Icons.delete, color: Colors.red),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   TextFormField buildTextField({
//     String? hintText,
//     bool isPassword = false,
//     TextEditingController? controller,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       validator: validator,
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32),
//           borderSide: BorderSide(
//             color: Colors.black.withOpacity(0.2),
//             width: 1.0,
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32),
//           borderSide: BorderSide(color: Colors.black, width: 1.0),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(32),
//           borderSide: BorderSide(
//             color: Colors.black.withOpacity(0.2),
//             width: 1.0,
//           ),
//         ),
//       ),
//     );
//   }
// }