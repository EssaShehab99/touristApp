import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/service.dart';
import 'package:tourist_app/data/network/api/service_api.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/utils/utils.dart';

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
  Future<Result> updateService(Service service) async {
    try {
      String? id = await _serviceApi.updateService(service.id,service.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> deleteService(int id) async {
    try {
      return Success(await _serviceApi.deleteService(id));
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
  Future<Result> updateHelper(Helper helper) async {
    try {
      String? id = await _serviceApi.updateHelper(helper.id,helper.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> deleteHelper(int id) async {
    try {
      return Success(await _serviceApi.deleteHelper(id));
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> getServices({String? city}) async {
    try {
      final response = await _serviceApi.getServices(city: city);
      List<Service> services=[];
      for(final item in response){
        Map<String, dynamic> data= item.data();
        data["images"]=await Future.wait(List<String>.from(data["images"]).map((image) async=> await Utils.imageToBase64(image)).toList());
        services.add(Service.fromJson(data));
      }
      return Success(services);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> getHelpers() async {
    try {
      final response = await _serviceApi.getHelpers();
      List<Helper> helpers=[];
      for(final item in response){
        Map<String, dynamic> data= item.data();
        data["images"]=await Future.wait(List<String>.from(data["images"]).map((image) async=> await Utils.imageToBase64(image)).toList());
        helpers.add(Helper.fromJson(data));
      }
      return Success(helpers);
    } catch (e) {
      return Error(e);
    }
  }
}
