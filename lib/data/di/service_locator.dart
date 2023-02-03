import 'package:tourist_app/data/network/api/service_api.dart';
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

}