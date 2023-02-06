import 'package:tourist_app/data/models/request.dart';
import 'package:tourist_app/data/network/api/request_api.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/utils/enum.dart';

class RequestRepository {
  final RequestApi _requestApi;
  RequestRepository(this._requestApi);
  Future<Result> addRequest(Request request) async {
    try {
      String? id = await _requestApi.addRequest(request.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> updateRequest(Request request) async {
    try {
      String? id = await _requestApi.updateRequest(request.id, request.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> deleteRequest(int id) async {
    try {
      return Success(await _requestApi.deleteRequest(id));
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> getRequests(RequestType requestType) async {
    try {
      final response = await _requestApi.getRequests(requestType);
      List<Request> requests = [];
      for (final item in response) {
        Map<String, dynamic> data = item.data();
        requests.add(Request.fromJson(data));
      }
      return Success(requests);
    } catch (e) {
      return Error(e);
    }
  }
}
