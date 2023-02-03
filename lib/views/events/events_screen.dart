import 'package:tourist_app/views/helper/view_helper.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "Events"),
          Expanded(
              child: ListView.builder(
            padding: const EdgeInsets.all(SharedValues.padding),
            itemCount: 10,
            itemBuilder: (context, index) => InkWell(
              borderRadius: BorderRadius.circular(SharedValues.borderRadius),
              onTap: () {
              },
              child: Container(
                height: 150,
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
                          child: Text("Name of event",
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
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(SharedValues.padding),
                          child: Text(
                            "There was nothing new about the Manchurian lightning bolt, because it was the south side of the nations. That is, as for ",
                            style: Theme.of(context).textTheme.labelMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal:SharedValues.padding),
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text("period: 2022-06-04 / 2022-07-05",
                            style: Theme.of(context).textTheme.subtitle2),
                      ),
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
