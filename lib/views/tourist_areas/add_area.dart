import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/models/area.dart';
import '/data/network/data_response.dart';
import '/data/providers/area_provider.dart';
import '/data/providers/auth_provider.dart';
import '/data/utils/extension.dart';
import '/views/shared/button_widget.dart';
import '/views/shared/constants.dart';
import '/views/shared/dropdown_field_widget.dart';
import '/views/shared/image_field_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import '/views/shared/text_field_widget.dart';

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
          SharedComponents.appBar(title: "add-tourist-areas".tr()),
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
                      hintText: "name".tr(),
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: TextFieldWidget(
                      controller: details,
                      hintText: "details".tr(),
                      maxLines: 10,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: DropdownFieldWidget(
                    hintText: "city".tr(),
                    items: cities,
                    value: city,
                    onChanged: (value) {
                      city = value;
                    },
                    validator: (value) {
                      if (value != null) {
                        return null;
                      }
                      return "field-required".tr();
                    },
                    keyDropDown: GlobalKey(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: ImageFieldWidget(
                      hintText: "images".tr(),
                      max: 5,
                      values: images,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
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
                                  ? "area-added-success".tr()
                                  : "area-edit-success".tr());
                        } else {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context, "error-occurred".tr(),
                              backgroundColor:
                                  // ignore: use_build_context_synchronously
                                  Theme.of(context).colorScheme.error);
                        }
                      }
                    },
                    child: Text(
                      "save".tr(),
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
