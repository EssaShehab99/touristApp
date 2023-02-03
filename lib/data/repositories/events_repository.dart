import 'package:tourist_app/data/models/event.dart';
import 'package:tourist_app/data/network/api/event_api.dart';
import 'package:tourist_app/data/network/data_response.dart';
import 'package:tourist_app/data/utils/utils.dart';

class EventsRepository {
  final EventApi _eventApi;
  EventsRepository(this._eventApi);
  Future<Result> addEvent(Event area) async {
    try {
      String? id = await _eventApi.addEvent(area.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> updateEvent(Event event) async {
    try {
      String? id = await _eventApi.updateEvent(event.id, event.toJson());
      return Success(id);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> deleteEvent(int id) async {
    try {
      return Success(await _eventApi.deleteEvent(id));
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> getEvents({String? city}) async {
    try {
      final response = await _eventApi.getEvents(city: city);
      List<Event> events = [];
      for (final item in response) {
        Map<String, dynamic> data = item.data();
        data["images"] = await Future.wait(List<String>.from(data["images"])
            .map((image) async => await Utils.imageToBase64(image))
            .toList());
        events.add(Event.fromJson(data));
      }
      return Success(events);
    } catch (e) {
      return Error(e);
    }
  }
}
