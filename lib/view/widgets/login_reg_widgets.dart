// ignore_for_file: use_build_context_synchronously

import 'package:blog_app/services/auth_service.dart';
import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/utils/themes/strings.dart';
import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';

class LoginRegisterWidgets {
  Text appName() {
    return const Text(
      Strings.appName,
      style: TextStyle(
          color: UIColor.fourthColor, fontSize: 45, fontFamily: 'Poppins'),
    );
  }

  Padding signINUPstartButton(
      BuildContext context,
      String btnLabel,
      bool isLogin,
      TextEditingController email,
      TextEditingController pass,
      TextEditingController? passVerify) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: PushableButton(
        hslColor: HSLColor.fromColor(UIColor.thirdColor),
        height: 50,
        elevation: 8,
        shadow: BoxShadow(
          color: UIColor.thirdColor.withOpacity(0.7),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 4),
        ),
        onPressed: () async {
          if (isLogin) {
            //do login
            final message = await AuthService().login(
              email: email.text,
              password: pass.text,
            );
            if (message!.contains('Success')) {
              Navigator.of(context).pushReplacementNamed('/home');
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          } else {
            //do register
            if (pass.text == passVerify!.text) {
              final message = await AuthService().registration(
                email: email.text,
                password: pass.text,
              );
              if (message!.contains('Success')) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Parola doğrulama başarısız.')));
            }
          }
        },
        child: Text(
          btnLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: UIColor.textColorWhite,
              //fontFamily: 'Poppins',
              fontSize: 24,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
              height: 1),
        ),
      ),
    );
  }

  Padding signINUPtextFields(TextEditingController controller, String label,
      String toastMessage, Icon icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        obscureText: label == 'Parola' || label == 'Parolanızı Doğrulayınız'
            ? true
            : false,
        decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.white,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                color: UIColor.fourthColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.white, width: 2)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(color: Colors.red, width: 2)),
            icon: icon),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return toastMessage;
          } else {
            return null;
          }
        },
      ),
    );
  }
}
