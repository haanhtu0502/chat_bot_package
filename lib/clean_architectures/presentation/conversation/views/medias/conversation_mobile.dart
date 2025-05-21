import 'package:chat_bot_package/app_coordinator.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/conversation/conversation.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/bloc/conversation_bloc.dart';
import 'package:chat_bot_package/clean_architectures/presentation/conversation/views/widgets/conversation_item_widget.dart';
import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:chat_bot_package/core/components/widgets/button_custom.dart';
import 'package:chat_bot_package/core/components/widgets/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationMobile extends StatefulWidget {
  final ConversationState state;

  const ConversationMobile({super.key, required this.state});

  @override
  State<ConversationMobile> createState() => _ConversationMobileState();
}

class _ConversationMobileState extends State<ConversationMobile> {
  ConversationBloc get _bloc => context.read<ConversationBloc>();

  Color get _backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  Color get _primaryColor => Theme.of(context).primaryColor;

  List<Conversation> get _conversations => widget.state.data.conversations;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _body(context: context, state: widget.state),
        if (widget.state.loading)
          Container(
            color: Colors.black45,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: StyleLoadingWidget.foldingCube.renderWidget(
                  size: 40.0, color: Theme.of(context).primaryColor),
            ),
          )
      ],
    );
  }

  Widget _body(
      {required BuildContext context, required ConversationState state}) {
    return Scaffold(
      extendBody: true,
      backgroundColor: _backgroundColor,
      bottomNavigationBar: _bottomNavigationField(context),
      appBar: AppBar(
        backgroundColor: _primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          "Conversation",
          style: context.titleMedium
              .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.key, color: Colors.white),
          )
        ],
      ),
      body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 15.0, bottom: 80.0),
          itemCount: _conversations.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10.0),
          itemBuilder: (_, index) {
            final conversation = _conversations[index];
            return ConversationItemWidget(
              conversation: conversation,
              onDelete: () => _bloc.add(
                ConversationEvent.deleteConversation(
                    conversationId: conversation.id),
              ),
              onSelectConversation: () => _bloc.add(
                ConversationEvent.selectConversation(
                    conversationId: conversation.id),
              ),
            );
          }),
    );
  }

  Widget _bottomNavigationField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ButtonCustom(
        onPress: () => _bloc.add(const ConversationEvent.createConversation()),
        height: 45.0,
        radius: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: Colors.white, size: 18.0),
            Text(
              " New chat",
              style: context.titleSmall
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
