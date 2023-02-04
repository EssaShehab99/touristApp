import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/utils/utils.dart';

import '/views/home/home_page.dart';
import '/views/shared/assets_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/views/auth/sign_up_screen.dart';
import '/views/shared/button_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import '/views/shared/text_field_widget.dart';
import 'forget_password.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late TextEditingController email;
  late TextEditingController password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "sign-in".tr(),withBackBtn: false,
              changeLanguage: ()=> setState(() { })),
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                        height: 200,
                        child: SvgPicture.asset(AssetsVariable.auth))),
                const SizedBox(height: SharedValues.padding),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null) {
                          return "field-required".tr();
                        } else if (!Utils.validateEmail(value)) {
                          return "invalid-email".tr();
                        }
                        return null;
                      },
                      hintText: "email".tr()),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:SharedValues.padding),
                  child: TextFieldWidget(
                      controller: password, hintText: "password".tr(),
                      validator: (value) {
                if (value != null && value.isNotEmpty) {
                return null;
                }
                return "field-required".tr();
                }),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ForgetPassword()));
                    },
                    child: Text("${"forget-password".tr()}?",
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ),
                const SizedBox(height: SharedValues.padding),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: SharedValues.padding),
                  child: ButtonWidget(
                    minWidth: double.infinity,
                    withBorder: false,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Result result = await Provider.of<AuthProvider>(context,
                            listen: false)
                            .signIn(email.text,
                            password.text);
                        if (result is Success) {
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        } else if (result is Error) {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context, "user-password-incorrect".tr(),
                              backgroundColor:
                              // ignore: use_build_context_synchronously
                              Theme.of(context).colorScheme.error);
                        }
                      }
                    },
                    child: Text(
                      "sign-in".tr(),
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: Row(
                    children: [
                      Text("have-not-account".tr(),
                          style: Theme.of(context).textTheme.bodyText2),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: Text("${"sign-in".tr()}?",
                            style: Theme.of(context).textTheme.headline5),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
