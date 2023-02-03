import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/area.dart';
import 'package:tourist_app/data/models/user.dart';
import 'package:tourist_app/data/repositories/areas_repository.dart';
import 'package:tourist_app/data/utils/enum.dart';
import '/data/network/data_response.dart';
import '/data/di/service_locator.dart';

class AreaProvider extends ChangeNotifier {
  List<Area> areas = [];
  AreaProvider(this._user);
  final User? _user;
  final _areasRepository = getIt.get<AreasRepository>();
  Future<Result> addArea(Area area) async {
    Result result = await _areasRepository.addArea(area);
    if (result is Success) {
      await getAreas();
    }
    return result;
  }

  Future<Result> updateArea(Area area) async {
    Result result = await _areasRepository.updateArea(area);
    if (result is Success) {
      await getAreas();
    }
    return result;
  }

  Future<Result> deleteArea(int id) async {
    Result result = await _areasRepository.deleteArea(id);
    if (result is Success) {
      await getAreas();
    }
    return result;
  }

  Future<Result> getAreas() async {
    Result result = await _areasRepository.getAreas(
        city: _user?.userRole == UserRole.admin ? null : _user?.city);
    if (result is Success) {
      areas = result.value;
      notifyListeners();
    }
    return result;
  }
}
