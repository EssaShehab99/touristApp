import 'dart:io';

import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ImageFieldWidget extends StatelessWidget {
  const ImageFieldWidget({
    Key? key,
    this.hintText,
    this.values,
    this.onChanged,
  }) : super(key: key);
  final List<String>? values;
  final String? hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hintText != null)
          Text("$hintText", style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: SharedValues.padding),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SharedValues.borderRadius),
              border:
                  Border.all(width: 2, color: Theme.of(context).primaryColor)),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                width: 150,
                margin: const EdgeInsets.all(SharedValues.padding),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(SharedValues.borderRadius),
                    border: Border.all(
                        width: 2, color: Theme.of(context).primaryColor)),
                child: Icon(Icons.add, color: Theme.of(context).primaryColor),
              ),
              for (String image in values ?? [])
                Container(
                  width: 100,
                  margin: const EdgeInsets.all(SharedValues.padding),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SharedValues.borderRadius),
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor)),
                  child: Image.file(File(image)),
                )
            ],
          ),
        )
      ],
    );
  }
}
