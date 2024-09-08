enum Role { ai, user, system }

class ChatMessage {
  Role role;
  String content;

  ChatMessage(this.role, this.content);
}
