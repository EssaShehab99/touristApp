import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'constants/endpoint.dart';

class ServiceApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _fireStorage = FirebaseStorage.instance;

  Future<String?> addService(Map<String, dynamic> body) async {
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
          await _fireStore.collection(Endpoints.services).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> updateService(int id, Map<String, dynamic> body) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.services)
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
      await _fireStore.collection(Endpoints.services).doc(doc?.id).update(body);
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> deleteService(int id) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.services)
          .where("id", isEqualTo: id)
          .get();
      final doc = data.docs.firstOrNull;
      for (String url in (doc?.data()["images"] as List?) ?? []) {
        await _fireStorage.refFromURL(url).delete();
      }
      await _fireStore.collection(Endpoints.services).doc(doc?.id).delete();
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> addHelper(Map<String, dynamic> body) async {
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
          await _fireStore.collection(Endpoints.helpers).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> updateHelper(int id, Map<String, dynamic> body) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.helpers)
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
      await _fireStore.collection(Endpoints.helpers).doc(doc?.id).update(body);
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> deleteHelper(int id) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.helpers)
          .where("id", isEqualTo: id)
          .get();
      final doc = data.docs.firstOrNull;
      for (String url in (doc?.data()["images"] as List?) ?? []) {
        await _fireStorage.refFromURL(url).delete();
      }
      await _fireStore.collection(Endpoints.helpers).doc(doc?.id).delete();
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getServices() async {
    try {
      final response = await _fireStore.collection(Endpoints.services).get();
      return response.docs;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getHelpers() async {
    try {
      final response = await _fireStore.collection(Endpoints.helpers).get();
      return response.docs;
    } catch (e) {
      rethrow;
    }
  }
}
