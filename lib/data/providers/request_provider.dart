import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/user.dart';
import 'package:tourist_app/data/repositories/request_repository.dart';
import 'package:tourist_app/data/utils/enum.dart';
import '/data/network/data_response.dart';
import '/data/di/service_locator.dart';
import 'package:tourist_app/data/models/request.dart';

class RequestProvider extends ChangeNotifier {
  List<Request> requests = [];
  RequestProvider(this._user);
  final User? _user;
  final _requestRepository = getIt.get<RequestRepository>();
  Future<Result> addRequest(Request request,RequestType requestType) async {
    Result result = await _requestRepository.addRequest(request);
    if (result is Success) {
      await getRequests(requestType);
    }
    return result;
  }

  Future<Result> updateRequest(Request request,RequestType requestType) async {
    Result result = await _requestRepository.updateRequest(request);
    if (result is Success) {
      await getRequests(requestType);
    }
    return result;
  }

  Future<Result> deleteRequest(int id,RequestType requestType) async {
    Result result = await _requestRepository.deleteRequest(id);
    if (result is Success) {
      await getRequests(requestType);
    }
    return result;
  }

  Future<Result> getRequests(RequestType requestType) async {
    Result result = await _requestRepository.getRequests(requestType);
    if (result is Success) {
      requests = result.value;
      notifyListeners();
    }
    return result;
  }
}
