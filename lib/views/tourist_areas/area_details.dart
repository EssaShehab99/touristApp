import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/area.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AreaDetails extends StatefulWidget {
  const AreaDetails({Key? key, required this.area}) : super(key: key);
  final Area area;

  @override
  State<AreaDetails> createState() => _AreaDetailsState();
}

class _AreaDetailsState extends State<AreaDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: widget.area.name),
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
                      widget.area.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: SharedValues.padding * 2),
                    CarouselSlider(
                        items: [
                          for (var image in widget.area.images)
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
                    Text(widget.area.details,
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
