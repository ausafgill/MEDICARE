import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/pharmacy/controller/pharmacy_controller.dart';
import 'package:medicare/features/pharmacy/screens/pharmacy_drawer.dart';
import 'package:medicare/models/medical_request_model.dart';
import 'package:medicare/models/medical_test_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/features/pharmacy/screens/add_test_offered.dart';
import 'package:medicare/features/pharmacy/screens/medical_test_details.dart';

class MedicalTestScreen extends ConsumerStatefulWidget {
  const MedicalTestScreen({super.key});

  @override
  ConsumerState<MedicalTestScreen> createState() => _MedicalTestScreenState();
}

class _MedicalTestScreenState extends ConsumerState<MedicalTestScreen> {
  Future acceptMedicalTest(String requestId, DateTime dateTime) async {
    await ref
        .read(pharmacyControllerProvider)
        .acceptMedicalTestRequest(requestId, dateTime);
    if (context.mounted) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  Future rejectMedicalTest(String requestId) async {
    await ref
        .read(pharmacyControllerProvider)
        .rejectMedicalTestRequest(requestId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const PharmacyDrawer(),
      appBar: AppBar(
        title: Text("MEDICAL TESTS",
            style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Offered Medical Tests",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: StreamBuilder<List<MedicalTestModel>>(
                      stream: ref
                          .read(pharmacyControllerProvider)
                          .getMedicalTestCatalogue(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No medical tests available.'),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final medicalTest = snapshot.data![index];
                            return OfferedTestTile(
                              medicalTest: medicalTest,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Medical Tests Requests",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: StreamBuilder<List<MedicalTestRequestModel>>(
                      stream: ref
                          .read(pharmacyControllerProvider)
                          .getMedicalTestRequests(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No medical tests available.'),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final medicalTest = snapshot.data![index];
                            return TestRequestTile(
                              request: medicalTest,
                              acceptRequest: acceptMedicalTest,
                              rejectRequest: rejectMedicalTest,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Confirmed Appointments",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: StreamBuilder<List<MedicalTestRequestModel>>(
                      stream: ref
                          .read(pharmacyControllerProvider)
                          .getMedicalTestAppointments(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('No medical tests available.'),
                          );
                        }

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final medicalTest = snapshot.data![index];
                            return ConfirmedTests(
                              medicalTest: medicalTest,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddTestOffered()));
                },
                child: Container(
                    height: 50,
                    width: 200,
                    decoration: BoxDecoration(
                        color: EColors.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      child: Center(
                        child: Text(
                          "Add Test Offered",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ConfirmedTests extends StatelessWidget {
  final MedicalTestRequestModel medicalTest;
  const ConfirmedTests({
    super.key,
    required this.medicalTest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.50,
        decoration: BoxDecoration(
          color: EColors.softGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              medicalTest.medicalTest.medicalTestName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "${medicalTest.requestDate!.day}/${medicalTest.requestDate!.month}/${medicalTest.requestDate!.year}",
              style: TextStyle(color: EColors.primaryColor),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chat,
                color: EColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TestRequestTile extends StatefulWidget {
  final MedicalTestRequestModel request;
  final Function acceptRequest;
  final Function rejectRequest;
  const TestRequestTile({
    super.key,
    required this.request,
    required this.acceptRequest,
    required this.rejectRequest,
  });

  @override
  State<TestRequestTile> createState() => _TestRequestTileState();
}

class _TestRequestTileState extends State<TestRequestTile> {
  DateTime date = DateTime.now();
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != date) {
      setState(() {
        date = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future acceptMedicalRequest() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Quantity"),
          content: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              controller: _dateController,
              readOnly: true,
              onTap: () {
                _selectDate(context);
              },
              decoration: const InputDecoration(
                  hintText: "Select Appointment Date",
                  fillColor: EColors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_month_outlined)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  widget.acceptRequest(widget.request.requestId, date),
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.48,
        decoration: BoxDecoration(
            color: EColors.softGrey, borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Medical Test 1',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.request.medicalTest.medicalTestName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Rs.${widget.request.medicalTest.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () => acceptMedicalRequest(),
                    icon: const Icon(
                      Icons.done,
                      color: EColors.succes,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        widget.rejectRequest(widget.request.requestId),
                    icon: const Icon(
                      FontAwesomeIcons.xmark,
                      color: EColors.warning,
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

class OfferedTestTile extends StatelessWidget {
  final MedicalTestModel medicalTest;
  const OfferedTestTile({super.key, required this.medicalTest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            MedicalTestDetail.routeName,
            arguments: [medicalTest],
          );
        },
        child: Container(
          decoration: BoxDecoration(
              color: EColors.softGrey, borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicalTest.medicalTestName,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Price: Rs.${medicalTest.price}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Duration: ${medicalTest.duration}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
