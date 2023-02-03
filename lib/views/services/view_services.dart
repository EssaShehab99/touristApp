import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/providers/service_provider.dart';
import 'package:tourist_app/views/helper/helper_screen.dart';
import 'package:tourist_app/views/services/add_service.dart';
import 'package:tourist_app/views/shared/image_network.dart';

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
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: Column(
        children: [
          SharedComponents.appBar(title: "Services"),
          Expanded(
              child: Selector<ServiceProvider, List<Service>>(
            selector: (p0, p1) => p1.services,
            builder: (context, value, _) => ListView.builder(
              padding: const EdgeInsets.all(SharedValues.padding),
              itemCount: value.length,
              itemBuilder: (context, index) => InkWell(
                borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HelperScreen(service: value[index],)));
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
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(value[index].name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5?.copyWith(fontSize: 16)))),
                          Expanded(
                              child: Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(value[index].details,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium))),
                        ],
                      )),
                      if(value[index].images?.isNotEmpty??false)
                        Container(
                          width: 100,
                          height: double.infinity,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            boxShadow: [
                              BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.1),blurRadius: 3,spreadRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(SharedValues.borderRadius),
                          ),
                          child: ImageNetwork(url: value[index].images!.first),
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddService()));
          },
          child: const Icon(Icons.add)),
    ));
  }
}
