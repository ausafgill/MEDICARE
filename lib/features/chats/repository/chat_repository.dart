import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/models/message_model.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository());

class ChatRepository {
  Future<ChatRoomModel> createOrGetChatRoom(String userId2) async {
    String userId1 = FirebaseAuth.instance.currentUser!.uid;
    String chatRoomId = constructChatRoomId(userId1, userId2);

    final chatRoomSnapshot = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .get();
    if (!chatRoomSnapshot.exists) {
      await FirebaseFirestore.instance.collection('chats').doc(chatRoomId).set({
        'chatRoomId': chatRoomId,
        'members': [userId1, userId2],
        'lastMessage': null,
        'timestamp': DateTime.now().toIso8601String(),
      });
    }

    String? otherUserName = await getUserName(userId2);
    return ChatRoomModel(
      roomId: chatRoomId,
      memberIds: [userId1, userId2],
      lastMessage: null,
      otherMemberName: otherUserName!,
      timestamp: DateTime.now(),
    );
  }

  Stream<List<ChatRoomModel>> getUserChatRooms() {
    final StreamController<List<ChatRoomModel>> controller =
        StreamController<List<ChatRoomModel>>();
    String userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) async {
      List<ChatRoomModel> chatRooms = [];

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        String otherId;
        if (data['members'][0] == userId) {
          otherId = data['members'][1];
        } else {
          otherId = data['members'][0];
        }

        String? otherUserName = await getUserName(otherId);

        if (otherUserName != null) {
          ChatRoomModel room = ChatRoomModel(
            roomId: data['chatRoomId'],
            memberIds: List<String>.from(data['members']),
            lastMessage: data['lastMessage'],
            otherMemberName: otherUserName!,
            timestamp: DateTime.parse(data['timestamp']),
          );

          chatRooms.add(room);
        }
      }

      controller.add(chatRooms);
    }, onError: (error) {
      controller.addError(error);
    });

    return controller.stream;
  }

  Future<String?> getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['userName'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  String constructChatRoomId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  Future<void> sendMessage(String chatRoomId, MessageModel message) async {
    try {
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .update({
        'timestamp': DateTime.now().toIso8601String(),
        'lastMessage': message.text,
      });
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<MessageModel>> getChatMessages(String chatRoomId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
