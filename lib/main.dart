import 'package:finance_app/add_order.dart';
import 'package:finance_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: background, // set your desired color here
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: background,
        systemNavigationBarIconBrightness: Brightness.dark),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: 'Home Page',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int orders = 0;
  int sales = 0;
  int profit = 0;
  int cost = 0;
  int monthlySales = 0;
  int remaining = 0;
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addOrder(
                  deviceWidth: deviceWidth,
                ),
              ),
            );
          },
          backgroundColor: primaryBoxColorOne,
          child: const Icon(
            Icons.add_rounded,
            color: textColorWhite,
            size: 30,
          ),
        ),
        backgroundColor: background,
        body: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            width: deviceWidth * 0.96,
            height: 50,
            decoration: BoxDecoration(
                color: primaryBoxColorOne,
                borderRadius: BorderRadius.circular(5)),
            child: const Center(
              child: Text(
                'Statistics',
                style: TextStyle(
                    color: textColorGreenDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: deviceWidth * 0.31,
                height: 90,
                decoration: BoxDecoration(
                    color: primaryBoxColorOne,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Orders',
                        style: TextStyle(
                            color: textColorGreenDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        '100',
                        style: TextStyle(
                            color: textColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: deviceWidth * 0.31,
                height: 90,
                decoration: BoxDecoration(
                    color: primaryBoxColorOne,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Sales',
                        style: TextStyle(
                            color: textColorGreenDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        '100',
                        style: TextStyle(
                            color: textColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: deviceWidth * 0.31,
                height: 90,
                decoration: BoxDecoration(
                    color: primaryBoxColorOne,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Profit',
                        style: TextStyle(
                            color: textColorGreenDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        '100',
                        style: TextStyle(
                            color: textColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: deviceWidth * 0.31,
                height: 90,
                decoration: BoxDecoration(
                    color: primaryBoxColorOne,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Monthly',
                        style: TextStyle(
                            color: textColorGreenDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        '100',
                        style: TextStyle(
                            color: textColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: deviceWidth * 0.31,
                height: 90,
                decoration: BoxDecoration(
                    color: primaryBoxColorOne,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Cost',
                        style: TextStyle(
                            color: textColorGreenDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        '100',
                        style: TextStyle(
                            color: textColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: deviceWidth * 0.31,
                height: 90,
                decoration: BoxDecoration(
                    color: primaryBoxColorOne,
                    borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Remaining',
                        style: TextStyle(
                            color: textColorGreenDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: Text(
                        '100',
                        style: TextStyle(
                            color: textColorWhite,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Container(
          //   width: deviceWidth * 0.96,
          //   height: 50,
          //   decoration: BoxDecoration(
          //       color: primaryBoxColorOne,
          //       borderRadius: BorderRadius.circular(5)),
          //   child: const Center(
          //     child: Text(
          //       'Orders',
          //       style: TextStyle(
          //           color: textColorGreenDark,
          //           fontSize: 18,
          //           fontWeight: FontWeight.w500),
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: deviceWidth * 0.96,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                      color: primaryBoxColorTwo,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryBoxColorTwo)),
                  child: const Center(
                      child: Text(
                    'All',
                    style: TextStyle(color: textColorBlack),
                  )),
                ),
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      color: primaryBoxColorThree,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryBoxColorTwo)),
                  child: const Center(
                      child: Text(
                    'To Deliver',
                    style: TextStyle(color: textColorBlack),
                  )),
                ),
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      color: primaryBoxColorThree,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryBoxColorTwo)),
                  child: const Center(
                      child: Text(
                    'Completed',
                    style: TextStyle(color: textColorBlack),
                  )),
                ),
                Container(
                  width: 85,
                  height: 30,
                  decoration: BoxDecoration(
                      color: primaryBoxColorThree,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: primaryBoxColorTwo)),
                  child: const Center(
                      child: Text(
                    'Canceled',
                    style: TextStyle(color: textColorBlack),
                  )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: deviceWidth * 0.96,
            height: 90,
            decoration: BoxDecoration(
              color: primaryBoxColorTwo,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: SizedBox(
                    width: deviceWidth * 0.35,
                    child: Text(
                      '1 pound chocolate cake',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.righteous(
                        color: textColorBlackLight,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              'Dec 20 2024 7 pm',
                              style: GoogleFonts.righteous(
                                  color: textColorBlackFaint, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '1x',
                            style: GoogleFonts.righteous(
                              color: textColorBlackLight,
                            ),
                          ),
                          Text(
                            'Completed',
                            style: GoogleFonts.righteous(
                              color: textColorBlackLight,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rs.1000',
                                style: GoogleFonts.righteous(
                                  color: textColorBlackLight,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Paid',
                                style: GoogleFonts.righteous(
                                  color: textColorBlackFaint,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
