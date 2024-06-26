import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/chats/controller/chat_controller.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/models/message_model.dart';
import 'package:medicare/shared/constants/colors.dart';
import 'package:medicare/shared/loading.dart';
import 'package:medicare/shared/utils/helper_textfield.dart';

class ChatScreen extends ConsumerStatefulWidget {
  static const routeName = '/chat-screen';
  final ChatRoomModel chatRoom;
  const ChatScreen({
    super.key,
    required this.chatRoom,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _msgController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _msgController.dispose();
  }

  Future sendMessage() async {
    final message = MessageModel(
      senderId: FirebaseAuth.instance.currentUser!.uid,
      text: _msgController.text,
      timestamp: DateTime.now(),
    );
    _msgController.clear();
    await ref
        .read(chatControllerProvider)
        .sendMessage(widget.chatRoom.roomId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: EColors.primaryColor,
        title: Text(
          widget.chatRoom.otherMemberName,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          StreamBuilder<List<MessageModel>>(
            stream: ref
                .read(chatControllerProvider)
                .getChatMessage(widget.chatRoom.roomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (snapshot.hasError) {
                return Text(
                    'Error: ${snapshot.error}'); // Show an error message
              } else {
                List<MessageModel> messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No Messages'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      if (message.senderId ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        return SentMsgTile(msg: message.text);
                      } else {
                        return ReceivedMsgTile(msg: message.text);
                      }
                    },
                  ),
                );
              }
            },
          ),
          Row(
            children: [
              Expanded(
                child: HelperTextField(
                    htxt: "Enter Message",
                    iconData: Icons.chat,
                    controller: _msgController,
                    keyboardType: TextInputType.text),
              ),
              GestureDetector(
                onTap: () => sendMessage(),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 204, 17, 4),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class ReceivedMsgTile extends StatelessWidget {
  final String msg;
  const ReceivedMsgTile({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 141, 180, 238),
                borderRadius: BorderRadius.circular(25)),
            child: Text(
              msg,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }
}

class SentMsgTile extends StatelessWidget {
  final String msg;
  const SentMsgTile({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              msg,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }
}
