import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/views/shared/shared_components.dart';
import '/views/shared/assets_variables.dart';
import '/views/shared/shared_values.dart';

class HelperProfileScreen extends StatefulWidget {
  const HelperProfileScreen({Key? key, required this.helper}) : super(key: key);
  final Helper helper;
  @override
  State<HelperProfileScreen> createState() => _HelperProfileScreenState();
}

class _HelperProfileScreenState extends State<HelperProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SharedComponents.appBar(title: widget.helper.name),
            const SizedBox(height: SharedValues.padding * 3),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: SizedBox(
                width: 100,
                height: 100,
                child: SvgPicture.asset(AssetsVariable.user,
                    color: Theme.of(context).colorScheme.primary,
                    fit: BoxFit.scaleDown),
              ),
            ),
            const SizedBox(height: SharedValues.padding),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Text(
                widget.helper.name,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: Divider(
                  thickness: 2,
                  color: Theme.of(context).colorScheme.error,
                  indent: MediaQuery.of(context).size.width * 0.25,
                  endIndent: MediaQuery.of(context).size.width * 0.25),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(SharedValues.padding),
                children: [
                  const SizedBox(height: SharedValues.padding),
                  _buildInfo("Email", widget.helper.email),
                  _buildInfo("Phone", widget.helper.phone),
                  _buildInfo("Age", widget.helper.age.toString()),
                  _buildInfo("Gender", widget.helper.gender),
                  _buildInfo("Nationality", widget.helper.nationality),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String title, String details) {
    return Builder(builder: (context) {
      return Container(
        height: 90,
        padding: const EdgeInsets.all(SharedValues.padding),
        margin: const EdgeInsets.all(SharedValues.padding),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(SharedValues.borderRadius)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Padding(
                padding: const EdgeInsets.all(SharedValues.padding),
                child: Text(
                  details,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            margin:
                const EdgeInsets.symmetric(horizontal: SharedValues.padding),
            color: Theme.of(context).primaryColor,
          )
        ]),
      );
    });
  }
}
