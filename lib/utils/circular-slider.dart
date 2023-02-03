// import 'dart:math';
//
// import 'package:flutter/material.dart';
//
// class CircularSlider extends StatefulWidget {
//   final double width;
//   final double height;
//   final ValueChanged<double> onChanged;
//
//   CircularSlider({
//     Key? key,
//     this.width = 100,
//     this.height = 100,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   _CircularSliderState createState() => _CircularSliderState();
// }
//
// class _CircularSliderState extends State<CircularSlider> {
//   double _value = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width,
//       height: widget.height,
//       child: GestureDetector(
//         onPanUpdate: (details) {
//           RenderBox renderBox = context.findRenderObject();
//           var position = renderBox.globalToLocal(details.globalPosition);
//           var angle = atan2(position.dy, position.dx);
//           var value = (angle + pi) / (2 * pi);
//           setState(() {
//             _value = value;
//             widget.onChanged(_value);
//           });
//         },
//         child: CustomPaint(
//           painter: CircularSliderPainter(value: _value),
//         ),
//       ),
//     );
//   }
// }
//
// class CircularSliderPainter extends CustomPainter {
//   final double value;
//
//   CircularSliderPainter({
//     this.value = 0,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     var center = Offset(size.width / 2, size.height / 2);
//     var radius = min(size.width, size.height) / 2;
//     var rect = Rect.fromCircle(center: center, radius: radius);
//     var startAngle = -pi / 2;
//     var sweepAngle = value * 2 * pi;
//     var paint = Paint()
//       ..color = Colors.blue
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 8;
//     canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
