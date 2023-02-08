import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/models/request.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/providers/auth_provider.dart';
import 'package:tourist_app/data/providers/request_provider.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/date_field_widget.dart';
import 'package:tourist_app/views/shared/dropdown_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddRequest extends StatefulWidget {
  const AddRequest({Key? key, this.request, this.withHome, required this.value})
      : super(key: key);
  final Request? request;
  final dynamic value;
  final bool? withHome;
  @override
  State<AddRequest> createState() => _AddRequestState();
}

class _AddRequestState extends State<AddRequest> {
  late TextEditingController from;
  late TextEditingController to;
  late TextEditingController phone;
  late TextEditingController details;
  DropdownMenuItemModel? isWithHome;
  final _formKey = GlobalKey<FormState>();
  final items = [
    DropdownMenuItemModel(id: 1, text: "yes".tr()),
    DropdownMenuItemModel(id: 1, text: "no".tr())
  ];
  @override
  void initState() {
    from = TextEditingController(text: widget.request?.from.toIso8601String());
    to = TextEditingController(text: widget.request?.to.toIso8601String());
    phone = TextEditingController(text: widget.request?.phone);
    details = TextEditingController(text: widget.request?.details);
    isWithHome = () {
      if (widget.request?.isWithHome == true) {
        isWithHome = items.first;
      } else if (widget.request?.isWithHome == false) {
        isWithHome = items[1];
      }
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: "add-request".tr()),
          Expanded(
              child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(SharedValues.padding),
              children: [
                DateFieldWidget(
                    hintText: "from".tr(),
                    controller: from,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return "field-required".tr();
                    }),
                DateFieldWidget(
                    hintText: "to".tr(),
                    controller: to,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return "field-required".tr();
                    }),
                const SizedBox(height: SharedValues.padding),
                TextFieldWidget(
                    hintText: "phone-contact".tr(),
                    controller: phone,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return "field-required".tr();
                    }),
                const SizedBox(height: SharedValues.padding),
                TextFieldWidget(
                    hintText: "note".tr(),
                    controller: details,
                    maxLines: 4,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      }
                      return "field-required".tr();
                    }),
                const SizedBox(height: SharedValues.padding * 2),
                if (widget.withHome != false) ...[
                  DropdownFieldWidget(
                    hintText: "${"is-home-you".tr()}?",
                    value: isWithHome,
                    onChanged: (value) {
                      isWithHome = value;
                    },
                    items: items,
                    keyDropDown: GlobalKey(),
                    validator: (value) {
                      if (value != null) {
                        return null;
                      }
                      return "field-required".tr();
                    },
                  ),
                  const SizedBox(height: SharedValues.padding * 2)
                ],
                ButtonWidget(
                  withBorder: false,
                  minWidth: double.infinity,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final provider =
                          Provider.of<RequestProvider>(context, listen: false);
                      final request = Request(
                          id: DateTime.now().millisecondsSinceEpoch,
                          from: DateTime.parse(from.text),
                          to: DateTime.parse(to.text),
                          phone: phone.text,
                          details: details.text,
                          status: RequestStatus.none,
                          userName:
                              Provider.of<AuthProvider>(context, listen: false)
                                  .user!
                                  .name!,
                          requestType: widget.value is Helper
                              ? RequestType.helper
                              : RequestType.hotel,
                          typeID: widget.value is Helper
                              ? (widget.value as Helper).id
                              : (widget.value as Hotel).id,
                          isWithHome: isWithHome?.text == items.first.text);
                      if (widget.request != null) {
                        request.id = widget.request!.id;
                      }
                      Result result = await provider.addRequest(
                          request,
                          widget.value is Helper
                              ? RequestType.helper
                              : RequestType.hotel);
                      if (result is Success) {
                        // ignore: use_build_context_synchronously
                        SharedComponents.showSnackBar(
                            context, "request-added-success".tr());
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
                    }
                  },
                  child: Text(
                    "request".tr(),
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    ));
  }
}
