import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/event.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/event_provider.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/constants.dart';
import 'package:tourist_app/views/shared/date_field_widget.dart';
import 'package:tourist_app/views/shared/dropdown_field_widget.dart';
import 'package:tourist_app/views/shared/image_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key, this.event}) : super(key: key);
  final Event? event;

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  late TextEditingController name;
  late TextEditingController details;
  late TextEditingController from;
  late TextEditingController to;
  DropdownMenuItemModel? city;
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItemModel> cities = Constants.cities
      .map((e) =>
          DropdownMenuItemModel(id: Constants.cities.indexOf(e), text: e))
      .toList();
  List<String> images = [];
  @override
  void initState() {
    name = TextEditingController(text: widget.event?.name);
    details = TextEditingController(text: widget.event?.details);
    from = TextEditingController(text: widget.event?.from.toIso8601String());
    to = TextEditingController(text: widget.event?.to.toIso8601String());
    city =
        cities.firstWhereOrNull((element) => element.text == widget.event?.city);
    images = widget.event?.images ?? [];
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
    final provider = Provider.of<EventProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: "Add Event"),
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: SharedValues.padding),
              children: [
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: name,
                      hintText: "Name",
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "This field is required";
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: details,
                      hintText: "Details",
                      maxLines: 10,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "This field is required";
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: DropdownFieldWidget(
                    hintText: "City",
                    items: cities,
                    value: city,
                    onChanged: (value) {
                      city = value;
                    },
                    validator: (value) {
                      if (value != null) {
                        return null;
                      }
                      return "This field is required";
                    },
                    keyDropDown: GlobalKey(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: DateFieldWidget(
                      hintText: "From",
                      controller: from,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "This field is required";
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: DateFieldWidget(
                      hintText: "To",
                      controller: to,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "This field is required";
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: ImageFieldWidget(
                      hintText: "Images",
                      max: 5,
                      values: images,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "This field is required";
                      }),
                ),
                const SizedBox(height: SharedValues.padding * 2),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: ButtonWidget(
                    withBorder: false,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final event = Event(
                            id: DateTime.now().millisecondsSinceEpoch,
                            name: name.text,
                            details: details.text,
                            city: city!.text,
                            from: DateTime.parse(from.text),
                            to: DateTime.parse(to.text),
                            userID: Provider.of<AuthProvider>(context,
                                    listen: false)
                                .user!
                                .id!,
                            images: images);
                        Result result;
                        if (widget.event == null) {
                          result = await provider.addEvent(event);
                        } else {
                          event.id = widget.event!.id;
                          result = await provider.updateEvent(event);
                        }
                        if (result is Success) {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context,
                              widget.event == null
                                  ? "Event added success"
                                  : "Event edit success");
                        } else {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context, "Error occurred !!",
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.error);
                        }
                      }
                    },
                    child: Text(
                      "Save",
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                )
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
