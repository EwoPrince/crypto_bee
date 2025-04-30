// import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';

// class VibrationButton extends StatefulWidget {
//   @override
//   _VibrationButtonState createState() => _VibrationButtonState();
// }

// class _VibrationButtonState extends State<VibrationButton> {
//   double intensity = 0.0;
//   int duration = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vibration Button'),
//       ),
//       body: Center(
//         child: GestureDetector(
//           onTapDown: (details) {
//             // Start tracking the time when the button is pressed
//             duration = DateTime.now().millisecondsSinceEpoch;
//           },
//           onTapUp: (details) {
//             // Calculate the duration the button was pressed
//             duration = DateTime.now().millisecondsSinceEpoch - duration;
            
//             // Calculate the intensity based on the duration
//             // intensity = details.pressure * duration / 1000;

//             // Vibrate with the calculated intensity
//             Vibration.vibrate(duration: intensity.toInt());
            
//             // Reset intensity and duration for next press
//             intensity = 0.0;
//             duration = 0;
//           },
//           child: Container(
//             width: 200,
//             height: 100,
//             color: Colors.blue,
//             child: Center(
//               child: Text(
//                 'Press Me',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
