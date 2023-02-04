import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/event.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/event_provider.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/views/events/add_event.dart';
import 'package:tourist_app/views/events/event_details.dart';
import 'package:tourist_app/views/shared/button_widget.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({Key? key}) : super(key: key);

  @override
  State<ViewEvents> createState() => _ViewEventsState();
}

class _ViewEventsState extends State<ViewEvents> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedComponents.showOverlayLoading(context, () async {
        await Provider.of<EventProvider>(context, listen: false).getEvents();
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
          SharedComponents.appBar(title: "events".tr()),
          Expanded(
              child: Selector<EventProvider, List<Event>>(
            selector: (p0, p1) => p1.events,
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetails(event: value[index]),
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
                                            AddEvent(event: value[index])));
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
                                final provider = Provider.of<EventProvider>(
                                    context,
                                    listen: false);

                                Result result =
                                    await provider.deleteEvent(value[index].id);

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
                            height: 30,
                            width: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(
                                    SharedValues.borderRadius)),
                            child: FittedBox(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Text(value[index].city,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background)),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Center(
                            child: Text(value[index].name,
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
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding:
                                  const EdgeInsets.all(SharedValues.padding),
                              child: Text(
                                value[index].details,
                                style: Theme.of(context).textTheme.labelMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          )),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: SharedValues.padding),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                              "${"period".tr()}: ${DateFormat("yyyy-MM-dd").format(value[index].from)}/ ${DateFormat("yyyy-MM-dd").format(value[index].to)}",
                              style: Theme.of(context).textTheme.subtitle2),
                        ),
                      )),
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
                    MaterialPageRoute(builder: (context) => AddEvent()));
              },
              child: const Icon(Icons.add)),
    ));
  }
}
