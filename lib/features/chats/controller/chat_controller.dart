import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicare/features/chats/repository/chat_repository.dart';
import 'package:medicare/models/chat_room_model.dart';
import 'package:medicare/models/message_model.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository);
});

class ChatController {
  ChatController({required this.chatRepository});
  ChatRepository chatRepository;

  Future<ChatRoomModel> createOrGetChatRoom(String userId2) async {
    return chatRepository.createOrGetChatRoom(userId2);
  }

  Stream<List<ChatRoomModel>> getUserChatRooms() {
    return chatRepository.getUserChatRooms();
  }

  Future<void> sendMessage(String chatRoomId, MessageModel message) async {
    chatRepository.sendMessage(chatRoomId, message);
  }

  Stream<List<MessageModel>> getChatMessage(String chatRoomId) {
    return chatRepository.getChatMessages(chatRoomId);
  }
}
