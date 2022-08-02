import 'dart:math' as math;

import 'package:flutter/material.dart';

class BodyWidget extends StatefulWidget {
  @override
  _BodyWidgetState createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator BodyWidget - GROUP

    return Container(
        width: 306.00164794921875,
        height: 357,
        child: Stack(children: <Widget>[
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                  width: 305,
                  height: 357,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15000000596046448),
                          offset: Offset(0, 2),
                          blurRadius: 6)
                    ],
                    color: Color.fromRGBO(255, 251, 255, 1),
                  ))),
          Positioned(
              top: 12,
              left: 20,
              child: Text(
                'Inquiry',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(56, 30, 114, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 24,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 15,
              left: 108,
              child: Text(
                '1',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(56, 30, 114, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 24,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(top: 16, left: 251, child: SizedBox()),
          Positioned(
              top: 20.5,
              left: 283,
              child: Container(
                  width: 17,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(120, 234, 51, 1),
                    borderRadius: BorderRadius.all(Radius.elliptical(17, 15)),
                  ))),
          Positioned(
              top: 51,
              left: 1,
              child: Transform.rotate(
                angle: 2.4848083448933725e-17 * (math.pi / 180),
                child: Divider(color: Color.fromRGBO(0, 0, 0, 1), thickness: 1),
              )),
          Positioned(
              top: 67,
              left: 20,
              child: Text(
                'Description',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(98, 91, 113, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 113,
              left: 20,
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(98, 91, 113, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 230,
              left: 227,
              child: Text(
                'Laptop',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(98, 91, 113, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 230,
              left: 22,
              child: Text(
                'IT',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(98, 91, 113, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(top: 278, left: 20, child: SizedBox()),
          Positioned(
              top: 279,
              left: 52,
              child: Text(
                'Max Mustermann',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(28, 27, 30, 1),
                    fontFamily: 'Work Sans',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(top: 326, left: 11, child: SizedBox()),
          Positioned(top: 326, left: 179, child: SizedBox()),
          Positioned(
              top: 327,
              left: 39,
              child: Text(
                '10.09.2022',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.normal,
                    height: 1.4285714285714286),
              )),
          Positioned(
              top: 327,
              left: 204,
              child: Text(
                '10.11.2022',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.normal,
                    height: 1.4285714285714286),
              )),
        ]));
  }
}
