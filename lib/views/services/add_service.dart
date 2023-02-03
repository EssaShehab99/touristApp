import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/service_provider.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/date_field_widget.dart';
import 'package:tourist_app/views/shared/image_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key, this.service}) : super(key: key);
final Service? service;
  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  late TextEditingController name;
  late TextEditingController details;
  List<String> images = [];
  @override
  void initState() {
    name = TextEditingController();
    details = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    name.dispose();
    details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ServiceProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: "Add Service"),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.symmetric(vertical:SharedValues.padding),
            children: [
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: TextFieldWidget(
                  controller: name,
                  hintText: "Name",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: TextFieldWidget(
                  controller: details,
                  hintText: "Details",
                  maxLines: 10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: ImageFieldWidget(hintText: "Images", values: images,max: 1),
              ),
              const SizedBox(height: SharedValues.padding),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: ButtonWidget(
                  onPressed: () async {
                    Result result=await provider.addService(Service(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: name.text,
                        details: details.text,
                        userID: Provider.of<AuthProvider>(context, listen: false)
                            .user!
                            .id!,
                        images: images));
                    if (result is Success) {
                      // ignore: use_build_context_synchronously
                      SharedComponents.showSnackBar(
                          context,
                          widget.service == null
                              ? "Service added success"
                              : "Service edit success");
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
                  withBorder: false,
                  child: Text(
                    "Save",
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }
}
