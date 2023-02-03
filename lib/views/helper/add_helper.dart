import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/service_provider.dart';
import 'package:tourist_app/data/utils/utils.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/date_field_widget.dart';
import 'package:tourist_app/views/shared/dropdown_field_widget.dart';
import 'package:tourist_app/views/shared/image_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddHelper extends StatefulWidget {
  const AddHelper({Key? key, required this.service}) : super(key: key);
  final Service service;
  @override
  State<AddHelper> createState() => _AddHelperState();
}

class _AddHelperState extends State<AddHelper> {
  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController age;
  late TextEditingController nationality;
  late DropdownMenuItemModel gender;
  List<String> images = [];
  List<DropdownMenuItemModel> genders = [
    DropdownMenuItemModel(id: 1, text: "Male"),
    DropdownMenuItemModel(id: 2, text: "Female"),
  ];
  @override
  void initState() {
    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    age = TextEditingController();
    nationality = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    age.dispose();
    nationality.dispose();
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
              const SizedBox(height: SharedValues.padding),
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
                    controller: email,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      } else if (!Utils.validateEmail(value)) {
                        return "Invalid email";
                      }
                      return null;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: TextFieldWidget(
                  controller: phone,
                  hintText: "Phone",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: TextFieldWidget(
                  controller: age,
                  hintText: "Age",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: DropdownFieldWidget(
                  items: genders,
                  hintText: "Gender",
                  onChanged: (value) {
                    gender=value!;
                  },
                  keyDropDown: GlobalKey(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: TextFieldWidget(
                  controller: nationality,
                  hintText: "Nationality",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: ImageFieldWidget(hintText: "Images", values: images, max: 1),
              ),
              const SizedBox(height: SharedValues.padding*2),
              Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: ButtonWidget(
                  onPressed: () async {
                    Result result = await provider.addHelper(Helper(
                        id: DateTime.now().millisecondsSinceEpoch,
                        name: name.text,
                        email: email.text,
                        phone: phone.text,
                        serviceID: widget.service.id,
                        age: int.parse(age.text),
                        gender: gender.text,
                        nationality: nationality.text,
                        userID: Provider.of<AuthProvider>(context, listen: false)
                            .user!
                            .id!,
                        images: images));
                    if (result is Success) {
                      // ignore: use_build_context_synchronously
                      SharedComponents.showSnackBar(
                          context,
                          widget.service == null
                              ? "Helper added success"
                              : "Helper edit success");
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
