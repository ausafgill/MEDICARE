import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';

class ProfileView extends StatefulWidget {
  final UserModel user;
  const ProfileView({super.key, required this.user});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  TextEditingController newInfo = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newInfo.dispose();
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
                '${widget.user.userName}',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          widget.user.userAccountType.type == 'patient'
              ? ProfileViewTile(
                  widget: widget,
                  title: widget.user.gender.toString(),
                  iconData: FontAwesomeIcons.user)
              : Text(''),
          ProfileViewTile(
            widget: widget,
            title: widget.user.phoneNumber,
            iconData: Icons.call,
          ),
          ProfileViewTile(
              widget: widget, title: widget.user.email, iconData: Icons.mail),
          widget.user.userAccountType.type == 'transporter'
              ? ProfileViewTile(
                  widget: widget,
                  title: widget.user.vehicleNumber.toString(),
                  iconData: FontAwesomeIcons.car)
              : Text(''),
          Spacer(),
          GestureDetector(
            onTap: () {},
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
          GestureDetector(
            onTap: () {},
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
  ProfileViewTile(
      {super.key,
      required this.widget,
      required this.title,
      required this.iconData});

  final ProfileView widget;
  TextEditingController newInfo = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose

    newInfo.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        iconData,
        color: EColors.primaryColor,
        size: 30,
      ),
      title: Text(
        '${title}',
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
                    keyboardType: TextInputType.number,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {},
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
          )),
    );
  }
}
