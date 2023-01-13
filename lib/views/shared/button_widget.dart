import 'package:flutter/material.dart';
import '/views/shared/shared_values.dart';

class ButtonWidget extends StatefulWidget {
  const ButtonWidget(
      {Key? key,
        this.onPressed,
        this.minWidth,
        this.height,
        this.child,
        this.withBorder})
      : super(key: key);
  final Function()? onPressed;
  final double? minWidth;
  final double? height;
  final Widget? child;
  final bool? withBorder;

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () async {
        isLoading = true;
        if (mounted) setState(() {});
        if (widget.onPressed != null) {
          await widget.onPressed!();
        }
        isLoading = false;
        if (mounted) setState(() {});
      },
      height: widget.height ?? 55,
      padding: EdgeInsets.zero,
      minWidth: widget.minWidth,
      color: widget.withBorder==false?Theme.of(context).primaryColor:null,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SharedValues.borderRadius),
          borderSide: widget.withBorder == false
              ? BorderSide.none
              : BorderSide(color: Theme.of(context).primaryColor, width: 1.5)),
      child: Builder(builder: (context) {
        if (isLoading) {
          return CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          );
        }
        return widget.child ?? const SizedBox.shrink();
      }),
    );
  }
}
