import 'package:finance_app/add_order.dart';
import 'package:finance_app/colors.dart';
import 'package:finance_app/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:intl/intl.dart';

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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int orders = 0;
  int sales = 0;
  int profit = 0;
  int cost = 0;
  int monthlySales = 0;
  int remaining = 0;
  int expenses = 0;
  int balance = 0;

  String selectedFilter = 'All';

  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState(); // Call super.initState() first

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    listenToFirestore('/appData/live_statistics');
    // updateMonthlySales();
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

  // void listenToCollectionChanges() {
  //   FirebaseFirestore.instance
  //       .collection('appData')
  //       .doc('orders')
  //       .collection('orders_data')
  //       .snapshots()
  //       .listen((snapshot) {
  //     // Trigger the future function to get the count
  //     updateMonthlySales();
  //   });
  // }
  //
  // // Function to update the count and set state
  // void updateMonthlySales() async {
  //   int monthlySalesTemp = await monthlySalesCount();
  //   int remainingTemp = await remainingCount();
  //   await FirebaseFirestore.instance
  //       .collection('appData')
  //       .doc('live_statistics')
  //       .update({'monthly_sale': monthlySalesTemp, 'remaining': remainingTemp});
  // }

  void listenToFirestore(String collectionPath) {
    FirebaseFirestore.instance
        .doc(collectionPath) // Reference to your document
        .snapshots() // Listen for changes
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          orders = snapshot['orders'];
          sales = snapshot['sales'];
          profit = snapshot['profit'];
          monthlySales = snapshot['monthly_sale'];
          cost = snapshot['cost'];
          remaining = snapshot['remaining'];
          balance = snapshot['balance'];
          expenses = snapshot['expenses'];
        });
      }
    });
  }

  void updateStatus(String status, String id, String payment) async {
    await FirebaseFirestore.instance
        .collection('appData')
        .doc('orders')
        .collection('orders_data')
        .doc(id)
        .update({
      'status': status,
      'payment': status == 'Delivered'
          ? 'Paid'
          : status == 'Canceled'
              ? 'Unpaid'
              : payment
    });
    // updateMonthlySales();
  }

  void showOrderDetails(
      double deviceWidth, double deviceHeight, Map data, String id) {
    String selectedOption = data['status'];
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: modelSheetBackgroundColor,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: deviceHeight * 0.85,
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
                    height: 10,
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
                    height: 15,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: deviceWidth * 0.8,
                          child: Text(
                            data['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: textColorGreenDark),
                          ),
                        ),
                        Text(
                          "${data['quantity']}x",
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColorGreenDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: deviceWidth * 0.9,
                    height: 1,
                    color: textColorGreenLight,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                        Text(
                          "Cost",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                        Text(
                          "Profit",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
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
                              fontWeight: FontWeight.w600,
                              color: textColorGreenDark),
                        ),
                        Text(
                          (data['cost']),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: textColorGreenDark),
                        ),
                        Text(
                          (int.parse(data['price']) - int.parse(data['cost']))
                              .toString(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
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
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                        Text(
                          data['payment'] == 'Advance'
                              ? "${data['payment']}(${data['remaining']})"
                              : data['payment'],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColorGreenDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: deviceWidth * 0.9,
                    height: 1,
                    color: textColorGreenLight,
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
                          'Description',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.5,
                          child: Text(
                            data['description'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColorGreenDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Delivery Status',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = 'To Deliver';
                            });
                            updateStatus('To Deliver', id, data['payment']);
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                color: selectedOption == 'To Deliver'
                                    ? primaryBoxColorOne
                                    : modelSheetBackgroundColor,
                                border: Border.all(color: primaryBoxColorOne),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'To Deliver',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textColorGreenDark),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = 'Delivered';
                            });
                            updateStatus('Delivered', id, data['payment']);
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                color: selectedOption == 'Delivered'
                                    ? primaryBoxColorOne
                                    : modelSheetBackgroundColor,
                                border: Border.all(color: primaryBoxColorOne),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Delivered',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textColorGreenDark),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = 'Canceled';
                            });
                            updateStatus('Canceled', id, data['payment']);
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                color: selectedOption == 'Canceled'
                                    ? primaryBoxColorOne
                                    : modelSheetBackgroundColor,
                                border: Border.all(color: primaryBoxColorOne),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Canceled',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: textColorGreenDark),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: deviceWidth * 0.9,
                    height: 1,
                    color: textColorGreenLight,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Customer Details',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: textColorBlackLight),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorGreenDark),
                        ),
                        Text(
                          data['contact'],
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorGreenDark),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.5,
                          child: Text(
                            data['address'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: textColorGreenDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   width: deviceWidth * 0.9,
                  //   height: 1,
                  //   color: textColorGreenLight,
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  SizedBox(
                    width: deviceWidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Customer Note',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColorBlackLight),
                        ),
                        SizedBox(
                          width: deviceWidth * 0.5,
                          child: Text(
                            data['note'],
                            style: const TextStyle(
                                fontSize: 14,
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
        });
  }

  void updateStatistics() async {
    Map statistiscData = await getStatistics();
    print(statistiscData);
    setState(() {
      orders = statistiscData['orders'];
      sales = statistiscData['sales'];
      profit = statistiscData['profit'];
      monthlySales = statistiscData['monthly_sale'];
      cost = statistiscData['cost'];
      remaining = statistiscData['remaining'];
      balance = statistiscData['balance'];
      expenses = statistiscData['expenses'];
    });
  }

  void addExpense(double deviceHeight, double deviceWidth) {
    final TextEditingController expense = TextEditingController();
    final TextEditingController note = TextEditingController();
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: primaryBoxColorThree,
        context: context,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: deviceHeight * 0.6,
              width: deviceWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: primaryBoxColorOne,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.8,
                    height: 50,
                    child: TextField(
                      onTapOutside: (pointer) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: expense,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        fillColor: textBoxColorFill,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: textBoxColorBorder)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: textBoxColorBorder)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: textBoxColorBorder)),
                        labelText: 'Expense',
                        labelStyle: const TextStyle(color: textBoxColorText),
                        contentPadding: const EdgeInsets.only(left: 10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: deviceWidth * 0.8,
                    height: 100,
                    child: TextField(
                      onTapOutside: (pointer) {
                        FocusScope.of(context).unfocus();
                      },
                      controller: note,
                      maxLines: 6,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        fillColor: textBoxColorFill,
                        alignLabelWithHint: true,
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: textBoxColorBorder)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: textBoxColorBorder)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                const BorderSide(color: textBoxColorBorder)),
                        labelText: 'Note',
                        labelStyle: const TextStyle(color: textBoxColorText),
                        contentPadding:
                            const EdgeInsets.only(left: 10, top: 15),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () async {
                      add_expense(int.parse(expense.text), note.text);
                      updateStatistics();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryBoxColorOne,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                              color: textColorWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionBubble(
            items: <Bubble>[
              Bubble(
                title: "Add Order",
                iconColor: Colors.white,
                bubbleColor: primaryBoxColorOne,
                icon: Icons.event_note_outlined,
                titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController!.reverse();
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
              ),
              Bubble(
                title: "Add Expense",
                iconColor: Colors.white,
                bubbleColor: primaryBoxColorOne,
                icon: Icons.currency_exchange,
                titleStyle: TextStyle(fontSize: 16, color: Colors.white),
                onPress: () {
                  _animationController!.reverse();
                  addExpense(deviceHeight, deviceWidth);
                },
              ),
            ],
            onPress: () => _animationController!.isCompleted
                ? _animationController!.reverse()
                : _animationController!.forward(),
            iconColor: textColorWhite,
            backGroundColor: textColorGreenLight,
            iconData: Icons.add_rounded,
            animation: _animation!),
        backgroundColor: background,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceWidth * 0.96,
              child: Column(children: [
                // const SizedBox(
                //   height: 10,
                // ),
                // Container(
                //   width: deviceWidth * 0.96,
                //   height: 30,
                //   decoration: BoxDecoration(
                //       color: primaryBoxColorOne,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: const Center(
                //     child: Text(
                //       'Statistics',
                //       style: TextStyle(
                //           color: textColorGreenDark,
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  width: deviceWidth * 0.96,
                  height: 90,
                  decoration: BoxDecoration(
                      color: primaryBoxColorOne,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
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
                                'Balance',
                                style: TextStyle(
                                    color: textColorGreenDark,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                balance.toString(),
                                style: const TextStyle(
                                    color: textColorWhite,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 50,
                        decoration: BoxDecoration(
                            color: textColorGreenDark,
                            borderRadius: BorderRadius.circular(1.5)),
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
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                sales.toString(),
                                style: const TextStyle(
                                    color: textColorWhite,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 50,
                        decoration: BoxDecoration(
                            color: textColorGreenDark,
                            borderRadius: BorderRadius.circular(1.5)),
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
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                profit.toString(),
                                style: const TextStyle(
                                    color: textColorWhite,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                SizedBox(
                  width: deviceWidth * 0.96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: deviceWidth * 0.31,
                        height: 70,
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                orders.toString(),
                                style: const TextStyle(
                                    color: textColorWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: deviceWidth * 0.33,
                        height: 70,
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                cost.toString(),
                                style: const TextStyle(
                                    color: textColorWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: deviceWidth * 0.31,
                        height: 70,
                        decoration: BoxDecoration(
                            color: primaryBoxColorOne,
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                'Expenses',
                                style: TextStyle(
                                    color: textColorGreenDark,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                expenses.toString(),
                                style: const TextStyle(
                                    color: textColorWhite,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                // Container(
                //   width: deviceWidth * 0.96,
                //   height: 40,
                //   decoration: BoxDecoration(
                //       color: primaryBoxColorOne,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: const Center(
                //     child: Text(
                //       'Orders',
                //       style: TextStyle(
                //           color: textColorGreenDark,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w500),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: deviceWidth * 0.96,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                          width: 3,
                        ),
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
                        const SizedBox(
                          width: 3,
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
                        const SizedBox(
                          width: 3,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = 'Expenses';
                            });
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                color: selectedFilter == 'Expenses'
                                    ? primaryBoxColorTwo
                                    : primaryBoxColorThree,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: primaryBoxColorTwo)),
                            child: const Center(
                                child: Text(
                              'Expenses',
                              style: TextStyle(color: textColorBlack),
                            )),
                          ),
                        ),
                        const SizedBox(
                          width: 3,
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
                        const SizedBox(
                          width: 3,
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
                        const SizedBox(
                          width: 3,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('/appData/orders/orders_data')
                        .orderBy('timeStamp', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Show loading spinner
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child:
                                Text("Error: ${snapshot.error}")); // Show error
                      }
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(
                            child: Text(
                                "No data available")); // Handle empty state
                      }

                      // Parse Firestore documents into a list
                      final List<QueryDocumentSnapshot<Object?>> docs;

                      if (selectedFilter != 'All') {
                        if (selectedFilter == 'Expenses') {
                          docs = snapshot.data!.docs.where((doc) {
                            return doc['isExpense'] == true;
                          }).toList();
                        } else {
                          docs = snapshot.data!.docs.where((doc) {
                            // Safely access document data and check for null
                            final data = doc.data() as Map<String,
                                dynamic>?; // Explicit cast and null check

                            if (data != null && data.containsKey('status')) {
                              return data['status'] == selectedFilter;
                            }

                            return false; // Exclude documents without 'status' or with null data
                          }).toList();
                        }
                      } else {
                        docs = snapshot.data!.docs;
                      }

                      return SizedBox(
                        width: deviceWidth * 0.96,
                        child: ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;
                            String id = docs[index].id;
                            bool isExpense = data['isExpense'];
                            return !isExpense
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        showOrderDetails(deviceWidth,
                                            deviceHeight, data, id);
                                      },
                                      child: Container(
                                        width: deviceWidth * 0.96,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          color: primaryBoxColorTwo,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 6),
                                              child: SizedBox(
                                                width: deviceWidth * 0.45,
                                                child: Text(
                                                  data['title'],
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.righteous(
                                                    color: textColorBlackLight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10,
                                                                top: 5),
                                                        child: Text(
                                                          data['date'],
                                                          style: GoogleFonts
                                                              .righteous(
                                                                  color:
                                                                      textColorBlackFaint,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Text(
                                                      //   '${data['quantity']}x',
                                                      //   style: GoogleFonts
                                                      //       .righteous(
                                                      //     color:
                                                      //         textColorBlackLight,
                                                      //   ),
                                                      // ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 10),
                                                        child: Text(
                                                          data['status'],
                                                          style: GoogleFonts
                                                              .righteous(
                                                            color:
                                                                textColorBlackFaint,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text(
                                                              "Rs.${data['price']}",
                                                              style: GoogleFonts
                                                                  .righteous(
                                                                color:
                                                                    textColorBlackLight,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              data['payment'],
                                                              style: GoogleFonts
                                                                  .righteous(
                                                                color:
                                                                    textColorBlackFaint,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
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
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Container(
                                      width: deviceWidth * 0.96,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: primaryBoxColorOne,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 6),
                                            child: SizedBox(
                                              width: deviceWidth * 0.5,
                                              child: Text(
                                                data['note'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.righteous(
                                                  color: textColorBlackLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6, top: 5),
                                                child: Text(
                                                  DateFormat(
                                                          'dd/MM/yyyy h:mm a')
                                                      .format(data['timeStamp']
                                                          .toDate())
                                                      .toString(),
                                                  style: GoogleFonts.righteous(
                                                      color:
                                                          textColorBlackFaint,
                                                      fontSize: 12),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 6,
                                                ),
                                                child: Text(
                                                  'Rs.${data['expense']}',
                                                  style: GoogleFonts.righteous(
                                                    color: textColorBlackLight,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ]),
            ),
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
