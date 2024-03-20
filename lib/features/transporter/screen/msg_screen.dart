import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/transporter/screen/transporter_drawer.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("MESSAGES", style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      drawer: const TransporterDrawer(),
      body: Column(
        children: [
          MessageTile(
            name: 'Pharmacy1',
            msg: 'When will you come',
          ),
          MessageTile(
            name: 'Pharmacy1',
            msg: 'When will you come',
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String name;
  final String msg;

  const MessageTile({super.key, required this.name, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: ListTile(
        title: Text(
          "$name",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '$msg',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        trailing: const Icon(FontAwesomeIcons.checkDouble),
      ),
    );
  }
}
