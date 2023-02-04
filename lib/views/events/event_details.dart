import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/event.dart';
import '/data/models/area.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:carousel_slider/carousel_slider.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: widget.event.name),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(SharedValues.padding),
            child: Row(
              children: [
                Container(
                  height: double.infinity,
                  width: 5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius:
                          BorderRadius.circular(SharedValues.borderRadius)),
                ),
                Expanded(
                    child: ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      SharedValues.padding * 1.5,
                      SharedValues.padding,
                      SharedValues.padding,
                      SharedValues.padding),
                  children: [
                    Text(
                      widget.event.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: SharedValues.padding * 2),
                    CarouselSlider(
                        items: [
                          for (var image in widget.event.images)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2),
                                  borderRadius: BorderRadius.circular(
                                      SharedValues.borderRadius)),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SharedValues.borderRadius),
                                  child: Image.memory(
                                    base64Decode(image),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                        ],
                        options: CarouselOptions(
                            enlargeCenterPage: true, viewportFraction: 1)),
                    const SizedBox(height: SharedValues.padding * 4),
                    Text("${"period".tr()}: ${DateFormat("yyyy-MM-dd").format(widget.event.from)}/ ${DateFormat("yyyy-MM-dd").format(widget.event.to)}",
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.justify),
                    const SizedBox(height: SharedValues.padding * 4),
                    Text(widget.event.details,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.justify),
                  ],
                ))
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
