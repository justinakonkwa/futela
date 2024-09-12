// import 'package:eventgo/widgets/constantes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// buildTextField(
//   BuildContext context, {
//   required TextEditingController controller,
//   required String placeholder,
//   required bool isNumber,
//   bool obscureText = false,
//   Widget? prefix,
//   Widget? suffix,
//   String? errorText,
//   Function(String)? onChanged, // Ajout de la fonction de rappel onChanged
// }) {
//   return
//   isNumber?
//    SizedBox(
//       height: 50, // Adjusted height to accommodate country picker
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.zero,
//             margin: EdgeInsets.zero,
//             height: 50,
//             decoration: BoxDecoration(border: Border.all(color: Colors.grey,)),
//             child: CountryCodePicker(
//               onChanged: (country) {
//               onChanged;
//               },
//               initialSelection: 'FR', // Default to France, adjust as needed
//               favorite: ['+33', 'FR'],
//               showFlag: false,
//               showCountryOnly: false,
//               alignLeft: false,
//             ),
//
//           ),
//           sizedbox2,
//           Expanded(
//             child: Container(
//               height: 50,
//               child: CupertinoTextField(
//                 controller: controller,
//                 placeholder: 'Entrée votre Numéro',
//                 style: TextStyle(  fontFamily: 'Montserrat', ),
//                 keyboardType: TextInputType.phone,
//                 decoration: BoxDecoration(
//         border: Border.all(
//           color: errorText != null
//               ? Colors.red
//               : Colors.grey
//         ),
//       ),
//                 onChanged:onChanged,
//
//               ),
//             ),
//           ),
//         ],
//       ),
//     ):
//   SizedBox(
//     height: 50,
//     child: CupertinoTextField(
//       controller: controller,
//       placeholder: placeholder,
//       obscureText: obscureText,
//        style: TextStyle(  fontFamily: 'Montserrat', ),
//       prefix: prefix,
//       suffix: suffix,
//       decoration: BoxDecoration(
//         border: Border.all(
//           color: errorText != null
//               ? Colors.red
//               : Colors.grey
//         ),
//       ),
//       onChanged: onChanged, // Utilisation de la fonction de rappel onChanged
//     ),
//   );
//
//
// }
