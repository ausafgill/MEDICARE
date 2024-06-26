import 'package:flutter/material.dart';
import 'package:medicare/shared/constants/colors.dart';

class CompanyOrderDetailScreen extends StatefulWidget {
  static const routeName = '/company-order-detail';
  const CompanyOrderDetailScreen({super.key});

  @override
  State<CompanyOrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<CompanyOrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ORDER DETAILS",
            style: TextStyle(color: Colors.white, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: EColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      'Order Id',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const OrderDetailTile(
                    name: 'Patient 1',
                    iconData: Icons.person,
                  ),
                  const OrderDetailTile(
                      name: '0334455677', iconData: Icons.call),
                  const OrderDetailTile(
                      name: 'email@email.com', iconData: Icons.email),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Total: Rs.200.00',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const OrderDetailCatalogueTile(
                      imgUrl: 'assets/images/pills.png',
                      name: 'Red Pills',
                      quantity: '3',
                      price: '9.99'),
                  const OrderDetailCatalogueTile(
                      imgUrl: 'assets/images/pills.png',
                      name: 'Blue Pills',
                      quantity: '1',
                      price: '5.99'),
                  const OrderDetailCatalogueTile(
                      imgUrl: 'assets/images/pills.png',
                      name: 'Blue Pills',
                      quantity: '1',
                      price: '5.99')
                ],
              ),
              Container(
                  width: 220,
                  decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Message User",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Icon(
                          Icons.chat,
                          color: Colors.white,
                          size: 26,
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailCatalogueTile extends StatelessWidget {
  final String name;
  final String imgUrl;
  final String quantity;
  final String price;

  const OrderDetailCatalogueTile(
      {super.key,
      required this.imgUrl,
      required this.name,
      required this.quantity,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(imgUrl),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    'Quantitiy: $quantity',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Text(
                "Rs.$price",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailTile extends StatelessWidget {
  final String name;
  final IconData iconData;
  const OrderDetailTile(
      {super.key, required this.name, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: Icon(
          iconData,
          color: EColors.primaryColor,
          size: 30,
        ),
        title: Text(
          name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
