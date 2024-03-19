import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/admin/screens/prorfile_view.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/utils/drawer.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  static const routeName = '/user-list-screen';
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Stream<List<UserModel>> startSearch(String query) {
    return ref.read(adminControllerProvider).searchUser(query: query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'USERS LIST',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const DrawerSetup(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'Search users...',
                fillColor: EColors.white,
                filled: true,
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: startSearch(_searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final users = snapshot.data ?? [];
                if (users.isEmpty) {
                  return const Center(child: Text('No users found.'));
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return UserTile(
                      uname: user.userName,
                      utype: user.userAccountType.name,
                      users: user,
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final UserModel users;
  final String uname;
  final String utype;

  const UserTile(
      {super.key,
      required this.uname,
      required this.utype,
      required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileView(
                        user: users,
                      )));
        },
        child: Container(
          decoration: BoxDecoration(
              color: const Color(0xff8F9ECA),
              border: Border.all(color: EColors.primaryColor),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      uname,
                      style:
                          const TextStyle(fontSize: 20, color: EColors.white),
                    ),
                    Text(
                      "Account Type: $utype",
                      style:
                          const TextStyle(fontSize: 20, color: EColors.white),
                    )
                  ],
                ),
                const Icon(
                  Icons.forward_outlined,
                  color: EColors.white,
                  size: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
