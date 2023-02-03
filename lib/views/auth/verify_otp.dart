import 'package:tourist_app/views/auth/sign_in_screen.dart';
import 'package:tourist_app/views/home/home_page.dart';

import '/data/network/data_response.dart';
import '/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/views/auth/sign_up_screen.dart';
import '/views/shared/button_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import '/views/shared/text_field_widget.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({Key? key, required this.isSignUp}) : super(key: key);
  final bool isSignUp;
  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    controllers = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ];
    super.initState();
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "Verification code "),
          Expanded(
              child: ListView(
            children: [
              SizedBox(
                  height: 200,
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please enter the verification code sent for the email:\n\n user-email"
                            .replaceAll(
                                RegExp(r'user-email'),
                                Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .user
                                        ?.email ??
                                    ""),
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 17),
                        textAlign: TextAlign.center,
                      ))),
              const SizedBox(height: SharedValues.padding),
              Row(
                children: [
                  for (var controller in controllers)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(SharedValues.padding),
                        child: TextFieldWidget(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            textInputAction: controller == controllers.last
                                ? TextInputAction.done
                                : TextInputAction.next,
                            onChanged: (str) {
                              if (str.length == 1 &&
                                  controller != controllers.last) {
                                debugPrint("index");
                                FocusScope.of(context).nextFocus();
                              } else if (controller == controllers.last) {
                                FocusScope.of(context).unfocus();
                              }
                            }),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: SharedValues.padding * 2),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: SharedValues.padding),
                child: ButtonWidget(
                  minWidth: double.infinity,
                  withBorder: false,
                  onPressed: () async {
                    final provider =
                        Provider.of<AuthProvider>(context, listen: false);
                    bool status = provider.verifyCode(
                      controllers.map((e) => e.text).join(),
                    );
                    if (status) {
                      if (!widget.isSignUp) {
                        await provider.changePassword();
                      }
                      else {
                        await provider.signUp();
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                          (_) => false);
                    } else {
                      // ignore: use_build_context_synchronously
                      SharedComponents.showSnackBar(context, "OTP not Correct");
                    }
                  },
                  child: Text(
                    "Verify",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: Row(
                  children: [
                    Text("The code has not arrived",
                        style: Theme.of(context).textTheme.bodyText2),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text("Resend the code?",
                          style: Theme.of(context).textTheme.headline5),
                    )
                  ],
                ),
              ),
            ],
          ))
        ],
      ),
    ));
  }
}
