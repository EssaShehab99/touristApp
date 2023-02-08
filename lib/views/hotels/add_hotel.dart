import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/hotel_provider.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/constants.dart';
import 'package:tourist_app/views/shared/dropdown_field_widget.dart';
import 'package:tourist_app/views/shared/image_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddHotel extends StatefulWidget {
  const AddHotel({Key? key, this.hotel}) : super(key: key);
  final Hotel? hotel;

  @override
  State<AddHotel> createState() => _AddHotelState();
}

class _AddHotelState extends State<AddHotel> {
  late TextEditingController name;
  late TextEditingController details;
  DropdownMenuItemModel? city;
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItemModel> cities = Constants.cities
      .map((e) =>
          DropdownMenuItemModel(id: Constants.cities.indexOf(e), text: e))
      .toList();
  List<String> images = [];
  @override
  void initState() {
    name = TextEditingController(text: widget.hotel?.name);
    details = TextEditingController(text: widget.hotel?.details);
    city =
        cities.firstWhereOrNull((element) => element.text == widget.hotel?.city);
    images = widget.hotel?.images ?? [];
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
    final provider = Provider.of<HotelProvider>(context, listen: false);
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: "add-hotel".tr()),
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
                        final hotel = Hotel(
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
                        if (widget.hotel == null) {
                          result = await provider.addHotel(hotel);
                        } else {
                          hotel.id = widget.hotel!.id;
                          result = await provider.updateHotel(hotel);
                        }
                        if (result is Success) {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context,
                              widget.hotel == null
                                  ? "hotel-added-success".tr()
                                  : "hotel-edit-success".tr());
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
