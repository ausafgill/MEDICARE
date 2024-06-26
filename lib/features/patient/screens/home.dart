import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/chats/controller/chat_controller.dart';
import 'package:medicare/features/chats/screens/chat_screen.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/patient_drawer.dart';
import 'package:medicare/features/user_information/controller/profile_controller.dart';
import 'package:medicare/features/user_information/screens/map_display_widget.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/order_model.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/patient/screens/nearby_pharm_catalogue.dart';
import 'package:medicare/features/patient/screens/search_medical_test.dart';
import 'package:medicare/features/patient/screens/search_equipments.dart';
import 'package:medicare/features/patient/screens/search_medicines.dart';

class PatientHomeScreen extends ConsumerStatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  ConsumerState<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends ConsumerState<PatientHomeScreen> {
  Future messageUser(String userId) async {
    ChatRoomModel chatRoomId =
        await ref.read(chatControllerProvider).createOrGetChatRoom(userId);
    if (context.mounted) {
      Navigator.pushNamed(
        context,
        ChatScreen.routeName,
        arguments: [chatRoomId],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME SCREEN",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const PatientDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "SEARCH FOR",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CategoriesTile(
                      title: "Medical Test",
                      iconData: FontAwesomeIcons.stethoscope,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SearchMedicalTestsScreen.routeName,
                        );
                      },
                    ),
                    CategoriesTile(
                      title: "Pharmacy",
                      iconData: FontAwesomeIcons.prescriptionBottleMedical,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SearchMedicineScreen.routeName,
                        );
                      },
                    ),
                    CategoriesTile(
                      title: "Equiments",
                      iconData: FontAwesomeIcons.accessibleIcon,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          SearchMedicalEquipmentsScreen.routeName,
                        );
                      },
                    )
                  ],
                ),
              ),
              Text(
                "Near by Pharmacy",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: FutureBuilder<Stream<List<UserModel>>>(
                  future: ref
                      .read(patientControllerProvider)
                      .pharmaciesWithinRadius(ref
                          .read(profileControllerProvider)
                          .getUserProfile()!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final Stream<List<UserModel>> usersStream =
                          snapshot.data!;
                      return StreamBuilder<List<UserModel>>(
                        stream: usersStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final List<UserModel> nearbyPharmacies =
                                snapshot.data!;
                            if (nearbyPharmacies.isEmpty) {
                              return const Center(
                                child: Text('No Pharmacies Nearby'),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: nearbyPharmacies.length,
                              itemBuilder: (context, index) {
                                final UserModel pharmacy =
                                    nearbyPharmacies[index];
                                return NearbyPharmacyTile(
                                  pharmacy: pharmacy,
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Active Order',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: StreamBuilder<List<OrderModel>>(
                  stream: ref.read(patientControllerProvider).getActiveOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final List<OrderModel> orders = snapshot.data ?? [];
                      if (orders.isEmpty) {
                        return const Center(
                          child: Text('There are no active orders'),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final OrderModel order = orders[index];
                          return OrderTile(
                            order: order,
                            messageUser: messageUser,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Medical Tests Appointment',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: StreamBuilder<List<MedicalTestRequestModel>>(
                  stream: ref
                      .read(patientControllerProvider)
                      .getMedicalTestAppointments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final List<MedicalTestRequestModel> orders =
                          snapshot.data ?? [];
                      if (orders.isEmpty) {
                        return const Center(
                          child: Text('There are no Medical Test Appointments'),
                        );
                      }
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final MedicalTestRequestModel medicalTest =
                              orders[index];
                          return AppointmentTile(
                              medicalAppointment: medicalTest);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentTile extends StatelessWidget {
  const AppointmentTile({
    super.key,
    required this.medicalAppointment,
  });

  final MedicalTestRequestModel medicalAppointment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 202,
        decoration: BoxDecoration(
            color: EColors.softGrey, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              medicalAppointment.medicalTest.medicalTestName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              "${medicalAppointment.requestDate!.day}/${medicalAppointment.requestDate!.month}/${medicalAppointment.requestDate!.year}",
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(Icons.price_check),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    medicalAppointment.medicalTest.price.toString(),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Icon(FontAwesomeIcons.prescriptionBottleMedical),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(medicalAppointment.medicalTest.pharmacyName)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    required this.messageUser,
  });

  final OrderModel order;
  final Function messageUser;

  Future messageTransporter(BuildContext context) async {
    if (order.transporterId != null) {
      await messageUser(order.transporterId);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: Text(
              'No Transporter Assigned Yet',
              style: TextStyle(color: Colors.blue),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 202,
        decoration: BoxDecoration(
            color: EColors.softGrey, borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                order.orderId,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
            const Text(
              "Active",
              style: TextStyle(
                color: EColors.warning,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => messageTransporter(context),
                child: Container(
                  decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Contact Transporter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NearbyPharmacyTile extends StatelessWidget {
  const NearbyPharmacyTile({super.key, required this.pharmacy});

  final UserModel pharmacy;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 202,
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              pharmacy.userName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: Text(pharmacy.phoneNumber),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, NearbyPharmacy.routeName,
                        arguments: [pharmacy]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MapDisplayWidget.routeName,
                        arguments: [
                          pharmacy.location!.latitude,
                          pharmacy.location!.longitude,
                          true,
                        ]);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        FontAwesomeIcons.locationDot,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTap;
  const CategoriesTile(
      {super.key,
      required this.title,
      required this.iconData,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 62,
              width: 69,
              decoration: BoxDecoration(
                  color: EColors.softGrey,
                  borderRadius: BorderRadius.circular(20)),
              child: Icon(
                iconData,
                color: EColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          )
        ],
      ),
    );
  }
}
