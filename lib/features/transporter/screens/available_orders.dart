import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/transporter/controller/transporter_controller.dart';
import 'package:medicare/features/transporter/screens/transporter_drawer.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/loading.dart';

class AvailableOrder extends ConsumerStatefulWidget {
  const AvailableOrder({super.key});

  @override
  ConsumerState<AvailableOrder> createState() => _AvailableOrderState();
}

class _AvailableOrderState extends ConsumerState<AvailableOrder> {
  Future acceptOrder(String orderId) async {
    await ref.read(transporterControllerProvider).acceptOrder(orderId);
    setState(() {});
  }

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
      body: StreamBuilder<List<OrderModel>>(
        stream:
            ref.read(transporterControllerProvider).availableTransporterOrder(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Show an error message if there's an error
          } else {
            final List<OrderModel> orders = snapshot.data!;
            if (orders.isEmpty) {
              return const Center(
                child: Text('No available orders'),
              );
            }
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return AvailableOrderTile(
                    order: order, acceptOrder: acceptOrder);
              },
            );
          }
        },
      ),
    );
  }
}

class AvailableOrderTile extends StatelessWidget {
  final OrderModel order;
  final Function acceptOrder;

  const AvailableOrderTile({
    super.key,
    required this.order,
    required this.acceptOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderId,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Center(
                  child: Text(
                    '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                    style: TextStyle(color: EColors.primaryColor),
                  ),
                ),
                Text(
                  'Rs ${order.price}',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            Center(
              child: GestureDetector(
                onTap: () => acceptOrder(order.orderId),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 120,
                  decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      'Accept Order',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
