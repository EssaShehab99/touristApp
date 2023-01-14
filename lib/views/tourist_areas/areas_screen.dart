import 'package:tourist_app/views/helper/helper_screen.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class AreasScreen extends StatefulWidget {
  const AreasScreen({Key? key}) : super(key: key);

  @override
  State<AreasScreen> createState() => _AreasScreenState();
}

class _AreasScreenState extends State<AreasScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "Tourist Areas"),
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.all(SharedValues.padding),
            itemCount: 10,
            itemBuilder: (context, index) => InkWell(
              borderRadius: BorderRadius.circular(SharedValues.borderRadius),
              onTap: () {
              },
              child: Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(SharedValues.padding),
                margin: const EdgeInsets.all(SharedValues.padding),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(SharedValues.borderRadius),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                          color:
                              Theme.of(context).dividerColor.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5)
                    ]),
                child: Column(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Container(
                        height: 20,
                        width: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(
                              SharedValues.borderRadius)),
                        child: Text("City",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .background)),
                        ),
                        Expanded(
                            child: Center(
                          child: Text("Name of area",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold)),
                        )),
                      ],
                    )),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(SharedValues.padding),
                          child: Text(
                              "There was nothing new about the Manchurian lightning bolt, because it was the south side of the nations. That is, as for ",
                              style: Theme.of(context).textTheme.labelMedium),
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
