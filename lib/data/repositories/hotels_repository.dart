import 'package:tourist_app/data/models/event.dart';
import 'package:tourist_app/data/models/hotel.dart';
import 'package:tourist_app/data/network/api/event_api.dart';
import 'package:tourist_app/data/network/api/hotel_api.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/utils/utils.dart';

class HotelsRepository {
  final HotelApi _hotelApi;
  HotelsRepository(this._hotelApi);
  Future<Result> addHotel(Hotel hotel) async {
    try {
      String? id = await _hotelApi.addHotel(hotel.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> updateHotel(Hotel hotel) async {
    try {
      String? id = await _hotelApi.updateHotel(hotel.id, hotel.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> deleteHotel(int id) async {
    try {
      return Success(await _hotelApi.deleteHotel(id));
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> getHotels({String? city}) async {
    try {
      final response = await _hotelApi.getHotels(city: city);
      List<Hotel> hotels = [];
      for (final item in response) {
        Map<String, dynamic> data = item.data();
        data["images"] = await Future.wait(List<String>.from(data["images"])
            .map((image) async => await Utils.imageToBase64(image))
            .toList());
        hotels.add(Hotel.fromJson(data));
      }
      return Success(hotels);
    } catch (e) {
      return Error(e);
    }
  }
  Future<Result> getHotel(int id) async {
    try {
      final response = await _hotelApi.getHotel(id);
      if (response?.data()!=null) {
        Hotel hotel=Hotel.fromJson(response!.data());
        return Success(hotel);
      }
      return Error();
    } catch (e) {
      return Error(e);
    }
  }
}
