import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicare/features/chats/controller/chat_controller.dart';
import 'package:medicare/features/chats/screens/chat_screen.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/shared/loading.dart';

class MessageScreen extends ConsumerStatefulWidget {
  static const routeName = '/message-screen';
  const MessageScreen({super.key});

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("MESSAGES", style: Theme.of(context).textTheme.headlineMedium),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: ref.read(chatControllerProvider).getUserChatRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<ChatRoomModel> chats = snapshot.data!;
            if (chats.isEmpty) {
              return const Center(
                child: Text('No Messages'),
              );
            }
            return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    chat: chats[index],
                  );
                });
          }
        },
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final ChatRoomModel chat;

  const MessageTile({super.key, required this.chat});

  openChat(BuildContext context) {
    Navigator.pushNamed(context, ChatScreen.routeName, arguments: [chat]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openChat(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: Colors.black)),
        child: ListTile(
          title: Text(
            chat.otherMemberName,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              chat.lastMessage ?? "New Chat",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          trailing: const Icon(FontAwesomeIcons.checkDouble),
        ),
      ),
    );
  }
}
