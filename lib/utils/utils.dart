import 'package:example/resources/colors.dart';
import 'package:example/resources/text_constants.dart';
import 'package:flutter/material.dart';

class Utils {
  static void focusNodeChange(
      BuildContext context, FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  static void successMessage(context, data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        data,
        style: textTheme.bodySmall!.copyWith(color: AppColors.kWhiteColor),
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
    ));
  }

  static void errorMessage(context, data) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(data,
          style: textTheme.bodySmall!.copyWith(color: AppColors.kWhiteColor)),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 1),
      // animation: ,
    ));
  }
}
