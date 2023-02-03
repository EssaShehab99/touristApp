import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/area.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/area_provider.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/constants.dart';
import 'package:tourist_app/views/shared/dropdown_field_widget.dart';
import 'package:tourist_app/views/shared/image_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddArea extends StatefulWidget {
  const AddArea({Key? key, this.area}) : super(key: key);
  final Area? area;

  @override
  State<AddArea> createState() => _AddAreaState();
}

class _AddAreaState extends State<AddArea> {
  late TextEditingController name;
  late TextEditingController details;
  DropdownMenuItemModel? city;
  List<DropdownMenuItemModel> cities = Constants.cities
      .map((e) =>
          DropdownMenuItemModel(id: Constants.cities.indexOf(e), text: e))
      .toList();
  List<String> images = [];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    name = TextEditingController(text: widget.area?.name);
    details = TextEditingController(text: widget.area?.details);
    city =
        cities.firstWhereOrNull((element) => element.text == widget.area?.city);
    images = widget.area?.images ?? [];
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
    final provider = Provider.of<AreaProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: "Add Tourist Areas"),
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
                        final area = Area(
                            id: DateTime.now().millisecondsSinceEpoch,
                            name: name.text,
                            details: details.text,
                            city: city!.text,
                            userID: Provider.of<AuthProvider>(context,
                                    listen: false)
                                .user!
                                .id!,
                            images: images);
                        Result result;
                        if (widget.area == null) {
                          result = await provider.addArea(area);
                        } else {
                          area.id = widget.area!.id;
                          result = await provider.updateArea(area);
                        }
                        if (result is Success) {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context,
                              widget.area == null
                                  ? "Area added success"
                                  : "Area edit success");
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
