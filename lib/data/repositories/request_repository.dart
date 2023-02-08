import 'package:tourist_app/data/models/helper.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/models/request.dart';
import 'package:tourist_app/data/network/api/hotel_api.dart';
import 'package:tourist_app/data/network/api/request_api.dart';
import 'package:tourist_app/data/network/api/service_api.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/repositories/service_repository.dart';
import 'package:tourist_app/data/utils/enum.dart';

class RequestRepository {
  final RequestApi _requestApi;
  final ServiceApi _serviceApi;
  final HotelApi _hotelApi;
  RequestRepository(this._requestApi, this._serviceApi,this._hotelApi);
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
      String? id =
          await _requestApi.updateRequest(request.id, request.toJson());
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
        final request = Request.fromJson(data);
        if (request.requestType == RequestType.helper) {
          final response = await _serviceApi.getHelper(request.typeID);
          if (response?.data() != null) {
            request.value = Helper.fromJson(response!.data());
          }
          requests.add(request);
        }else if (request.requestType == RequestType.hotel) {
          final response = await _hotelApi.getHotel(request.typeID);
          if (response?.data() != null) {
            request.value = Hotel.fromJson(response!.data());
          }
          requests.add(request);
        }
      }

      return Success(requests);
    } catch (e) {
      return Error(e);
    }
  }
}
