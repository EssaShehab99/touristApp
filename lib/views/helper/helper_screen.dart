import 'package:tourist_app/views/helper/helper_profile_screen.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class HelperScreen extends StatefulWidget {
  const HelperScreen({Key? key}) : super(key: key);

  @override
  State<HelperScreen> createState() => _HelperScreenState();
}

class _HelperScreenState extends State<HelperScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: Column(
            children: [
              SharedComponents.appBar(title: "Helpers"),
              Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(SharedValues.padding),
                    itemCount: 10,
                    itemBuilder: (context, index) => InkWell(
                      borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HelperProfileScreen()));
                      },
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        padding: const EdgeInsets.all(SharedValues.padding),
                        margin: const EdgeInsets.all(SharedValues.padding),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(SharedValues.borderRadius),
                            color: Theme.of(context).colorScheme.background,
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).dividerColor.withOpacity(0.5),spreadRadius: 1,blurRadius: 5)
                            ]
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Align(
                                            alignment: AlignmentDirectional.centerStart,
                                            child: Text("Bara Ali Ahmed",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5))),
                                    Expanded(
                                        child: Align(
                                            alignment: AlignmentDirectional.centerStart,
                                            child: Text("There was nothing new about the",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium))),
                                  ],
                                )),
                            PopupMenuButton<String>(
                                onSelected: (value) {},
                                itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                                  for (var item in ["Delete"])
                                    PopupMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style:
                                        Theme.of(context).textTheme.subtitle2,
                                      ),
                                    )
                                ],
                                child: Icon(
                                  Icons.more_vert,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
