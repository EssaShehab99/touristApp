import 'package:tourist_app/data/utils/enum.dart';

class Request {
  int id;
  DateTime from;
  DateTime to;
  String phone;
  String details;
  bool? isWithHome;
  String userName;
  RequestType requestType;
  int typeID;
  RequestStatus status;

  Request(
      {required this.id,
      required this.from,
      required this.to,
      required this.phone,
      required this.requestType,
      required this.typeID,
      required this.details,
      required this.status,
      required this.userName,
      this.isWithHome});

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json["id"],
      from: DateTime.parse(json["from"]),
      to: DateTime.parse(json["to"]),
      phone: json["phone"],
      details: json["details"],
      requestType: (){
        if(json["type"]==RequestType.hotel.name){
          return RequestType.hotel;
        }
        else{
          return RequestType.helper;
        }
      }(),
      status: (){
        if(json["status"]==RequestStatus.accept.name){
          return RequestStatus.accept;
        }
        else if(json["status"]==RequestStatus.reject.name){
          return RequestStatus.reject;
        }
        return RequestStatus.none;
      }(),
      userName: json["userName"],
      typeID: json["typeID"],
      isWithHome: json["isWithHome"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "from": from.toIso8601String(),
      "to": to.toIso8601String(),
      "phone": phone,
      "details": details,
      "requestType": requestType.name,
      "status": status.name,
      "typeID": typeID,
      "userName": userName,
      "isWithHome": isWithHome,
    };
  }
}
