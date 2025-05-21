import 'package:chat_bot_package/app_coordinator.dart';
import 'package:chat_bot_package/clean_architectures/data/data_source/local/preferences.dart';
import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:chat_bot_package/core/components/widgets/button_custom.dart';
import 'package:flutter/material.dart';

class BottomApiWarning extends StatelessWidget {
  const BottomApiWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.titleSmall.copyWith(fontSize: 12.0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Theme.of(context).dividerColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30.0),
        Text("You need to input an open ai key to use this feature",
            style: textStyle),
        const SizedBox(height: 15.0),
        ButtonCustom(
          height: 40.0,
          radius: 5.0,
          onPress: () async {
            // await context.openListPageWithRoute(Routes.inputApi);
            if (CommonAppSettingPref.getAccessToken().isNotEmpty) {
              // ignore: use_build_context_synchronously
              context.pop();
            }
          },
          child: Text("Input api key",
              style: textStyle.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10.0),
        ButtonCustom(
          height: 40.0,
          radius: 5.0,
          color: Theme.of(context).scaffoldBackgroundColor,
          borderColor: Theme.of(context).primaryColor,
          onPress: () => context.pop(),
          child: Text("Close",
              style: textStyle.copyWith(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 15.0),
      ]
          .expand(
            (element) => [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: element,
              )
            ],
          )
          .toList(),
    );
  }
}
