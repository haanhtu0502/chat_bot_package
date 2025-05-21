import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';

class HistoryChatService {
  HistoryChatService();

  List<Conversation> getTodayThreads(List<Conversation> conversations) {
    final now = DateTime.now();

    return conversations
        .where(
            (t) => t.createdAt.day == now.day && t.createdAt.month == now.month)
        .toList();
  }

  List<Conversation> getThreadsBeforeTodayInLastDays(
      List<Conversation> conversations, int days) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // 00:00 hôm nay
    final startDate = today.subtract(Duration(days: days));

    return conversations.where((t) {
      return t.createdAt.isAfter(startDate) && t.createdAt.isBefore(today);
    }).toList();
  }
}
