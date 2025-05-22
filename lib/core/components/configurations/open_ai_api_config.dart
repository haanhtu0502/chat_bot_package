class ChatBotConfig {
  static final ChatBotConfig _instance = ChatBotConfig._internal();

  ChatBotConfig._internal();

  factory ChatBotConfig() => _instance;

  late String _apiKey;
  late String _assistantId;
  String _model = "gpt-4o-mini";
  String _turboModel = "gpt-3.5-turbo";

  bool _isStreamResponse = false; // This option don't support for web platform

  /// Run text display
  bool _isRunTextDisplay = false;
  int _durations = 10;

  void setConfig({
    required String apiKey,
    required String assistantId,
    bool isStreamResponse = false,
    String? model,
    String? turboModel,
    bool runTextDisplay = false,
    int durations = 10,
  }) {
    _apiKey = apiKey;
    _assistantId = assistantId;
    _isStreamResponse = isStreamResponse;
    _isRunTextDisplay = runTextDisplay;
    _durations = durations;
    if (model != null) _model = model;
    if (turboModel != null) _turboModel = turboModel;
  }

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  // getter
  int get getDurations => _durations;
  bool get isRunTextDisplay => _isRunTextDisplay;
  bool get isStreamResponse => _isStreamResponse;
  String get getApiKey => _apiKey;
  String get getAssistantId => _assistantId;
  String get getModel => _model;
  String get getTurboModel => _turboModel;
}
