import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/user.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/network/http_exception.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'package:tourist_app/data/utils/utils.dart';
import 'package:tourist_app/views/shared/constants.dart';
import 'package:tourist_app/views/shared/dropdown_field_widget.dart';

import '/views/auth/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/views/auth/sign_in_screen.dart';
import '/views/shared/assets_variables.dart';
import '/views/shared/button_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import '/views/shared/text_field_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController age;
  late TextEditingController password;
  late TextEditingController confirmPassword;
  DropdownMenuItemModel? city;
  List<DropdownMenuItemModel> cities = Constants.cities
      .map((e) =>
      DropdownMenuItemModel(id: Constants.cities.indexOf(e), text: e))
      .toList();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    name = TextEditingController();
    phone = TextEditingController();
    age = TextEditingController();
    email = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    // city =
    //     cities.firstWhereOrNull((element) => element.text == widget.user?.city);
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    age.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "sign-up".tr(),
              changeLanguage: ()=> setState(() { })),
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: SharedValues.padding * 3),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset(AssetsVariable.user,
                      fit: BoxFit.scaleDown),
                ),
                const SizedBox(height: SharedValues.padding * 2),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: name,
                      hintText: "name".tr(),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: email,
                      hintText: "email".tr(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null) {
                          return "field-required".tr();
                        } else if (!Utils.validateEmail(value)) {
                          return "invalid-email".tr();
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: phone,
                      hintText: "phone".tr(),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: DropdownFieldWidget(
                    hintText: "city".tr(),
                    items: cities,
                    value: city,
                    onChanged: (value) {
                      city = value;
                    },
                    validator: (value) {
                      if (value != null) {
                        return null;
                      }
                      return "field-required".tr();
                    },
                    keyDropDown: GlobalKey(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: age,
                      hintText: "age".tr(),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                    controller: password,
                    hintText: "password".tr(),
                    textInputAction: TextInputAction.none,
                    obscureText: true,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return "field-required".tr();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                    controller: confirmPassword,
                    hintText: "confirm-password".tr(),
                    textInputAction: TextInputAction.none,
                    obscureText: true,
                    validator: (value) {
                      if (confirmPassword.text == password.text) {
                        return null;
                      }
                      return "password-not-match".tr();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: ButtonWidget(
                    minWidth: double.infinity,
                    withBorder: false,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final user = User(
                            id: DateTime.now().millisecondsSinceEpoch,
                            name: name.text,
                            email: email.text,
                            phone: phone.text,
                            age: int.parse(age.text),
                            password: password.text,
                            userRole: UserRole.user,
                            city: city!.text);
                        Result result = await Provider.of<AuthProvider>(context,
                                listen: false)
                            .sendCode(user,false);
                        if (result is Success) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VerifyOTP(isSignUp: true),
                              ),
                              (_) => false);
                        } else if (result is Error &&
                            result.exception is ExistUserException) {
                          String message = "user-exist".tr();
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(context, message,
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.error);
                        } else if (result is Error) {
                          String message = "error-occurred".tr();
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(context, message,
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.error);
                        }
                      }
                    },
                    child: Text(
                      "sign-up".tr(),
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: Row(
                    children: [
                      Text("already-have-account".tr(),
                          style: Theme.of(context).textTheme.bodyText2),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignInScreen()));
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
