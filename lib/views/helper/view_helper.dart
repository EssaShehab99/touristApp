import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/service_provider.dart';
import 'package:tourist_app/views/helper/add_helper.dart';
import 'package:tourist_app/views/helper/helper_profile_screen.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/image_network.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ViewHelper extends StatefulWidget {
  const ViewHelper({Key? key, required this.service}) : super(key: key);
  final Service service;

  @override
  State<ViewHelper> createState() => _ViewHelperState();
}

class _ViewHelperState extends State<ViewHelper> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedComponents.showOverlayLoading(context, () async {
        await Provider.of<ServiceProvider>(context, listen: false).getHelpers();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "Helpers"),
          Expanded(
              child: Selector<ServiceProvider, List<Helper>>(
            selector: (p0, p1) => p1.helpers(widget.service.id),
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HelperProfileScreen(
                                helper: value[index],
                              )));
                },
                onLongPress: () {
                  SharedComponents.showBottomSheet(context,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(SharedValues.padding),
                            child: ButtonWidget(
                              withBorder: false,
                              minWidth: double.infinity,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddHelper(
                                            serviceID: value[index].serviceID,
                                            helper: value[index])));
                              },
                              child: Text(
                                "Edit",
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(SharedValues.padding),
                            child: ButtonWidget(
                              withBorder: false,
                              minWidth: double.infinity,
                              onPressed: () async {
                                final provider = Provider.of<ServiceProvider>(
                                    context,
                                    listen: false);

                                Result result = await provider
                                    .deleteHelper(value[index].id);

                                if (result is Success) {
                                  // ignore: use_build_context_synchronously
                                  SharedComponents.showSnackBar(
                                      context, "Service deleted");
                                } else {
                                  // ignore: use_build_context_synchronously
                                  SharedComponents.showSnackBar(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      "Error occurred !!",
                                      backgroundColor:
                                          // ignore: use_build_context_synchronously
                                          Theme.of(context).colorScheme.error);
                                }
                              },
                              child: Text(
                                "Delete",
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
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.5),
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
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(value[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(fontSize: 16)))),
                            Expanded(
                                child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(value[index].email,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium))),
                          ],
                        ),
                      )),
                      if (value[index].images.isNotEmpty)
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
                          child: Image.memory(
                              base64Decode(value[index].images!.first)),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddHelper(serviceID: widget.service.id)));
          },
          child: const Icon(Icons.add)),
    ));
  }
}
