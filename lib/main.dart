import 'package:finance_app/add_order.dart';
import 'package:finance_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: background, // set your desired color here
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: background,
        systemNavigationBarIconBrightness: Brightness.dark),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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

  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState(); // Call super.initState() first
    listenToFirestore('/appData/live_statistics');
    // Perform other initializations here
  }

  Future<void> addDocumentToFirestore(String collectionPath) async {
    Map<String, dynamic> data = {
      'title': '',
      'name': '',
      'address': '',
      'contact': '',
      'note': '',
      'description': '',
      'date': '',
      'price': '',
      'quantity': '',
      'payment': '',
      'remaining': '',
      'status': '',
      'cost': ''
    };
    try {
      // Add a new document with auto-generated ID
      await FirebaseFirestore.instance.collection(collectionPath).add(data);
      print("Document added successfully!");
    } catch (e) {
      print("Error adding document: $e");
    }
  }

  void listenToFirestore(String collectionPath) {
    FirebaseFirestore.instance
        .doc(collectionPath) // Reference to your document
        .snapshots() // Listen for changes
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        // Access the specific field from the document data
        setState(() {
          orders = snapshot['orders'];
          sales = snapshot['sales'];
          profit = snapshot['profit'];
          monthlySales = snapshot['monthly_sale'];
          cost = snapshot['cost'];
          remaining = snapshot['remaining'];
        });
      }
    });
  }

  void showOrderDetails(double deviceWidth, Map data) {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: modleSheetBackgroundColor,
        context: context,
        builder: (context) {
          return SizedBox(
            height: 700,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 8,
                      decoration: BoxDecoration(
                        color: textColorGreenLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Order Details',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColorBlackLight),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['title'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                      Text(
                        "${data['quantity']}x",
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: deviceWidth * 0.9,
                  height: 1,
                  color: textColorGreenLight,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Price',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorBlackLight),
                      ),
                      Text(
                        "Cost",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorBlackLight),
                      ),
                      Text(
                        "Profit",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorBlackLight),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['price'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                      Text(
                        (data['cost']),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                      Text(
                        (int.parse(data['price']) - int.parse(data['cost']))
                            .toString(),
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Payment',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorBlackLight),
                      ),
                      Text(
                        data['payment'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: deviceWidth * 0.9,
                  height: 1,
                  color: textColorGreenLight,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Description',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorBlackLight),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.4,
                        child: Text(
                          data['description'],
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColorGreenDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Delivery Status',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: primaryBoxColorTwo,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'To Deliver',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColorGreenDark),
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: primaryBoxColorTwo,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Delivered',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColorGreenDark),
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 40,
                        decoration: BoxDecoration(
                            color: primaryBoxColorTwo,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'Canceled',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: textColorGreenDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: deviceWidth * 0.9,
                  height: 1,
                  color: textColorGreenLight,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Details',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                      Text(
                        data['contact'],
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Address',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.4,
                        child: Text(
                          data['address'],
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColorGreenDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: deviceWidth * 0.9,
                  height: 1,
                  color: textColorGreenLight,
                ),
                SizedBox(
                  width: deviceWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Customer Note',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColorGreenDark),
                      ),
                      SizedBox(
                        width: deviceWidth * 0.4,
                        child: Text(
                          data['note'],
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: textColorGreenDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // addDocumentToFirestore('/appData/orders/orders_data');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addOrder(
                  deviceWidth: deviceWidth,
                  orderNo: orders,
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
                child: Column(
                  children: [
                    const Padding(
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        orders.toString(),
                        style: const TextStyle(
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
                child: Column(
                  children: [
                    const Padding(
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        sales.toString(),
                        style: const TextStyle(
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
                child: Column(
                  children: [
                    const Padding(
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        profit.toString(),
                        style: const TextStyle(
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
                child: Column(
                  children: [
                    const Padding(
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        monthlySales.toString(),
                        style: const TextStyle(
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
                child: Column(
                  children: [
                    const Padding(
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        cost.toString(),
                        style: const TextStyle(
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
                child: Column(
                  children: [
                    const Padding(
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
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        remaining.toString(),
                        style: const TextStyle(
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
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = 'All';
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                        color: selectedFilter == 'All'
                            ? primaryBoxColorTwo
                            : primaryBoxColorThree,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryBoxColorTwo)),
                    child: const Center(
                        child: Text(
                      'All',
                      style: TextStyle(color: textColorBlack),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = 'To Deliver';
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: selectedFilter == 'To Deliver'
                            ? primaryBoxColorTwo
                            : primaryBoxColorThree,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryBoxColorTwo)),
                    child: const Center(
                        child: Text(
                      'To Deliver',
                      style: TextStyle(color: textColorBlack),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Delivered';
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        color: selectedFilter == 'Delivered'
                            ? primaryBoxColorTwo
                            : primaryBoxColorThree,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryBoxColorTwo)),
                    child: const Center(
                        child: Text(
                      'Delivered',
                      style: TextStyle(color: textColorBlack),
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Canceled';
                    });
                  },
                  child: Container(
                    width: 85,
                    height: 30,
                    decoration: BoxDecoration(
                        color: selectedFilter == 'Canceled'
                            ? primaryBoxColorTwo
                            : primaryBoxColorThree,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: primaryBoxColorTwo)),
                    child: const Center(
                        child: Text(
                      'Canceled',
                      style: TextStyle(color: textColorBlack),
                    )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('/appData/orders/orders_data')
                  .orderBy('orderNo', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading spinner
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}")); // Show error
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text("No data available")); // Handle empty state
                }

                // Parse Firestore documents into a list
                final docs;
                if (selectedFilter != 'All') {
                  docs = snapshot.data!.docs.where((doc) {
                    // Example filter: Keep only documents with a specific field value
                    return doc['status'] == selectedFilter;
                  }).toList();
                } else {
                  docs = snapshot.data!.docs;
                }

                return SizedBox(
                  width: deviceWidth * 0.96,
                  child: ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index].data() as Map<String, dynamic>;
                      String id = docs[index].id;
                      return Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: GestureDetector(
                          onTap: () {
                            showOrderDetails(deviceWidth, data);
                          },
                          child: Container(
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
                                      data['title'],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Text(
                                              data['date'],
                                              style: GoogleFonts.righteous(
                                                  color: textColorBlackFaint,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${data['quantity']}x',
                                            style: GoogleFonts.righteous(
                                              color: textColorBlackLight,
                                            ),
                                          ),
                                          Text(
                                            data['status'],
                                            style: GoogleFonts.righteous(
                                              color: textColorBlackLight,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                data['price'],
                                                style: GoogleFonts.righteous(
                                                  color: textColorBlackLight,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                data['payment'] == 'Advance'
                                                    ? '${data['payment']}(${data['remaining']})'
                                                    : data['payment'],
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
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ]), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
