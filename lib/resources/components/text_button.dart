import 'package:flutter/material.dart';
import 'package:example/resources/colors.dart';
import 'package:example/resources/text_constants.dart';

class TextButtonWidget extends StatelessWidget {
  final String title;
  final String onPressTitle;
  final VoidCallback onPress;
  final TextStyle textThemeStyle;
  const TextButtonWidget({
    super.key,
    this.title = '',
    required this.onPress,
    required this.textThemeStyle,
    required this.onPressTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: textTheme.titleSmall,
        ),
        TextButton(
            onPressed: onPress,
            style: const ButtonStyle(
                overlayColor: MaterialStatePropertyAll(AppColors.kWhiteColor)),
            child: Text(
              onPressTitle,
              style: textThemeStyle,
            )),
      ],
    );
  }
}
