import 'package:chat_bot_package/core/components/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:chat_bot_package/core/components/constant/constant.dart';

import 'core/components/widgets/advanced_mobile_gpt/bottom_api_warning.dart';

extension AppCoordinator<T> on BuildContext {
  void pop() => Navigator.of(this).pop();

  void popUntil(String nRoute) =>
      Navigator.popUntil(this, ModalRoute.withName(nRoute));
  void popArgs(T? args) => Navigator.of(this).pop(args);
  Future<DateTime?> pickDateTime() async {
    DateTime? date = (await pickDate(DatePickerMode.day));
    if (date == null) {
      return null;
    }
    TimeOfDay? time = await pickTime();
    if (time == null) {
      return null;
    }
    return date.copyWith(hour: time.hour, minute: time.minute);
  }

  void showSnackBar(String title) {
    final snackBar = SnackBar(
      content: Text(
        title,
        style: titleSmall.copyWith(fontWeight: FontWeight.w500),
      ),
      backgroundColor: Theme.of(this).cardColor,
    );

    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: this,
        initialTime: TimeOfDay(
          hour: Constant.timeNow.hour,
          minute: Constant.timeNow.minute,
        ),
      );

  Future<bool> showAlertDialog(
      {required String header, required String content}) async {
    Widget cancelButton = TextButton(
      child: Text("Cancel",
          style: titleMedium.copyWith(
              fontWeight: FontWeight.w500, color: Theme.of(this).primaryColor)),
      onPressed: () => this.popArgs(false),
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: titleMedium.copyWith(
            fontWeight: FontWeight.w500, color: Theme.of(this).primaryColor),
      ),
      onPressed: () => this.popArgs(true),
    );
    final show = await showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text(
            header,
            style: titleMedium.copyWith(fontWeight: FontWeight.bold),
          ),
          content: Text(content, style: titleSmall),
          actions: [
            cancelButton,
            continueButton,
          ],
        );
      },
    );
    if (show is bool) {
      return show;
    }
    return false;
  }

  Future<DateTime?> pickDate(DatePickerMode mode) => showDatePicker(
        initialDatePickerMode: mode,
        context: this,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );

  Future<void> apiKeyWarning() async {
    await showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      backgroundColor: Theme.of(this).scaffoldBackgroundColor,
      builder: (context) => const BottomApiWarning(),
    );
  }

  void closeErrorMessage() {
    ScaffoldMessenger.of(this).hideCurrentMaterialBanner();
  }

  Future<T?> openListPageWithRoute(String route) {
    return Navigator.of(this).pushNamed(route);
  }

  Future<T?> pushAndRemoveAll(String route) {
    return Navigator.of(this).pushNamedAndRemoveUntil(route, (route) => false);
  }

  Future<T?> openPageWithRouteAndParams(String route, dynamic param) {
    return Navigator.of(this).pushNamed(route, arguments: param);
  }
}
