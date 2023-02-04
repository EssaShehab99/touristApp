import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/views/auth/sign_in_screen.dart';
import 'package:tourist_app/views/shared/assets_variables.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late List<Widget> widgets;
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widgets = [
      _page(
          AssetsVariable.onboarding_1,
          0,
          "welcome".tr(),
          "next".tr(),
          () => _pageController.nextPage(
              duration: const Duration(microseconds: 250),
              curve: Curves.easeIn)),
      _page(
          AssetsVariable.onboarding_2,
          1,
          "welcome-first".tr(),
          "next".tr(),
          () => _pageController.nextPage(
              duration: const Duration(microseconds: 250),
              curve: Curves.easeIn)),
      _page(
          AssetsVariable.onboarding_3,
          2,
          "welcome-second".tr(),
          "start".tr(), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (_) => false);
      }),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: widgets.toList(),
      )),
    );
  }

  Widget _page(String imageUrl, int index, String desc, String buttonText,
      GestureTapCallback? onPressed) {
    return Padding(
      padding: const EdgeInsets.all(SharedValues.padding),
      child: Column(children: <Widget>[
        Expanded(child: Image.asset(imageUrl)),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
                child: Text('app-name'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(color: Theme.of(context).primaryColor))),
            Flexible(
                child: Padding(
              padding: const EdgeInsets.all(SharedValues.padding),
              child: Text(desc,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.justify),
            )),
            Flexible(
              child: SharedComponents.indicator(3, index),
            ),
            Flexible(
                child: ButtonWidget(
              withBorder: false,
              minWidth: double.infinity,
              onPressed: onPressed,
              child:
                  Text(buttonText, style: Theme.of(context).textTheme.button),
            ))
          ],
        )),
      ]),
    );
  }
}
