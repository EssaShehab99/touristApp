import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '/data/models/service.dart';
import '/data/network/data_response.dart';
import '/data/providers/auth_provider.dart';
import '/data/providers/service_provider.dart';
import '/data/utils/enum.dart';
import '/views/helper/view_helper.dart';
import '/views/services/add_service.dart';
import '/views/shared/button_widget.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ViewServices extends StatefulWidget {
  const ViewServices({Key? key}) : super(key: key);

  @override
  State<ViewServices> createState() => _ViewServicesState();
}

class _ViewServicesState extends State<ViewServices> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedComponents.showOverlayLoading(context, () async {
        await Provider.of<ServiceProvider>(context, listen: false)
            .getServices();
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
          SharedComponents.appBar(title: "services".tr()),
          Expanded(
              child: Selector<ServiceProvider, List<Service>>(
            selector: (p0, p1) => p1.services,
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewHelper(
                                service: value[index],
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
                                        builder: (context) =>
                                            AddService(service: value[index])));
                              },
                              child: Text(
                                "edit".tr(),
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
                                    .deleteService(value[index].id);

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
                                          Theme.of(context).colorScheme.error);
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
                                    child: Text(value[index].details,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,overflow: TextOverflow.ellipsis,))),
                          ],
                        ),
                      )),
                      if (value[index].images?.isNotEmpty ?? false)
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
                          child:  ClipRRect(
                            borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                            child: Image.memory(
                                base64Decode(value[index].images!.first),fit: BoxFit.cover),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
      floatingActionButton: authProvider?.userRole != UserRole.admin
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddService()));
              },
              child: const Icon(Icons.add)),
    ));
  }
}
