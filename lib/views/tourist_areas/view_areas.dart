import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '/data/models/area.dart';
import '/data/network/data_response.dart';
import '/data/providers/area_provider.dart';
import '/data/providers/auth_provider.dart';
import '/data/utils/enum.dart';
import '/views/shared/button_widget.dart';
import '/views/tourist_areas/add_area.dart';
import '/views/tourist_areas/area_details.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ViewAreas extends StatefulWidget {
  const ViewAreas({Key? key}) : super(key: key);

  @override
  State<ViewAreas> createState() => _ViewAreasState();
}

class _ViewAreasState extends State<ViewAreas> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedComponents.showOverlayLoading(context, () async {
        await Provider.of<AreaProvider>(context, listen: false).getAreas();
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
          SharedComponents.appBar(title: "tourist-areas".tr()),
          Expanded(
              child: Selector<AreaProvider, List<Area>>(
            selector: (p0, p1) => p1.areas,
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AreaDetails(area: value[index]),
                      ));
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
                                            AddArea(area: value[index])));
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
                                final provider = Provider.of<AreaProvider>(
                                    context,
                                    listen: false);

                                Result result =
                                    await provider.deleteArea(value[index].id);

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
                  height: 130,
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
                                  child: Text(value[index].city,
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: SharedValues.padding),
                                    child: Text(value[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            ?.copyWith(
                                                color: Theme.of(context).primaryColor,
                                                fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis),
                                  ),
                                )),
                              ],
                            )),
                            Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.all(SharedValues.padding),
                                    child: Text(value[index].details,
                                        style:
                                            Theme.of(context).textTheme.labelMedium),
                                  ),
                                )),
                          ],
                        ),
                      ),
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                            child: Image.memory(
                                base64Decode(value[index].images.first),fit: BoxFit.cover),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddArea()));
          },
          child: const Icon(Icons.add)),
    ));
  }
}






























































































