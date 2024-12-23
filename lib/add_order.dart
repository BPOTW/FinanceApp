import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'functions.dart';

class addOrder extends StatefulWidget {
  final deviceWidth;
  final orderNo;
  const addOrder({super.key, required this.deviceWidth, required this.orderNo});

  @override
  State<addOrder> createState() => _addOrderState();
}

class _addOrderState extends State<addOrder> {
  final TextEditingController title = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController contact = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController note = TextEditingController();
  final TextEditingController quantity = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController cost = TextEditingController();
  final TextEditingController remaining = TextEditingController();
  final TextEditingController date = TextEditingController();
  final List<String> payment = ['Paid', 'Unpaid', 'Advance'];
  String? selectedPaymentOption;
  final List<String> status = ['Completed', 'To Deliver', 'Canceled'];
  String? selectedStatusOption;

  int sOrders = 0;
  int sSales = 0;
  int sProfit = 0;
  int sCost = 0;
  int sMonthlySales = 0;
  int sRemaining = 0;

  Future<void> _selectDateTime(BuildContext context) async {
    // Step 1: Select a Date
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest date
      lastDate: DateTime(2100), // Latest date
    );

    if (pickedDate != null) {
      // Step 2: Select a Time
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Combine Date and Time
        final DateTime fullDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          // Format DateTime and update TextField
          date.text =
              "${fullDateTime.day}/${fullDateTime.month}/${fullDateTime.year} ${pickedTime.format(context)}";
        });
      }
    }
  }

  Future<void> addOrder() async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference statisticsData =
        FirebaseFirestore.instance.collection('appData').doc('live_statistics');
    DocumentReference ordersData = FirebaseFirestore.instance
        .collection('/appData/orders/orders_data')
        .doc();

    Map<String, dynamic> tempData =
        await calculateStatistics(int.parse(price.text), int.parse(cost.text));

    Map<String, dynamic> data = {
      'title': title.text,
      'name': name.text,
      'address': address.text,
      'contact': contact.text,
      'note': note.text,
      'description': description.text,
      'date': date.text,
      'price': price.text,
      'quantity': quantity.text,
      'payment': selectedPaymentOption,
      'remaining': remaining.text,
      'status': selectedStatusOption,
      'cost': cost.text,
      'orderNo': tempData['orders'],
      'timeStamp': DateTime.timestamp(),
    };

    Map<String, int> data2 = {
      'orders': tempData['orders'],
      'sales': tempData['sales'],
      'profit': tempData['profit'],
      // 'monthly_sale': tempData['monthly_sale'],
      'cost': tempData['cost'],
      // 'remaining': tempData['remaining'],
    };

    // print(tempData);

    batch.update(statisticsData, data2);
    batch.set(ordersData, data);
    try {
      // Commit the batch
      await batch.commit();
      print("Batch update successful!");
    } catch (e) {
      print("Error during batch update: $e");
    }
    // try {

    // // Add a new document with auto-generated ID
    // await FirebaseFirestore.instance
    //     .collection('/appData/orders/orders_data')
    //     .add(data);
    //
    // print("Document added successfully!");
    // Navigator.pop(context);
    // } catch (e) {
    //   print("Error adding document: $e");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: background,
          body: Center(
            child: SizedBox(
              width: widget.deviceWidth * 0.8,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            size: 25,
                            color: textColorBlackLight,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        const Text(
                          'Add order',
                          style: TextStyle(
                              color: textColorBlackLight,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //title box
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: title,
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
                          labelText: 'Title',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //customer name
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: name,
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
                          labelText: 'Customer Name',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //customer address
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: address,
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
                          labelText: 'Customer Address',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //customer contact
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: contact,
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
                          labelText: 'Customer Contact',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //description
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 130,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: description,
                        maxLines: 6,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
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
                          labelText: 'Order Description',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding:
                              const EdgeInsets.only(left: 10, top: 15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //customer note
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 130,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        maxLines: 6,
                        scrollPhysics: const AlwaysScrollableScrollPhysics(),
                        controller: note,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
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
                          labelText: 'Customer Note',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding:
                              const EdgeInsets.only(left: 10, top: 15),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //date
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        controller: date,
                        readOnly: true,
                        onTap: () {
                          _selectDateTime(context);
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.calendar_month_rounded,
                            color: textColorBlackLight,
                          ),
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
                          labelText: 'Order Date',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //price and cost
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: widget.deviceWidth * 0.38,
                          height: 50,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: textColorBlackFaint)),
                          child: TextField(
                            onTapOutside: (pointer) {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.number,
                            controller: price,
                            decoration: InputDecoration(
                              fillColor: textBoxColorFill,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              labelText: 'Price',
                              labelStyle:
                                  const TextStyle(color: textBoxColorText),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widget.deviceWidth * 0.38,
                          height: 50,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: textColorBlackFaint)),
                          child: TextField(
                            onTapOutside: (pointer) {
                              FocusScope.of(context).unfocus();
                            },
                            keyboardType: TextInputType.number,
                            controller: cost,
                            decoration: InputDecoration(
                              fillColor: textBoxColorFill,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              labelText: 'Cost',
                              labelStyle:
                                  const TextStyle(color: textBoxColorText),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //quantity
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(8),
                      //     border: Border.all(color: textColorBlackFaint)),
                      child: TextField(
                        onTapOutside: (pointer) {
                          FocusScope.of(context).unfocus();
                        },
                        controller: quantity,
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
                          labelText: 'Quantity',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding: const EdgeInsets.only(left: 10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //payment and remaining
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: widget.deviceWidth * 0.38,
                          height: 50,
                          child: DropdownButtonFormField<String>(
                            borderRadius: BorderRadius.circular(10),
                            decoration: InputDecoration(
                              fillColor: textBoxColorFill,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              labelText: 'Payment',
                              labelStyle:
                                  const TextStyle(color: textBoxColorText),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            value:
                                selectedPaymentOption, // The current selected value
                            items: payment.map((String option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(), // Map the list to dropdown items
                            onChanged: (value) {
                              setState(() {
                                selectedPaymentOption =
                                    value; // Update the selected value
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: widget.deviceWidth * 0.38,
                          height: 50,
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(8),
                          //     border: Border.all(color: textColorBlackFaint)),
                          child: TextField(
                            enabled: selectedPaymentOption != null &&
                                    selectedPaymentOption == 'Advance'
                                ? true
                                : false,
                            onTapOutside: (pointer) {
                              FocusScope.of(context).unfocus();
                            },
                            controller: remaining,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: textBoxColorFill,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                      color: textBoxColorBorder)),
                              labelText: 'Remaining',
                              labelStyle:
                                  const TextStyle(color: textBoxColorText),
                              contentPadding: const EdgeInsets.only(left: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //status
                    SizedBox(
                      width: widget.deviceWidth * 0.8,
                      height: 50,
                      child: DropdownButtonFormField<String>(
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
                          labelText: 'Order Status',
                          labelStyle: const TextStyle(color: textBoxColorText),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        value:
                            selectedStatusOption, // The current selected value
                        borderRadius: BorderRadius.circular(10),
                        items: status.map((String option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(), // Map the list to dropdown items
                        onChanged: (value) {
                          setState(() {
                            selectedStatusOption =
                                value; // Update the selected value
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        addOrder();
                      },
                      child: Container(
                        width: widget.deviceWidth * 0.8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: buttonBoxColorBorder,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'Add Order',
                            style: TextStyle(
                                color: textBoxColorText,
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
