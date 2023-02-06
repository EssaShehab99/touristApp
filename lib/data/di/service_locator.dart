import 'package:tourist_app/data/network/api/area_api.dart';
import 'package:tourist_app/data/network/api/event_api.dart';
import 'package:tourist_app/data/network/api/request_api.dart';
import 'package:tourist_app/data/network/api/service_api.dart';
import 'package:tourist_app/data/repositories/areas_repository.dart';
import 'package:tourist_app/data/repositories/events_repository.dart';
import 'package:tourist_app/data/repositories/request_repository.dart';
import 'package:tourist_app/data/repositories/service_repository.dart';

import '/data/network/api/auth_api.dart';
import '/data/repositories/auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerSingleton(AuthApi());
  getIt.registerSingleton(AuthRepository(getIt.get<AuthApi>()));
  getIt.registerSingleton(ServiceApi());
  getIt.registerSingleton(ServiceRepository(getIt.get<ServiceApi>()));
  getIt.registerSingleton(AreaApi());
  getIt.registerSingleton(AreasRepository(getIt.get<AreaApi>()));
  getIt.registerSingleton(EventApi());
  getIt.registerSingleton(EventsRepository(getIt.get<EventApi>()));
  getIt.registerSingleton(RequestApi());
  getIt.registerSingleton(RequestRepository(getIt.get<RequestApi>()));

}