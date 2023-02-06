import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/views/events/view_events.dart';
import 'package:tourist_app/views/requests/view_request.dart';
import 'package:tourist_app/views/services/view_services.dart';
import 'package:tourist_app/views/tourist_areas/view_areas.dart';
import '/views/shared/assets_variables.dart';
import '/views/shared/button_widget.dart';
import '/views/shared/shared_components.dart';
import '/views/shared/shared_values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SharedComponents.appBar(
            title: "app-name".tr(),
            withBackBtn: false,
            withSignOut: true,
            changeLanguage: ()=> setState(() { })
          ),
          const SizedBox(height: SharedValues.padding * 3),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: _buildButtonWidget(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewServices()));
                      },
                      text: "services".tr(),
                      image: AssetsVariable.services),
                ),
                Expanded(
                  child: _buildButtonWidget(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAreas()));
                      },
                      text: "tourist-areas".tr(),
                      image: AssetsVariable.areas),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: _buildButtonWidget(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewEvents()));
                      },
                      text: "events".tr(),
                      image: AssetsVariable.events),
                ),
                Expanded(
                  child: _buildButtonWidget(
                      onPressed: () {},
                      text: "hotels".tr(),
                      image: AssetsVariable.hotel),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: _buildButtonWidget(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ViewRequest(requestType: RequestType.helper,)));
                      },
                      text: "service-requests".tr(),
                      image: AssetsVariable.data),
                ),
                Expanded(
                  child: _buildButtonWidget(
                      onPressed: () {},
                      text: "hotel-requests".tr(),
                      image: AssetsVariable.data),
                ),
              ],
            ),
          ),
          const SizedBox(height: SharedValues.padding * 3),
        ],
      ),
    ));
  }

  Widget _buildButtonWidget(
      {required String image, required String text, VoidCallback? onPressed}) {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(SharedValues.padding),
        child: ButtonWidget(
            withBorder: true,
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(SharedValues.padding),
              child: Column(
                children: [
                  Expanded(
                      flex: 2,
                      child: SvgPicture.asset(
                          height: 100,
                          width: 100,
                          fit: BoxFit.scaleDown,
                          image)),
                  Expanded(
                    child: Text(text,
                        style: Theme.of(context).textTheme.headline5),
                  ),
                ],
              ),
            )),
      );
    });
  }
}
