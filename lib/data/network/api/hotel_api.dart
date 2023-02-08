import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'constants/endpoint.dart';

class HotelApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _fireStorage = FirebaseStorage.instance;

  Future<String?> addHotel(Map<String, dynamic> body) async {
    try {
      if (body["images"] != null && body["images"] is List) {
        List<String> images = [];
        for (String image in (body["images"] as List)) {
          final uploadTask = await _fireStorage
              .ref("images/${DateTime.now().millisecondsSinceEpoch}")
              .putString(image, format: PutStringFormat.base64);
          String url = await uploadTask.ref.getDownloadURL();
          images.add(url);
        }
        body["images"] = images;
      }
      DocumentReference documentRef =
          await _fireStore.collection(Endpoints.hotel).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> updateHotel(int id, Map<String, dynamic> body) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.hotel)
          .where("id", isEqualTo: id)
          .get();
      final doc = data.docs.firstOrNull;
      for (String url in (doc?.data()["images"] as List?) ?? []) {
        await _fireStorage.refFromURL(url).delete();
      }
      if (body["images"] != null && body["images"] is List) {
        List<String> images = [];
        for (String image in (body["images"] as List)) {
          final uploadTask = await _fireStorage
              .ref("images/${DateTime.now().millisecondsSinceEpoch}")
              .putString(image, format: PutStringFormat.base64);
          String url = await uploadTask.ref.getDownloadURL();
          images.add(url);
        }
        body["images"] = images;
      }
      await _fireStore.collection(Endpoints.hotel).doc(doc?.id).update(body);
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> deleteHotel(int id) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.hotel)
          .where("id", isEqualTo: id)
          .get();
      final doc = data.docs.firstOrNull;
      for (String url in (doc?.data()["images"] as List?) ?? []) {
        await _fireStorage.refFromURL(url).delete();
      }
      await _fireStore.collection(Endpoints.hotel).doc(doc?.id).delete();
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getHotels(
      {String? city}) async {
    try {
      final response = await _fireStore
          .collection(Endpoints.hotel)
          .where(city == null ? "" : "city", isEqualTo: city)
          .get();

      return response.docs;
    } catch (e) {
      rethrow;
    }
  }
  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getHotel(int id) async {
    try {
      final response = await _fireStore
          .collection(Endpoints.hotel)
          .where("id",isEqualTo: id)
          .get();

      return response.docs.firstOrNull;
    } catch (e) {
      rethrow;
    }
  }
}
