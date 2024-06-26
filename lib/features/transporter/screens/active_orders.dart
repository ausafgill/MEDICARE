import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/chats/controller/chat_controller.dart';
import 'package:medicare/features/chats/screens/chat_screen.dart';
import 'package:medicare/features/transporter/controller/transporter_controller.dart';
import 'package:medicare/features/transporter/screens/transporter_drawer.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/loading.dart';

class ActiveOrders extends ConsumerStatefulWidget {
  const ActiveOrders({super.key});

  @override
  ConsumerState<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends ConsumerState<ActiveOrders> {
  Future orderCompleted(String orderId) async {
    await ref.read(transporterControllerProvider).orderCompleted(orderId);
    setState(() {});
  }

  Future messageUser(String pharmacyId) async {
    ChatRoomModel chatRoomId =
        await ref.read(chatControllerProvider).createOrGetChatRoom(pharmacyId);
    if (context.mounted) {
      Navigator.pushNamed(context, ChatScreen.routeName,
          arguments: [chatRoomId]);
    }
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
        stream: ref.read(transporterControllerProvider).acceptedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
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
                return ActiveOrderTile(
                  orderCompleted: orderCompleted,
                  messageUser: messageUser,
                  order: order,
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ActiveOrderTile extends StatelessWidget {
  final OrderModel order;
  final Function orderCompleted;
  final Function messageUser;

  const ActiveOrderTile({
    super.key,
    required this.order,
    required this.orderCompleted,
    required this.messageUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: EColors.softGrey, borderRadius: BorderRadius.circular(15)),
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
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (order.pharmacyId != null) {
                        messageUser(order.pharmacyId);
                      } else {
                        messageUser(order.companyId);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                          color: EColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Message Pharmacy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () => messageUser(order.userId),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 150,
                      decoration: BoxDecoration(
                          color: EColors.primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Message Patient',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: GestureDetector(
                onTap: () => orderCompleted(order.orderId),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: 150,
                  decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text(
                      'Completed Order',
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
