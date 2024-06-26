import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/admin/controller/admin_controller.dart';
import 'package:medicare/features/admin/screens/users_list.dart';
import 'package:medicare/models/user_model.dart';
import 'package:medicare/shared/enums/accounts.dart';

class AccountTypeListScreen extends ConsumerStatefulWidget {
  static const routeName = '/account-type-list-screen';
  final AccountType accountType;
  const AccountTypeListScreen({super.key, required this.accountType});

  @override
  ConsumerState<AccountTypeListScreen> createState() =>
      _PatientsListScreenState();
}

class _PatientsListScreenState extends ConsumerState<AccountTypeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.accountType.name.toUpperCase()} LIST',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: ref
                  .read(adminControllerProvider)
                  .getAllAccountTypeList(widget.accountType),
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
                      user: user,
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
