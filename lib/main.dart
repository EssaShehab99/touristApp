import 'dart:convert';

import 'package:tourist_app/data/local/sharedpref_helper/preferences.dart';
import 'package:tourist_app/data/providers/service_provider.dart';
import 'package:tourist_app/views/auth/sign_in_screen.dart';
import 'package:tourist_app/views/events/add_event.dart';
import 'package:tourist_app/views/home/home_page.dart';
import 'package:tourist_app/views/onboarding/onboarding_screen.dart';

import '/data/providers/auth_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/style/theme_app.dart';
import 'package:provider/provider.dart';

import 'data/di/service_locator.dart';
import 'data/local/sharedpref_helper/preference_variable.dart';
import 'data/models/user.dart';
import 'data/providers/app_state_manager.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final preferences = Preferences.instance;
  String? date = (await preferences.get(PreferenceVariable.user))?.toString();
  User? user = date == null ? null : User.fromJson(jsonDecode(date));

  setup();
  runApp(EasyLocalization(
    fallbackLocale: const Locale('ar', 'SA'),
    startLocale: const Locale('en', 'US'),
    saveLocale: true,
    supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
    path: 'assets/translations',
    child: MyApp(user: user),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.user});
  final User? user;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateManager()),
        ChangeNotifierProvider(create: (_) => AuthProvider()..setUser(user)),
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: ThemeApp.light,
        // home: const TestScreen(),
        home: user == null ? const SignInScreen() : const HomeScreen(),
        // home:  const SignInScreen(),
        // home: const MainScreen(),
        // home: const VerifyOTP(),
      ),
    );
  }
}
