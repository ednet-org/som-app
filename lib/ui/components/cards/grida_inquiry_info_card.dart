import 'package:flutter/material.dart';

class GridaInquiryInfoCard extends StatelessWidget {
  const GridaInquiryInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
          body: Container(
            padding: const EdgeInsets.symmetric(),
            decoration: const BoxDecoration(),
            child: Column(
              key: const Key(
                "InquiryInfoCard (630:5704)",
              ),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              verticalDirection: VerticalDirection.down,
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  child: Container(
                    key: const Key(
                      "container for nested stack of 629:5764",
                    ),
                    child: Stack(
                      key: const Key(
                        "body (629:5764)",
                      ),
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          right: 1,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(
                                0xffffeedd,
                              ),
                              borderRadius: BorderRadius.circular(
                                12,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(
                                    0x26000000,
                                  ),
                                  offset: Offset(
                                    0,
                                    2,
                                  ),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: Color(
                                    0x4c000000,
                                  ),
                                  offset: Offset(
                                    0,
                                    1,
                                  ),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Container(
                              key: const Key(
                                "container (629:5765)",
                              ),
                              width: 305,
                              height: 357,
                              decoration: const BoxDecoration(
                                color: Color(
                                  0xffffeedd,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0x26000000,
                                    ),
                                    offset: Offset(
                                      0,
                                      2,
                                    ),
                                    blurRadius: 6,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: Color(
                                      0x4c000000,
                                    ),
                                    offset: Offset(
                                      0,
                                      1,
                                    ),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          top: 12,
                          right: 180,
                          bottom: 317,
                          child: SizedBox(
                            width: 106,
                            child: Text(
                              "Inquiry",
                              key: Key(
                                "header_title (629:5766)",
                              ),
                              style: TextStyle(
                                color: Color(
                                  0xff001c38,
                                ),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Work Sans",
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 108,
                          top: 12,
                          right: 162,
                          bottom: 317,
                          child: SizedBox(
                            width: 36,
                            child: Text(
                              "1",
                              key: Key(
                                "id (629:5767)",
                              ),
                              style: TextStyle(
                                color: Color(
                                  0xff001c38,
                                ),
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Work Sans",
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 251,
                          top: 16,
                          right: 31,
                          bottom: 317,
                          child: Image.network(
                            "grida://assets-reservation/images/629:5768",
                            width: 24,
                            height: 24,
                            semanticLabel: "icon",
                            key: const Key(
                              "offers_icon (629:5768)",
                            ),
                          ),
                        ),
                        Positioned(
                          left: 283,
                          top: 20.5,
                          right: 6,
                          bottom: 321.5,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(
                                0xff6adc9d,
                              ),
                            ),
                            child: Container(
                              key: const Key(
                                "status (629:5769)",
                              ),
                              width: 17,
                              height: 15,
                              decoration: const BoxDecoration(
                                color: Color(
                                  0xff6adc9d,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 1,
                          top: 51,
                          right: 0,
                          bottom: 306,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                right: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                bottom: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                                left: BorderSide(
                                  width: 0,
                                  style: BorderStyle.none,
                                ),
                              ),
                            ),
                            child: Container(
                              key: const Key(
                                "header_divider (629:5770)",
                              ),
                              width: 305,
                              height: 0,
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  bottom: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                  left: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          top: 67,
                          right: 196,
                          bottom: 271,
                          child: Text(
                            "Description",
                            key: Key(
                              "description_label (629:5771)",
                            ),
                            style: TextStyle(
                              color: Color(
                                0xff291800,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Work Sans",
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 20,
                          top: 113,
                          right: 10,
                          bottom: 187,
                          child: SizedBox(
                            width: 276,
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
                              key: Key(
                                "description_value (629:5772)",
                              ),
                              style: TextStyle(
                                color: Color(
                                  0xff291800,
                                ),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Work Sans",
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 227,
                          top: 230,
                          right: 23,
                          bottom: 108,
                          child: Text(
                            "Laptop",
                            key: Key(
                              "category_value (629:5773)",
                            ),
                            style: TextStyle(
                              color: Color(
                                0xff291800,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Work Sans",
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 22,
                          top: 230,
                          right: 269,
                          bottom: 108,
                          child: Text(
                            "IT",
                            key: Key(
                              "branch_value (629:5774)",
                            ),
                            style: TextStyle(
                              color: Color(
                                0xff291800,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Work Sans",
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 278,
                          right: 265,
                          bottom: 61,
                          child: Container(
                            padding: const EdgeInsets.symmetric(),
                            decoration: const BoxDecoration(),
                            child: Container(
                              key: const Key(
                                "container for nested stack of 629:5775",
                              ),
                              child: Stack(
                                key: const Key(
                                  "user_icon (629:5775)",
                                ),
                                children: [
                                  Positioned(
                                    left: 3.5,
                                    top: 11.25,
                                    right: 3.5,
                                    bottom: 2.25,
                                    child: Image.network(
                                      "grida://assets-reservation/images/I629:5775;51416:4854",
                                      width: 14,
                                      height: 4.5,
                                      key: const Key(
                                        "Vector (I629:5775;51416:4854)",
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 7,
                                    top: 2.25,
                                    right: 7,
                                    bottom: 9.75,
                                    child: Image.network(
                                      "grida://assets-reservation/images/I629:5775;51416:4855",
                                      width: 7,
                                      height: 6,
                                      key: const Key(
                                        "Vector (I629:5775;51416:4855)",
                                      ),
                                    ),
                                  ),

                                  /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                                  Container(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 52,
                          top: 279,
                          right: 48,
                          bottom: 59,
                          child: Text(
                            "Max Mustermann",
                            key: Key(
                              "user_name (629:5776)",
                            ),
                            style: TextStyle(
                              color: Color(
                                0xff291800,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Work Sans",
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 11,
                          top: 326,
                          right: 277,
                          bottom: 13,
                          child: Image.network(
                            "grida://assets-reservation/images/629:5777",
                            width: 18,
                            height: 18,
                            semanticLabel: "icon",
                            key: const Key(
                              "creationDate_icon (629:5777)",
                            ),
                          ),
                        ),
                        Positioned(
                          left: 179,
                          top: 326,
                          right: 109,
                          bottom: 13,
                          child: Image.network(
                            "grida://assets-reservation/images/629:5778",
                            width: 18,
                            height: 18,
                            semanticLabel: "icon",
                            key: const Key(
                              "deadlinen_icon (629:5778)",
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 39,
                          top: 327,
                          right: 194,
                          bottom: 10,
                          child: Text(
                            "10.09.2022",
                            key: Key(
                              "creationDate_value (629:5779)",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              height: 1.43,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                        const Positioned(
                          left: 204,
                          top: 327,
                          right: 29,
                          bottom: 10,
                          child: Text(
                            "10.11.2022",
                            key: Key(
                              "deadline_value (629:5780)",
                            ),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Roboto",
                              height: 1.43,
                              letterSpacing: 0,
                            ),
                          ),
                        ),

                        /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
                        Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      title: "app built with grida.co",
      theme: ThemeData(
        textTheme: const TextTheme(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
