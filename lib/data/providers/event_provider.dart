import 'package:flutter/material.dart';
import 'package:tourist_app/data/models/area.dart';
import 'package:tourist_app/data/models/event.dart';
import 'package:tourist_app/data/models/user.dart';
import 'package:tourist_app/data/repositories/areas_repository.dart';
import 'package:tourist_app/data/repositories/events_repository.dart';
import 'package:tourist_app/data/utils/enum.dart';
import '/data/network/data_response.dart';
import '/data/di/service_locator.dart';

class EventProvider extends ChangeNotifier {
  List<Event> events = [];
  EventProvider(this._user);
  final User? _user;
  final _eventsRepository = getIt.get<EventsRepository>();
  Future<Result> addEvent(Event event) async {
    Result result = await _eventsRepository.addEvent(event);
    if (result is Success) {
      await getEvents();
    }
    return result;
  }

  Future<Result> updateEvent(Event event) async {
    Result result = await _eventsRepository.updateEvent(event);
    if (result is Success) {
      await getEvents();
    }
    return result;
  }

  Future<Result> deleteEvent(int id) async {
    Result result = await _eventsRepository.deleteEvent(id);
    if (result is Success) {
      await getEvents();
    }
    return result;
  }

  Future<Result> getEvents() async {
    Result result = await _eventsRepository.getEvents(
        city: _user?.userRole == UserRole.admin ? null : _user?.city);
    if (result is Success) {
      events = result.value;
      notifyListeners();
    }
    return result;
  }
}
