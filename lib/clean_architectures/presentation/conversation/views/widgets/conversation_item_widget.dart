import 'package:chat_bot_package/app_coordinator.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/core/components/constant/handle_time.dart';
import 'package:chat_bot_package/core/components/constant/image_const.dart';
import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class ConversationItemWidget extends StatelessWidget {
  final Conversation conversation;
  final Function onDelete;
  final Function onSelectConversation;
  const ConversationItemWidget({
    super.key,
    required this.conversation,
    required this.onDelete,
    required this.onSelectConversation,
  });

  @override
  Widget build(BuildContext context) {
    final smallStyle = context.titleSmall
        .copyWith(fontSize: 11.0, color: Theme.of(context).hintColor);
    return GestureDetector(
      onLongPress: () async {
        final show = await context.showAlertDialog(
            header: "Delete conversation",
            content: "Do you want delete this conversation");
        if (show) {
          onDelete.call();
        }
      },
      onTap: () => onSelectConversation.call(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Theme.of(context).primaryColorLight,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(ImageConst.appIcon, width: 30.0, height: 30.0),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                              "${conversation.header} ${conversation.id}",
                              style: smallStyle)),
                      Text(
                        getjmFormat(
                            conversation.lastUpdate ?? conversation.createdAt),
                        style: smallStyle,
                      ),
                    ],
                  ),
                  Text(
                    conversation.title,
                    style: context.titleSmall
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    conversation.lastMessage ?? "You don't have message",
                    style: smallStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ].expand((e) => [e, const SizedBox(height: 2.0)]).toList()
                  ..removeLast(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
