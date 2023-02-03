import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/network/api/service_api.dart';
import 'package:tourist_app/data/network/data_response.dart';

class ServiceRepository {
  final ServiceApi _serviceApi;
  ServiceRepository(this._serviceApi);
  Future<Result> addService(Service service) async {
    try {
      String? id = await _serviceApi.addService(service.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> addHelper(Helper helper) async {
    try {
      String? id = await _serviceApi.addHelper(helper.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> getServices() async {
    try {
      final response = await _serviceApi.getServices();
      final services = response.map((e) => Service.fromJson(e.data())).toList();
      return Success(services);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> getHelpers() async {
    try {
      final response = await _serviceApi.getHelpers();
      final helpers = response.map((e) => Helper.fromJson(e.data())).toList();
      return Success(helpers);
    } catch (e) {
      return Error(e);
    }
  }
}
