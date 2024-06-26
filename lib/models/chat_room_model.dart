class ChatRoomModel {
  final String roomId;
  final List<String> memberIds;
  final String? lastMessage;
  final String otherMemberName;
  final DateTime timestamp;

  ChatRoomModel({
    required this.roomId,
    required this.memberIds,
    required this.lastMessage,
    required this.otherMemberName,
    required this.timestamp,
  });
}
