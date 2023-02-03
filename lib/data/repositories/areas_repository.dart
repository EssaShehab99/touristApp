import 'package:tourist_app/data/models/area.dart';
import 'package:tourist_app/data/network/api/area_api.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/utils/utils.dart';

class AreasRepository {
  final AreaApi _areaApi;
  AreasRepository(this._areaApi);
  Future<Result> addArea(Area area) async {
    try {
      String? id = await _areaApi.addArea(area.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> updateArea(Area area) async {
    try {
      String? id = await _areaApi.updateArea(area.id, area.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> deleteArea(int id) async {
    try {
      return Success(await _areaApi.deleteArea(id));
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> getAreas({String? city}) async {
    try {
      final response = await _areaApi.getAreas(city: city);
      List<Area> areas = [];
      for (final item in response) {
        Map<String, dynamic> data = item.data();
        data["images"] = await Future.wait(List<String>.from(data["images"])
            .map((image) async => await Utils.imageToBase64(image))
            .toList());
        areas.add(Area.fromJson(data));
      }
      return Success(areas);
    } catch (e) {
      return Error(e);
    }
  }
}
