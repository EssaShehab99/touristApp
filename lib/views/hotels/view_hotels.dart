import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/hotel_provider.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/views/hotels/add_hotel.dart';
import 'package:tourist_app/views/hotels/hotel_details.dart';
import 'package:tourist_app/views/shared/button_widget.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ViewHotels extends StatefulWidget {
  const ViewHotels({Key? key}) : super(key: key);

  @override
  State<ViewHotels> createState() => _ViewHotelsState();
}

class _ViewHotelsState extends State<ViewHotels> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedComponents.showOverlayLoading(context, () async {
        await Provider.of<HotelProvider>(context, listen: false).getHotels();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false).user;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "hotels".tr()),
          Expanded(
              child: Selector<HotelProvider, List<Hotel>>(
            selector: (p0, p1) => p1.hotels,
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                  borderRadius:
                      BorderRadius.circular(SharedValues.borderRadius),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HotelDetails(hotel: value[index]),
                        ));
                  },
                  onLongPress: authProvider?.userRole != UserRole.admin? null:  () {
                    SharedComponents.showBottomSheet(context,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.all(SharedValues.padding),
                              child: ButtonWidget(
                                withBorder: false,
                                minWidth: double.infinity,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddHotel(hotel: value[index])));
                                },
                                child: Text(
                                  "edit".tr(),
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.all(SharedValues.padding),
                              child: ButtonWidget(
                                withBorder: false,
                                minWidth: double.infinity,
                                onPressed: () async {
                                  final provider = Provider.of<HotelProvider>(
                                      context,
                                      listen: false);

                                  Result result = await provider
                                      .deleteHotel(value[index].id);

                                  if (result is Success) {
                                    // ignore: use_build_context_synchronously
                                    SharedComponents.showSnackBar(
                                        context, "service-deleted".tr());
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    SharedComponents.showSnackBar(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        "error-occurred".tr(),
                                        backgroundColor:
                                            // ignore: use_build_context_synchronously
                                            Theme.of(context)
                                                .colorScheme
                                                .error);
                                  }
                                },
                                child: Text(
                                  "delete".tr(),
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            )
                          ],
                        ));
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
                              color: Theme.of(context)
                                  .dividerColor
                                  .withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5)
                        ]),
                    child: Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(SharedValues.padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(value[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(fontSize: 16)))),
                              Expanded(
                                  child: Align(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(value[index].details,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium,maxLines: 1,overflow: TextOverflow.ellipsis,))),
                            ],
                          ),
                        )),
                        if (value[index].images.isNotEmpty ?? false)
                          Container(
                            width: 100,
                            height: double.infinity,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              boxShadow: [
                                BoxShadow(
                                    color: Theme.of(context)
                                        .shadowColor
                                        .withOpacity(0.1),
                                    blurRadius: 3,
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(
                                  SharedValues.borderRadius),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  SharedValues.borderRadius),
                              child: Image.memory(
                                  base64Decode(value[index].images.first),
                                  fit: BoxFit.cover),
                            ),
                          )
                      ],
                    ),
                  )),
            ),
          ))
        ],
      ),
      floatingActionButton: authProvider?.userRole != UserRole.admin
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddHotel()));
              },
              child: const Icon(Icons.add)),
    ));
  }
}
