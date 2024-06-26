import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/user_information/screens/map_display_widget.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/drawer.dart';

class ApprovalRequest extends ConsumerStatefulWidget {
  static const routeName = '/approval-requests';
  const ApprovalRequest({super.key});

  @override
  ConsumerState<ApprovalRequest> createState() => _ApprovalRequestState();
}

class _ApprovalRequestState extends ConsumerState<ApprovalRequest> {
  bool isLoading = true;

  Future getApprovalRequests() async {
    setState(() {
      isLoading = true;
    });

    await ref.read(adminControllerProvider).getUserInApprovalList();

    setState(() {
      isLoading = false;
    });
  }

  Future approveUser(String uid) async {
    await ref.read(adminControllerProvider).acceptUser(uid: uid);
  }

  Future rejectUser(String uid) async {
    await ref.read(adminControllerProvider).rejectUser(uid: uid);
  }

  @override
  void initState() {
    getApprovalRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'APPROVAL REQUESTS',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        drawer: const DrawerSetup(),
        body: Consumer(
          builder: (context, ref, child) {
            final adminController = ref.watch(adminControllerProvider);
            final approvalRequests = adminController.getApprovalRequests();
            if (approvalRequests == null) {
              return const CircularProgressIndicator();
            } else {
              return ListView.builder(
                itemCount: approvalRequests.length,
                itemBuilder: (context, index) {
                  UserModel user = approvalRequests[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff8F9ECA),
                          border: Border.all(color: EColors.primaryColor),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Center(
                              child: Text(
                                user.userName,
                                style: const TextStyle(
                                    color: EColors.white, fontSize: 20),
                              ),
                            ),
                          ),
                          ApprovalDataTile(
                            title: user.email,
                            iconData: Icons.mail,
                          ),
                          ApprovalDataTile(
                            title: user.phoneNumber,
                            iconData: Icons.call,
                          ),
                          ApprovalDataTile(
                            title: user.operatingHours!,
                            iconData: Icons.timer,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, MapDisplayWidget.routeName,
                                  arguments: [
                                    user.location!.latitude,
                                    user.location!.longitude,
                                    true
                                  ]),
                              child: Container(
                                width: 147,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      20,
                                    ),
                                    border: Border.all(
                                        color: EColors.primaryColor)),
                                child: const ListTile(
                                  leading:
                                      Icon(Icons.map, color: EColors.white),
                                  title: Text(
                                    "Location",
                                    style: TextStyle(color: EColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: SizedBox(
                                        height: 350,
                                        width: 350,
                                        child: Image.network(user.imageUrl!),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: 147,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  border:
                                      Border.all(color: EColors.primaryColor),
                                ),
                                child: const ListTile(
                                  leading: Icon(
                                    Icons.book,
                                    color: EColors.white,
                                  ),
                                  title: Text(
                                    "Liscense",
                                    style: TextStyle(color: EColors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => approveUser(user.uid),
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const ListTile(
                                  title: Text(
                                    'APPROVE',
                                    style: TextStyle(
                                      color: EColors.white,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.done,
                                    color: EColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => rejectUser(user.uid),
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30)),
                                child: const ListTile(
                                  title: Text(
                                    'REJECT',
                                    style: TextStyle(
                                      color: EColors.white,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.cancel,
                                    color: EColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}

class ApprovalDataTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  const ApprovalDataTile(
      {super.key, required this.title, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: EColors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(color: EColors.white, fontSize: 16),
      ),
    );
  }
}
