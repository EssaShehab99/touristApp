import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/data/models/service.dart';
import '/data/network/data_response.dart';
import '/data/providers/auth_provider.dart';
import '/data/providers/service_provider.dart';
import '/data/utils/extension.dart';
import '/views/shared/button_widget.dart';
import '/views/shared/constants.dart';
import '/views/shared/dropdown_field_widget.dart';
import '/views/shared/image_field_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';
import '/views/shared/text_field_widget.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key, this.service}) : super(key: key);
final Service? service;
  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
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
    name = TextEditingController(text: widget.service?.name);
    details = TextEditingController(text: widget.service?.details);
    images=widget.service?.images??[];
    city =
        cities.firstWhereOrNull((element) => element.text == widget.service?.city);
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
          SharedComponents.appBar(title: "add-service".tr()),
          Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
            padding: const EdgeInsets.symmetric(vertical:SharedValues.padding),
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
                      }
                  ),
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
                      }
                  ),
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
                  child: ImageFieldWidget (hintText: "images".tr(), values: images,max: 1,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          return null;
                        }
                        return "field-required".tr();
                      }),
                ),
                const SizedBox(height: SharedValues.padding),
                Padding(
                  padding: const EdgeInsets.all(SharedValues.padding),
                  child: ButtonWidget(
                    onPressed: () async {
                      if(_formKey.currentState!.validate()){
                        Result result;
                        if(widget.service==null){
                          result=await provider.addService(Service(
                              id: DateTime.now().millisecondsSinceEpoch,
                              name: name.text,
                              details: details.text,
                              city: city!.text,
                              userID: Provider.of<AuthProvider>(context, listen: false)
                                  .user!
                                  .id!,
                              images: images));
                        }else{
                          result=await provider.updateService(Service(
                              id: widget.service!.id,
                              name: name.text,
                              details: details.text,
                              city: city!.text,
                              userID: Provider.of<AuthProvider>(context, listen: false)
                                  .user!
                                  .id!,
                              images: images));

                        }
                        if (result is Success) {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                              context,
                              widget.service == null
                                  ? "service-added-success".tr()
                                  : "service-edit-success".tr());
                        }
                        else {
                          // ignore: use_build_context_synchronously
                          SharedComponents.showSnackBar(
                            // ignore: use_build_context_synchronously
                              context,
                              "error-occurred".tr(),
                              backgroundColor:
                              // ignore: use_build_context_synchronously
                              Theme.of(context).colorScheme.error);
                        }

                      }
                    },
                    withBorder: false,
                    child: Text(
                      widget.service==null?"save".tr():"edit".tr(),
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
