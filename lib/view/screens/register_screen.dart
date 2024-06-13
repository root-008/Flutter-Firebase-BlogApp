import 'package:blog_app/utils/themes/colors.dart';
import 'package:blog_app/utils/themes/strings.dart';
import 'package:blog_app/view/widgets/login_reg_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final LoginRegisterWidgets widgets = LoginRegisterWidgets();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static TextEditingController email = TextEditingController();
  static TextEditingController pass = TextEditingController();
  static TextEditingController passVerify = TextEditingController();

  @override
  Widget build(BuildContext context) {
    email.text = '';
    pass.text = '';
    passVerify.text = '';
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              UIColor.primaryColor,
              UIColor.fourthColor,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Gap(100),
              widgets.appName(),
              const Gap(50),
              textFields(),
              const Gap(50),
              widgets.signINUPstartButton(context, Strings.register, false,
                  email, pass, passVerify), //isLogin = false
              haveAccount(context),
              const Gap(50),
              socialMediaActions(),
            ],
          ),
        ),
      ),
    ));
  }

  Column textFields() {
    return Column(
      children: [
        widgets.signINUPtextFields(
            email,
            Strings.email,
            Strings.emailToast,
            const Icon(
              Icons.email,
              color: Colors.white,
            )),
        widgets.signINUPtextFields(
            pass,
            Strings.pass,
            Strings.passToast,
            const Icon(
              Icons.password,
              color: Colors.white,
            )),
        widgets.signINUPtextFields(
            passVerify,
            Strings.passVerify,
            Strings.passToast,
            const Icon(
              Icons.verified,
              color: Colors.white,
            )),
      ],
    );
  }

  Column socialMediaActions() {
    return Column(
      children: [
        SignInButton(
          Buttons.facebook,
          onPressed: () {},
          text: 'Facebook ile kayıt olun',
        ),
        const Gap(5),
        SignInButton(
          Buttons.apple,
          onPressed: () {},
          text: 'Apple ile kayıt olun',
        ),
        const Gap(5),
        SignInButton(
          Buttons.twitter,
          onPressed: () {},
          text: 'Twitter ile kayıt olun',
        ),
      ],
    );
  }

  Row haveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          Strings.haveAccount,
          style: TextStyle(color: UIColor.textColorBlack),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text(
              Strings.login,
              style: TextStyle(color: Colors.blue),
            ))
      ],
    );
  }
}
