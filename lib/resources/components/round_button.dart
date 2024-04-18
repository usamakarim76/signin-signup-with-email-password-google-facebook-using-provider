import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:example/resources/colors.dart';
import 'package:example/resources/text_constants.dart';

class LoginSignUpButton extends StatelessWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  const LoginSignUpButton(
      {super.key,
      required this.title,
      this.loading = false,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      overlayColor: const MaterialStatePropertyAll(AppColors.kWhiteColor),
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
            color: AppColors.kPrimaryColor,
            borderRadius: BorderRadius.circular(30.r)),
        child: Center(
          child: loading ? loadingWidget(AppColors.kWhiteColor) : Text(
            title,
            style:
                textTheme.titleMedium!.copyWith(color: AppColors.kWhiteColor),
          ),
        ),
      ),
    );
  }
}

Widget loadingWidget(Color color) {
  return CupertinoActivityIndicator(
    color: color,
    radius: 15,
  );
}
