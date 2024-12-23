import 'package:cloud_firestore/cloud_firestore.dart';

int sOrders = 0;
int sSales = 0;
int sProfit = 0;
int sCost = 0;
int sMonthlySales = 0;
int sRemaining = 0;

Future<void> getData() async {
  // Reference to the document
  DocumentReference docRef =
      FirebaseFirestore.instance.collection('appData').doc('live_statistics');

  try {
    // Fetch the document once
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Access the document's data
      Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
      sOrders = data!['orders'];
      sSales = data['sales'];
      sProfit = data['profit'];
      sCost = data['cost'];
      sMonthlySales = data['monthly_sale'];
      sRemaining = data['remaining'];
    } else {
      print("Document does not exist!");
    }
  } catch (e) {
    print("Error fetching document: $e");
  }
}

Future<int> monthlySalesCount() async {
  // Get the current date
  DateTime now = DateTime.now();

  // Calculate the start and end of the month
  DateTime startOfMonth =
      DateTime(now.year, now.month, 1); // First day of the month
  DateTime endOfMonth = DateTime(now.year, now.month + 1, 1)
      .subtract(Duration(seconds: 1)); // Last day of the month

  Timestamp startTimestamp = Timestamp.fromDate(startOfMonth);
  Timestamp endTimestamp = Timestamp.fromDate(endOfMonth);

  try {
    // Query documents within the date range
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('appData')
        .doc('orders')
        .collection('orders_data')
        .where('timeStamp', isGreaterThanOrEqualTo: startTimestamp)
        .where('timeStamp', isLessThanOrEqualTo: endTimestamp)
        .get();

    // Get the count of documents
    int documentCount = snapshot.docs.length;
    return documentCount;
  } catch (e) {
    print("Error fetching document count: $e");
    return 0;
  }
}

Future<int> remainingCount() async {
  try {
    // Query documents where field matches the given value
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('addData')
        .doc('orders')
        .collection('orders_data')
        .where('status', isEqualTo: 'To Deliver')
        .get();

    // Get the count of documents
    int documentCount = snapshot.docs.length;
    return documentCount;
  } catch (e) {
    print("Error fetching document count: $e");
    return 0;
  }
}

Future<Map<String, dynamic>> calculateStatistics(int price, int cost) async {
  await getData();
  sOrders = sOrders + 1;
  sSales = sSales + price;
  sProfit = sProfit + price - cost;
  sCost = sCost + cost;
  int temp = await monthlySalesCount();
  sMonthlySales = sMonthlySales + temp;
  int temp2 = await remainingCount();
  sRemaining = sRemaining + temp2;
  Map<String, dynamic> data = {
    'orders': sOrders,
    'sales': sSales,
    'profit': sProfit,
    'monthly_sale': sMonthlySales,
    'cost': sCost,
    'remaining': sRemaining,
  };
  print(data);
  return data;
}
