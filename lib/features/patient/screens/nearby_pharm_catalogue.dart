import 'package:flutter/material.dart';

class NearbyPharmacy extends StatefulWidget {
  const NearbyPharmacy({super.key});

  @override
  State<NearbyPharmacy> createState() => _NearbyPharmacyState();
}

class _NearbyPharmacyState extends State<NearbyPharmacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Catalogue",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Text("Pharmacy Name",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 25,
            ),
            Text("Available Medicines Medicines:",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 15,
            ),
            /* const CartItemsTile(
                img: 'assets/images/pills.png',
                name: 'Red Pills',
                pharName: 'Phar Name',
                price: '29.9'),
            const CartItemsTile(
                img: 'assets/images/pills.png',
                name: 'Red Pills',
                pharName: 'Phar Name',
                price: '29.9'), */
            const SizedBox(
              height: 25,
            ),
            Text("Available Medical Tests:",
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(
              height: 15,
            ),
            // const TestItemsTile(
            //     name: 'Liver Test', pharName: 'PharName', price: '20.00')
          ],
        ),
      ),
    );
  }
}
