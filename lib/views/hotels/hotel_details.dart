import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/views/requests/add_request.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HotelDetails extends StatefulWidget {
  const HotelDetails({Key? key, required this.hotel}) : super(key: key);
  final Hotel hotel;

  @override
  State<HotelDetails> createState() => _HotelDetailsState();
}

class _HotelDetailsState extends State<HotelDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: widget.hotel.name),
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
                      widget.hotel.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: SharedValues.padding * 2),
                    CarouselSlider(
                        items: [
                          for (var image in widget.hotel.images)
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
                    Text(widget.hotel.details,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.justify),
                    Padding(
                      padding: const EdgeInsets.all(SharedValues.padding),
                      child: ButtonWidget(
                        withBorder: false,
                        minWidth: double.infinity,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddRequest(value: widget.hotel,withHome: false,)));
                        },
                        child: Text(
                          "request".tr(),
                          style: Theme.of(context).textTheme.button,
                        ),
                      ),
                    ),
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
