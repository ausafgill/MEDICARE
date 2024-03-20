import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/transporter/screen/transporter_drawer.dart';
import 'package:medicare/shared/constants/colors.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AVAILABLE ORDERS",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const TransporterDrawer(),
      body: Column(
        children: [
          ActiveOrderTile(
            orderId: 'Order ID',
            date: '17/07/2024',
            price: '9.99',
            patName: 'Patient 1',
          )
        ],
      ),
    );
  }
}

class ActiveOrderTile extends StatelessWidget {
  final String orderId;
  final String date;
  final String price;
  final String patName;

  const ActiveOrderTile(
      {super.key,
      required this.orderId,
      required this.date,
      required this.price,
      required this.patName});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: EColors.softGrey,
                borderRadius: BorderRadius.circular(15)),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$orderId",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        '$date',
                        style: TextStyle(color: EColors.primaryColor),
                      ),
                    ],
                  ),
                  Text(
                    'Rs ${price}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Icon(
                        Icons.person,
                        color: EColors.primaryColor,
                      ),
                      title: Text('$patName',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                ],
              ),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: 150,
                    decoration: BoxDecoration(
                        color: EColors.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Center(
                        child: Text(
                      'Completed Order',
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                ),
              )
            ])));
  }
}
