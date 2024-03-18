import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/patient_drawer.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/shared/constants/colors.dart';

class OrderHistory extends ConsumerStatefulWidget {
  const OrderHistory({super.key});

  @override
  ConsumerState<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends ConsumerState<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ORDER HISTORY",
              style: Theme.of(context).textTheme.headlineMedium),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        drawer: const PatientDrawer(),
        body: StreamBuilder<List<OrderModel>>(
          stream: ref.read(patientControllerProvider).getOrderHistory(),
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
                );
              }
              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final OrderModel order = orders[index];
                  return OrderHistoryTile(
                    order: order,
                  );
                },
              );
            }
          },
        ));
  }
}

class OrderHistoryTile extends StatelessWidget {
  final OrderModel order;
  const OrderHistoryTile({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        order.orderId,
                        style: TextStyle(color: EColors.primaryColor),
                      ),
                    ),
                    Center(
                      child: Text(
                        '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                        style: TextStyle(color: EColors.primaryColor),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Icon(
                          FontAwesomeIcons.prescriptionBottleMedical),
                      title: Text(
                        order.isCompleted == false ? 'Active' : 'Delivered',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  ],
                ),
              ),
              Text(
                "\$${order.price}",
                style: Theme.of(context).textTheme.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
