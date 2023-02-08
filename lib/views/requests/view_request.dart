import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/event.dart';
import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/models/request.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/event_provider.dart';
import 'package:tourist_app/data/providers/request_provider.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/views/events/add_event.dart';
import 'package:tourist_app/views/events/event_details.dart';
import 'package:tourist_app/views/shared/button_widget.dart';

import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ViewRequest extends StatefulWidget {
  const ViewRequest({Key? key, required this.requestType}) : super(key: key);
  final RequestType requestType;
  @override
  State<ViewRequest> createState() => _ViewRequestState();
}

class _ViewRequestState extends State<ViewRequest> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedComponents.showOverlayLoading(context, () async {
        await Provider.of<RequestProvider>(context, listen: false)
            .getRequests(widget.requestType);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RequestProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "requests".tr()),
          Expanded(
              child: Selector<RequestProvider, List<Request>>(
            selector: (_, p1) => p1.requests,
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                onLongPress: () {
                  SharedComponents.showBottomSheet(context,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(SharedValues.padding),
                            child: ButtonWidget(
                              withBorder: false,
                              minWidth: double.infinity,
                              onPressed: () async {
                                value[index].status = RequestStatus.accept;
                                Result result = await provider.updateRequest(
                                    value[index], widget.requestType);
                                if (result is Success) {
                                  // ignore: use_build_context_synchronously
                                  SharedComponents.showSnackBar(
                                      context, "request-accepted-success".tr());
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
                                "accept".tr(),
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
                                value[index].status = RequestStatus.reject;
                                Result result = await provider.updateRequest(
                                    value[index], widget.requestType);
                                if (result is Success) {
                                  // ignore: use_build_context_synchronously
                                  SharedComponents.showSnackBar(
                                      context, "request-reject".tr());
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
                                "reject".tr(),
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          )
                        ],
                      ));
                },
                child: Container(
                  height: 220,
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
                      Text("${"requester".tr()}: ${value[index].userName}",
                          style: Theme.of(context)
                              .textTheme
                              .headline3
                              ?.copyWith(
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                      if(value[index].value is Helper)
                      Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${"helper".tr()}: ${(value[index].value as Helper?)?.name}",
                        style: Theme.of(context).textTheme.subtitle2),
                      ),
                      if(value[index].value is Hotel)
                      Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${"hotel".tr()}: ${(value[index].value as Hotel?)?.name}",
                        style: Theme.of(context).textTheme.subtitle2),
                      ),
                      Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${"period".tr()}: ${DateFormat("yyyy-MM-dd").format(value[index].from)}/ ${DateFormat("yyyy-MM-dd").format(value[index].to)}",
                        style: Theme.of(context).textTheme.subtitle2),
                      ),
                      if (value[index].isWithHome==true)
                        Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "have-house".tr(),
                          style:
                          Theme.of(context).textTheme.labelMedium),
                        ),
                      Expanded(
                          flex: 3,
                          child: Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Text(
                              value[index].details,
                              style: Theme.of(context).textTheme.labelMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          )),
                      Align(
                        alignment: AlignmentDirectional.bottomStart,
                        child: Text(
                            value[index].status == RequestStatus.accept
                                ? "accepted".tr()
                                : value[index].status ==
                                RequestStatus.reject
                                ? "rejected".tr()
                                : "",
                            style: Theme.of(context).textTheme.subtitle2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
