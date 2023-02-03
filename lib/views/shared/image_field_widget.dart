import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:tourist_app/views/shared/shared_components.dart';

import '/views/shared/shared_values.dart';
import 'package:flutter/material.dart';

class ImageFieldWidget extends StatefulWidget {
  const ImageFieldWidget({
    Key? key,
    this.hintText,
    this.values,
    this.onChanged, this.max,
  }) : super(key: key);
  final List<String>? values;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final int? max;

  @override
  State<ImageFieldWidget> createState() => _ImageFieldWidgetState();
}

class _ImageFieldWidgetState extends State<ImageFieldWidget> {
  void addImages(List<String> imagesPath){
    for(String path in imagesPath){
      if((widget.values?.length??0)<(widget.max??10)){
        widget.values?.add(path);
      }else{
        break;
      }
    }
    if((widget.values?.length??0)>(widget.max??10)){
      SharedComponents.showSnackBar(
          context,
          "Maximum number of photos: ${widget.max??10}");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.hintText != null)
          Text("${widget.hintText}", style: Theme.of(context).textTheme.labelMedium),
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
                  child: InkWell(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();
                      final images = await picker.pickMultiImage(
                          imageQuality:
                          80,
                          maxWidth:
                          250);
                      addImages(images.map((e) => e.path).toList());
                      setState(() {});
                    },
                    child:Icon(Icons.add, color: Theme.of(context).primaryColor),
                ),
              ),
              for (String image in widget.values ?? [])
                Container(
                  width: 150,
                  margin: const EdgeInsets.all(SharedValues.padding),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SharedValues.borderRadius),
                      border: Border.all(
                          width: 2, color: Theme.of(context).primaryColor)),
                  child: Image.file(File(image),fit: BoxFit.cover,),
                )
            ],
          ),
        )
      ],
    );
  }
}
