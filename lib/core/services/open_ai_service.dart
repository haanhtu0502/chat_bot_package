import 'package:chat_bot_package/clean_architectures/data/data_source/remote/gpt_api.dart';
import 'package:chat_bot_package/clean_architectures/domain/entities/chat/chat_type.dart';
import 'package:chat_bot_package/core/components/configurations/configurations.dart';
import 'package:chat_bot_package/core/dependency_injection/di.dart';
import 'package:chat_bot_package/core/services/stream/stream_api_service.dart';
import 'package:flutter/widgets.dart';

import '../../clean_architectures/data/data_source/remote/utils/data_state.dart';
import '../components/helpers/api_call_helper.dart';

class ChatBotUiData {
  final bool isLoading;

  final bool isStreamWorking;

  ChatBotUiData({
    required this.isLoading,
    required this.isStreamWorking,
  });

  factory ChatBotUiData.initial() {
    return ChatBotUiData(
      isLoading: false,
      isStreamWorking: false,
    );
  }

  ChatBotUiData copyWith({
    bool? isLoading,
    bool? isStreamWorking,
  }) {
    return ChatBotUiData(
      isLoading: isLoading ?? this.isLoading,
      isStreamWorking: isStreamWorking ?? this.isStreamWorking,
    );
  }

  ///Set loading state
  ChatBotUiData setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  ///Set stream working state
  ChatBotUiData setStreamWorking(bool working) {
    return copyWith(isStreamWorking: working);
  }
}

/// A mixin to integrate OpenAI Assistant streaming message service into a `StatefulWidget`.
/// Handles message sending, response streaming, and loading state management.
mixin OpenAiService<T extends StatefulWidget> on State<T> {
  /// The thread ID used to maintain conversation context.
  String get threadId;

  /// The assistant ID for identifying the specific OpenAI assistant.
  String get assistantId;

  /// The OpenAI API key used for authentication.
  String get apiKey;

  /// Notifies listeners with the streamed text response from OpenAI.
  final ValueNotifier<ChatBotUiData> _chatBotData =
      ValueNotifier<ChatBotUiData>(ChatBotUiData.initial());

  final ValueNotifier<String> textResponse = ValueNotifier<String>("");

  bool get isStreamWorking => _chatBotData.value.isStreamWorking;

  /// Internal stream service that manages SSE (Server-Sent Events) from OpenAI.
  late final StreamApiService<String> _streamApiService;

  /// Retrieves the GPT API instance from the dependency injector.
  GPTApi get _gptApi => injector.get<GPTApi>();

  /// Called when new data is received from the stream.
  /// Updates the UI with incoming content and turns off the loading state.
  void _onListenDataChange(String data) {
    print("✨ Data: $data");
    textResponse.value += data;
    _chatBotData.value = _chatBotData.value.setLoading(false);
  }

  void _onDone() async {
    final getLastMessageQueries = <String, dynamic>{"limit": 1};
    final response =
        await _gptApi.threadMessages(threadId, getLastMessageQueries);
    if (response is DataFailed) {
      return;
    }
    final lastMessage = response.data?.data?.first;
    if (lastMessage != null) {
      sendChatCompleted(lastMessage.content, lastMessage.id);
    }
    _chatBotData.value = _chatBotData.value.setStreamWorking(false);
  }

  void sendChatCompleted(String? newContent, String? chatId);

  /// Initializes the streaming service with the correct configuration and data mapping.
  /// Sets up headers and defines how to extract text from the SSE delta payload.
  void initService() {
    _streamApiService = StreamApiService<String>(
      url: "/threads/$threadId/runs",
      eventGet: 'delta',
      onListenDataChange: _onListenDataChange,
      onDone: _onDone,
      configDio: ConfigDio(
        baseUrl: Configurations.baseUrl,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Accept": "*/*",
          "Openai-beta": "assistants=v2",
          "Content-Type": "application/json",
        },
      ),
      mappingData: (data) {
        var result = "";
        final contents = data["delta"]?["content"];
        if (contents is! List) {
          return "";
        }
        for (var element in contents) {
          final text = element["text"]?["value"];
          if (text is String) {
            result += text;
          }
        }
        return result;
      },
    );
  }

  /// Sends a message to the OpenAI assistant using the thread ID.
  /// Returns true if the request was successful, false otherwise.
  Future<bool> _messagesApi(String message) async {
    final body = {
      "role": ChatType.user.toTypeString,
      "content": [
        {"type": "text", "text": message}
      ]
    };

    final response = await ApiCallHelper.getStateOf(
      request: () async => await _gptApi.sendThreadMessage(threadId, body),
    );

    return response is! DataFailed;
  }

  /// Public method to send a message and handle the OpenAI streaming response.
  /// If the message is sent successfully, it triggers the stream listener.
  void onSendMessage(String message) async {
    if (_chatBotData.value.isStreamWorking) return;
    _chatBotData.value = _chatBotData.value.copyWith(
      isLoading: true,
      isStreamWorking: true,
    );
    textResponse.value = "";

    final result = await _messagesApi(message);

    if (result) {
      _streamApiService.onPostStream(
        queryParameters: {"stream": true, "assistant_id": assistantId},
      );
    } else {
      _chatBotData.value = _chatBotData.value.copyWith(
        isLoading: false,
        isStreamWorking: false,
      );
    }
  }

  /// Build widget
  Widget buildTextResponseWidget(Widget Function(bool, bool) child) {
    return ValueListenableBuilder<ChatBotUiData>(
      valueListenable: _chatBotData,
      builder: (context, data, _) {
        return child(data.isLoading, data.isStreamWorking);
      },
    );
  }
}
