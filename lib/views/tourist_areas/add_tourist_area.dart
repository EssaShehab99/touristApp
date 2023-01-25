import 'package:flutter/material.dart';
import 'package:tourist_app/views/shared/button_widget.dart';
import 'package:tourist_app/views/shared/image_field_widget.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import 'package:tourist_app/views/shared/shared_values.dart';
import 'package:tourist_app/views/shared/text_field_widget.dart';

class AddTouristArea extends StatelessWidget {
  const AddTouristArea({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(title: "Add Tourist Areas"),
          Expanded(
              child: ListView(
            padding: EdgeInsets.all(SharedValues.padding),
            children: [
              const SizedBox(height: SharedValues.padding),
              TextFieldWidget(
                controller: TextEditingController(),
                hintText: "Name",
              ),
              const SizedBox(height: SharedValues.padding),
              TextFieldWidget(
                controller: TextEditingController(),
                hintText: "Details",
                maxLines: 10,
              ),
              const SizedBox(height: SharedValues.padding),
              ImageFieldWidget(),
              const SizedBox(height: SharedValues.padding*4),
              ButtonWidget(
                withBorder: false,
                child: Text(
                  "Save",
                  style: Theme.of(context).textTheme.button,
                ),
              )
            ],
          ))
        ],
      ),
    ));
  }
}
