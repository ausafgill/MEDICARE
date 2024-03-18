import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/pharmacy/controller/pharmacy_controller.dart';
import 'package:medicare/features/pharmacy/screens/order_detail.dart';
import 'package:medicare/features/pharmacy/screens/pharmacy_drawer.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/shared/constants/colors.dart';

class PharmacyActiveOrder extends ConsumerStatefulWidget {
  const PharmacyActiveOrder({super.key});

  @override
  ConsumerState<PharmacyActiveOrder> createState() => _ActiveOrderState();
}

class _ActiveOrderState extends ConsumerState<PharmacyActiveOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ACTIVE ORDERS",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const PharmacyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder<List<OrderModel>>(
          stream: ref.read(pharmacyControllerProvider).getActiveOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<OrderModel> orders = snapshot.data ?? [];
              if (orders.isEmpty) {
                return const Center(
                  child: Text('No orders available'),
                ); // Show a message if there are no orders
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final OrderModel order = orders[index];
                  return OrderTile(
                    order: order,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  final OrderModel order;
  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            PharmacyOrderDetailScreen.routeName,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: EColors.softGrey,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderId,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                      style:
                          TextStyle(color: EColors.primaryColor, fontSize: 12),
                    ),
                    Text(
                      "\$${order.price}",
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  ],
                ),
                Center(
                  child: Container(
                    width: 200,
                    decoration: BoxDecoration(
                        color: EColors.primaryColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Contact Transporter",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
