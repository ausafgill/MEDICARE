import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/chats/controller/chat_controller.dart';
import 'package:medicare/features/chats/screens/chat_screen.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';

class ProfileView extends ConsumerStatefulWidget {
  final UserModel user;
  const ProfileView({super.key, required this.user});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  TextEditingController newInfo = TextEditingController();
  bool isEdited = false;
  @override
  void dispose() {
    super.dispose();
    newInfo.dispose();
  }

  setEmail(String value) {
    setState(() {
      widget.user.email = value;
      isEdited = true;
    });
    Navigator.pop(context);
  }

  setGender(String value) {
    setState(() {
      widget.user.gender = value;
      isEdited = true;
    });
    Navigator.pop(context);
  }

  setPhoneNumber(String value) {
    setState(() {
      widget.user.phoneNumber = value;
      isEdited = true;
    });
    Navigator.pop(context);
  }

  setVehicleNumber(String value) {
    setState(() {
      widget.user.vehicleNumber = value;
      isEdited = true;
    });
    Navigator.pop(context);
  }

  Future updateData() async {
    await ref.read(adminControllerProvider).editUser(widget.user);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future deleteUser() async {
    await ref.read(adminControllerProvider).removeUser(widget.user.uid);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future messageUser(String userId) async {
    ChatRoomModel chatRoomId =
        await ref.read(chatControllerProvider).createOrGetChatRoom(userId);
    if (mounted) {
      Navigator.pushNamed(
        context,
        ChatScreen.routeName,
        arguments: [chatRoomId],
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PROFILE VIEW',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                widget.user.userName,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          widget.user.userAccountType.type == 'patient'
              ? ProfileViewTile(
                  widget: widget,
                  title: widget.user.gender.toString(),
                  iconData: FontAwesomeIcons.user,
                  isEdited: setGender,
                  keyboardType: TextInputType.text,
                )
              : const Text(''),
          ProfileViewTile(
            widget: widget,
            title: widget.user.phoneNumber,
            iconData: Icons.call,
            isEdited: setPhoneNumber,
            keyboardType: TextInputType.number,
          ),
          ProfileViewTile(
            widget: widget,
            title: widget.user.email,
            iconData: Icons.mail,
            isEdited: setEmail,
            keyboardType: TextInputType.text,
          ),
          widget.user.userAccountType.type == 'transporter'
              ? ProfileViewTile(
                  widget: widget,
                  title: widget.user.vehicleNumber!,
                  iconData: FontAwesomeIcons.car,
                  isEdited: setVehicleNumber,
                  keyboardType: TextInputType.text,
                )
              : const Text(''),
          const Spacer(),
          GestureDetector(
            onTap: () => messageUser(widget.user.uid),
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: EColors.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Message User",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Icon(
                      Icons.chat,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          isEdited
              ? GestureDetector(
                  onTap: () => updateData(),
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: EColors.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Confirm Changes",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Icon(
                            Icons.done,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () => deleteUser(),
            child: Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Remove User",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}

class ProfileViewTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function isEdited;
  final TextInputType keyboardType;
  ProfileViewTile({
    super.key,
    required this.widget,
    required this.title,
    required this.iconData,
    required this.keyboardType,
    required this.isEdited,
  });

  final ProfileView widget;
  final TextEditingController newInfo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: EColors.primaryColor,
        size: 30,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      trailing: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Update Info"),
                content: HelperTextField(
                  controller: newInfo,
                  htxt: 'Update',
                  iconData: Icons.add,
                  keyboardType: keyboardType,
                ),
                actions: [
                  TextButton(
                    onPressed: () => isEdited(newInfo.text),
                    child: const Text("Save"),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                ],
              );
            },
          );
        },
        icon: Icon(
          Icons.edit,
          color: EColors.primaryColor,
          size: 30,
        ),
      ),
    );
  }
}
