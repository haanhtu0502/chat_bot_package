import 'package:chat_bot_package/app_coordinator.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:chat_bot_package/core/components/constant/handle_time.dart';
import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:chat_bot_package/core/components/extensions/string_extensions.dart';
import 'package:chat_bot_package/core/components/widgets/button_custom.dart';
import 'package:chat_bot_package/core/design_systems/theme_colors.dart';
import 'package:chat_bot_package/core/services/history_chat_service.dart';
import 'package:chat_bot_package/localization/chat_bot_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConverationWeb extends StatefulWidget {
  final ConversationState state;
  const ConverationWeb({super.key, required this.state});

  @override
  State<ConverationWeb> createState() => ConverationWebState();
}

class ConverationWebState extends State<ConverationWeb> {
  ConversationBloc get _bloc => context.read<ConversationBloc>();

  List<Conversation> get _conversations => widget.state.data.conversations;
  List<Conversation> get _selectedConversations =>
      widget.state.data.selectedConversations;
  int? get _currentConversationId => widget.state.data.currentConversationId;

  @override
  void initState() {
    super.initState();
    ChatBotLocalizations.loadTranslations().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              ChatBotLocalizations.of(context, "history"),
              style: context.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.brightBlue.toColor(),
              ),
            ),
            // Container(
            //   padding:
            //       const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.0),
            //     color: "#e8ecef".toColor(),
            //   ),
            //   child: Text(
            //     "${_conversations.length}/100",
            //     style: context.titleSmall,
            //   ),
            // ),
          ],
        ),
        const SizedBox(height: 16.0),
        _buildListConversation(context),
        ButtonCustom(
          width: double.infinity,
          color: AppColors.brightBlue.toColor(),
          height: 45.0,
          onPress: () =>
              _bloc.add(const ConversationEvent.createConversation()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 18.0),
              Text(
                " ${ChatBotLocalizations.of(context, "newChat")}",
                style: context.titleSmall
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListConversation(BuildContext context) {
    HistoryChatService chatService = HistoryChatService();
    final historyChatToday = chatService.getTodayThreads(_conversations);
    final historyChat7Days =
        chatService.getThreadsBeforeTodayInLastDays(_conversations, 7);
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ChatBotLocalizations.of(context, "today"),
                  style: context.titleMedium.copyWith(
                    color: AppColors.brightBlue.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...historyChatToday.map(
              (e) => BuildConversationItem(
                chatContent: e.title.isEmpty
                    ? ChatBotLocalizations.of(context, "youHaveNoMessage")
                    : e.title,
                isSelected: e.id == _currentConversationId,
                onLongPress: () async {
                  final show = await context.showAlertDialog(
                    header:
                        ChatBotLocalizations.of(context, "deleteConversation"),
                    content: ChatBotLocalizations.of(
                        context, "confirmDeleteConversation"),
                  );
                  if (show) {
                    _bloc.add(ConversationEvent.deleteConversation(
                        conversationId: e.id));
                  }
                },
                onTap: (value) {
                  _bloc.add(
                    ConversationEvent.selectConversation(
                      conversationId: e.id,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  ChatBotLocalizations.of(context, "last7Days"),
                  style: context.titleMedium.copyWith(
                    color: AppColors.brightBlue.toColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
            const SizedBox(height: 6),
            ...historyChat7Days.map(
              (e) => BuildConversationItem(
                chatContent: e.title.isEmpty
                    ? ChatBotLocalizations.of(context, "youHaveNoMessage")
                    : e.title,
                isSelected: e.id == _currentConversationId,
                onLongPress: () async {
                  final show = await context.showAlertDialog(
                    header:
                        ChatBotLocalizations.of(context, "deleteConversation"),
                    content: ChatBotLocalizations.of(
                        context, "confirmDeleteConversation"),
                  );
                  if (show) {
                    _bloc.add(ConversationEvent.deleteConversation(
                        conversationId: e.id));
                  }
                },
                onTap: (value) {
                  _bloc.add(
                    ConversationEvent.selectConversation(
                      conversationId: e.id,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _conversationItem(Conversation conversation, BuildContext context) {
    return InkWell(
      onTap: () => _bloc.add(
        ConversationEvent.selectConversation(conversationId: conversation.id),
      ),
      onLongPress: () async {
        final show = await context.showAlertDialog(
            header: "Delete conversation",
            content: "Do you want delete this conversation");
        if (show) {
          _bloc.add(ConversationEvent.deleteConversation(
              conversationId: conversation.id));
        }
      },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: "#ebeff1".toColor(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
                value: _selectedConversations
                    .any((element) => element.id == conversation.id),
                activeColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(4.0)),
                onChanged: (_) => _bloc.add(
                    ConversationEvent.updateSelectedConversation(
                        conversation: conversation))),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.header,
                    style: context.titleMedium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    conversation.lastMessage ?? "You have no message",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.titleSmall.copyWith(),
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          getjmFormat(conversation.lastUpdate ??
                              conversation.createdAt),
                          textAlign: TextAlign.end,
                          style: context.titleSmall.copyWith(
                              fontSize: 11.0,
                              color: Theme.of(context).hintColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildConversationItem extends StatefulWidget {
  const BuildConversationItem({
    super.key,
    required this.chatContent,
    this.isSelected = false,
    required this.onTap,
    this.onLongPress,
  });

  final String chatContent;
  final bool isSelected;
  final void Function(String) onTap;
  final void Function()? onLongPress;

  @override
  State<BuildConversationItem> createState() => _BuildConversationItemState();
}

class _BuildConversationItemState extends State<BuildConversationItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap(widget.chatContent);
      },
      onLongPress: widget.onLongPress,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.isSelected
              ? AppColors.brightBlue.toColor().withOpacity(0.4)
              : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                widget.chatContent,
                maxLines: 2,
                style: context.titleMedium.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.end,
              ),
            )
          ],
        ),
      ),
    );
  }
}
