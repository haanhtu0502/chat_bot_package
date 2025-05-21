import 'package:flutter/material.dart';

import 'stream_api_service.dart';
import 'stream_mixin.dart';

class StreamExample extends StatefulWidget {
  const StreamExample({super.key});

  @override
  State<StreamExample> createState() => _StreamExampleState();
}

class _StreamExampleState extends State<StreamExample> with StreamMixin {
  late final StreamApiService<String> _streamApiService;

  final ValueNotifier<String> _textResposne = ValueNotifier<String>("");

  @override
  void initState() {
    super.initState();
    _streamApiService = StreamApiService<String>(
      url: "/threads/thread_id/runs",
      queryParameters: {
        "stream": true,
        "assistant_id": "assistant-1",
      },
      configDio: ConfigDio(
        baseUrl: "https://api.openai.com/v1",
        headers: {
          "Authorization": "Bearer apiKey",
          "Accept": "*/*",
          "Openai-beta": "assistants=v2",
          "Content-Type": "application/json",
        },
      ),
      eventGet: 'delta',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _textResposne.value = "";
                _streamApiService.onPostStream();
              },
              child: const Text("Start Stream"),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: _textResposne,
              builder: (context, value, child) {
                return Text(
                  value,
                  style: const TextStyle(fontSize: 20),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  void onListenDataChange(dynamic data) {
    // Handle the data received from the stream
    // For example, you can update the UI or perform some action with the data
    _textResposne.value += data;
  }

  @override
  void onDone() {
    // Handle the completion of the stream
    // For example, you can show a message or perform some cleanup
    debugPrint("Stream completed");
  }
}
