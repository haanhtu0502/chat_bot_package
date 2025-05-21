class ChatBotConfig {
  static final ChatBotConfig _instance = ChatBotConfig._internal();

  ChatBotConfig._internal();

  factory ChatBotConfig() => _instance;

  late String _apiKey;
  late String _assistantId;
  String _model = "gpt-4o-mini";
  String _turboModel = "gpt-3.5-turbo";

  bool _isStreamResponse = false;

  void setConfig({
    required String apiKey,
    required String assistantId,
    bool isStreamResponse = false,
    String? model,
    String? turboModel,
  }) {
    _apiKey = apiKey;
    _assistantId = assistantId;
    _isStreamResponse = isStreamResponse;
    if (model != null) _model = model;
    if (turboModel != null) _turboModel = turboModel;
  }

  // getter
  bool get isStreamResponse => _isStreamResponse;
  String get getApiKey => _apiKey;
  String get getAssistantId => _assistantId;
  String get getModel => _model;
  String get getTurboModel => _turboModel;
}
