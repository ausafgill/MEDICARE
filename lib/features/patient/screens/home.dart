import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/patient/controller/patient_controller.dart';
import 'package:medicare/features/patient/screens/patient_drawer.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/order_model.dart';
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
  bool isOpen = false;
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
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
                      title: "Medical Equiments",
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    NearbyPharmacyTile(
                      isOpen: true,
                      name: "Pharmacy 1",
                      contactNum: '03324325432',
                    ),
                    NearbyPharmacyTile(
                        isOpen: false,
                        name: 'Pharmacy 2',
                        contactNum: '0333344555')
                  ],
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
                          return OrderTile(order: order);
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
  const OrderTile({super.key, required this.order});

  final OrderModel order;

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
          ],
        ),
      ),
    );
  }
}

class NearbyPharmacyTile extends StatelessWidget {
  const NearbyPharmacyTile(
      {super.key,
      required this.isOpen,
      required this.name,
      required this.contactNum});

  final bool isOpen;
  final String name;
  final String contactNum;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NearbyPharmacy()));
        },
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
                name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              isOpen
                  ? const Text(
                      "Open Now",
                      style: TextStyle(
                        color: EColors.succes,
                      ),
                    )
                  : const Text(
                      "Closed",
                      style: TextStyle(
                        color: EColors.warning,
                      ),
                    ),
              ListTile(
                leading: const Icon(Icons.call),
                title: Text(contactNum),
              ),
              const SizedBox(
                height: 10,
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
                        Icons.shopping_cart,
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
