import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/models/user.dart';
import 'package:tourist_app/data/repositories/service_repository.dart';
import 'package:tourist_app/data/utils/enum.dart';
import '/data/network/data_response.dart';
import '/data/di/service_locator.dart';

class ServiceProvider extends ChangeNotifier {
  ServiceProvider(this._user);
  List<Service> services = [];
  List<Helper> _helpers = [];
  final _serviceRepository = getIt.get<ServiceRepository>();
  final User? _user;
  Future<Result> addService(Service service) async {
    Result result = await _serviceRepository.addService(service);
    if (result is Success) {
      await getServices();
    }
    return result;
  }

  Future<Result> updateService(Service service) async {
    Result result = await _serviceRepository.updateService(service);
    if (result is Success) {
      await getServices();
    }
    return result;
  }

  Future<Result> deleteService(int id) async {
    Result result = await _serviceRepository.deleteService(id);
    if (result is Success) {
      await getServices();
    }
    return result;
  }

  Future<Result> addHelper(Helper helper) async {
    Result result = await _serviceRepository.addHelper(helper);
    if (result is Success) {
      await getHelpers();
    }
    return result;
  }

  Future<Result> updateHelper(Helper helper) async {
    Result result = await _serviceRepository.updateHelper(helper);
    if (result is Success) {
      await getHelpers();
    }
    return result;
  }

  Future<Result> deleteHelper(int id) async {
    Result result = await _serviceRepository.deleteHelper(id);
    if (result is Success) {
      await getHelpers();
    }
    return result;
  }

  Future<Result> getServices() async {
    Result result = await _serviceRepository.getServices(
        city: _user?.userRole == UserRole.admin ? null : _user?.city);
    if (result is Success) {
      services = result.value;
      notifyListeners();
    }
    return result;
  }

  Future<Result> getHelpers() async {
    Result result = await _serviceRepository.getHelpers();
    if (result is Success) {
      _helpers = result.value;
      notifyListeners();
    }
    return result;
  }

  List<Helper> helpers(int serviceID) {
    return _helpers.where((element) => element.serviceID == serviceID).toList();
  }
}
