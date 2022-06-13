import 'dart:math' as math;

import 'package:ednet_component_library/ednet_component_library.dart';
import 'package:flutter/material.dart';

class InquiryInfoCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 343,
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
                    color: Color.fromRGBO(255, 251, 254, 1),
                  ))),
          Positioned(
              top: 15,
              left: 18,
              child: Text(
                'Inquiry',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: AppColors.shadesecondarySecondary40,
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    letterSpacing: 0.10000000149011612,
                    fontWeight: FontWeight.normal,
                    height: 1.5),
              )),
          Positioned(
              top: 15,
              left: 74,
              child: Text(
                '1',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(28, 27, 31, 1),
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    letterSpacing: 0.10000000149011612,
                    fontWeight: FontWeight.normal,
                    height: 1.5),
              )),
          Positioned(top: 15, left: 248, child: SizedBox()),
          Positioned(
              top: 19.5,
              left: 280,
              child: Container(
                  width: 17,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(101, 230, 22, 1),
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
              top: 63,
              left: 11,
              child: Text(
                'Description',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 111,
              left: 15,
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(202, 196, 208, 1),
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    letterSpacing: 0.25,
                    fontWeight: FontWeight.normal,
                    height: 1.4285714285714286),
              )),
          Positioned(
              top: 232,
              left: 223,
              child: Text(
                'Laptop',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 232,
              left: 18,
              child: Text(
                'IT',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(top: 284, left: 18, child: SizedBox()),
          Positioned(
              top: 285,
              left: 50,
              child: Text(
                'Max Mustermann',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
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
                    fontFamily: 'Inter',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
          Positioned(
              top: 327,
              left: 204,
              child: Text(
                '10.11.2022',
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 1),
                    fontFamily: 'Inter',
                    fontSize: 16,
                    letterSpacing:
                        0 /*percentages not used in flutter. defaulting to zero*/,
                    fontWeight: FontWeight.normal,
                    height: 1),
              )),
        ]));
  }
}
