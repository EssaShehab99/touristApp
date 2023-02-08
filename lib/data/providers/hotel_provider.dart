import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/models/user.dart';
import 'package:tourist_app/data/repositories/hotels_repository.dart';
import 'package:tourist_app/data/utils/enum.dart';
import '/data/network/data_response.dart';
import '/data/di/service_locator.dart';

class HotelProvider extends ChangeNotifier {
  List<Hotel> hotels = [];
  HotelProvider(this._user);
  final User? _user;
  final _hotelsRepository = getIt.get<HotelsRepository>();
  Future<Result> addHotel(Hotel event) async {
    Result result = await _hotelsRepository.addHotel(event);
    if (result is Success) {
      await getHotels();
    }
    return result;
  }

  Future<Result> updateHotel(Hotel event) async {
    Result result = await _hotelsRepository.updateHotel(event);
    if (result is Success) {
      await getHotels();
    }
    return result;
  }

  Future<Result> deleteHotel(int id) async {
    Result result = await _hotelsRepository.deleteHotel(id);
    if (result is Success) {
      await getHotels();
    }
    return result;
  }

  Future<Result> getHotels() async {
    Result result = await _hotelsRepository.getHotels(
        city: _user?.userRole == UserRole.admin ? null : _user?.city);
    if (result is Success) {
      hotels = result.value;
      notifyListeners();
    }
    return result;
  }
}
