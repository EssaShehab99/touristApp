import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/views/auth/sign_in_screen.dart';
import '/views/shared/assets_variables.dart';
import '/views/shared/shared_values.dart';

class SharedComponents {
  SharedComponents._privateConstructor();
  static final SharedComponents _instance =
      SharedComponents._privateConstructor();
  static SharedComponents get instance => _instance;

  static Widget appBar(
          {required String title, bool? withBackBtn,bool? withSignOut, Widget? leading}) =>
      Builder(
          builder: (context) => Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(SharedValues.borderRadius * 2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: withBackBtn == false
                          ?  withSignOut==true?PopupMenuButton<int>(
                          onSelected: (value) async {
                            await Provider.of<AuthProvider>(context,
                                listen: false)
                                .signOut();
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInScreen()),
                                    (route) => false);
                          },
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<int>>[
                            PopupMenuItem(
                              value: 1,
                              child: Text(
                                "Sign Out",
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            )
                          ],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: SharedValues.padding),
                            child: Icon(
                              Icons.more_vert,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )):null
                          : IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back)),
                    ),
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                SharedValues.padding * 2,
                                0,
                                SharedValues.padding * 2,
                                SharedValues.padding),
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                title,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
                          ),
                        ),
                        leading ?? const SizedBox.shrink()
                      ],
                    )),
                  ],
                ),
              ));
  static Future<dynamic> showBottomSheet(BuildContext context,
      {double? height, Widget? child}) {
    return showModalBottomSheet(
      enableDrag: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(SharedValues.borderRadius * 2))),
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(SharedValues.padding),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(SharedValues.borderRadius * 2)),
                color: Theme.of(context).colorScheme.onPrimary),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: SharedValues.padding * 2),
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius:
                            BorderRadius.circular(SharedValues.borderRadius)),
                  ),
                ),
                child ?? const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static showSnackBar(context, String text, {Color? backgroundColor}) {
    return WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ));
    });
  }

  static Widget indicator(int length, int selected) {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (index) {
          if (index == selected) {
            return Container(
              width: 40,
              height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColor),
            );
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              child: CircleAvatar(
                radius: 5,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }).toList(),
      );
    });
  }

  static Future<dynamic> showOverlayLoading(
          BuildContext context, Function() futureFun,
          {Color? color, Color? progressColor}) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: FutureBuilder(
                future: futureFun(),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pop(context, snapshot.data);
                    });
                  }
                  return SizedBox(
                      height: 200,
                      width: 200,
                      child: Align(
                        child: AvatarGlow(
                          glowColor: color ?? Theme.of(context).primaryColor,
                          duration: const Duration(
                            milliseconds: 2000,
                          ),
                          repeat: true,
                          showTwoGlows: true,
                          endRadius: 50,
                          child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(120)),
                              child: CircularProgressIndicator(
                                backgroundColor: progressColor ??
                                    Theme.of(context).colorScheme.primary,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    color ?? Theme.of(context).primaryColor),
                              )),
                        ),
                      ));
                }),
          );
        },
      );
}
