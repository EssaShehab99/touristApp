import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tourist_app/data/utils/enum.dart';
import 'package:tourist_app/data/utils/extension.dart';
import 'constants/endpoint.dart';

class RequestApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<String?> addRequest(Map<String, dynamic> body) async {
    try {
      DocumentReference documentRef =
          await _fireStore.collection(Endpoints.request).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> updateRequest(int id, Map<String, dynamic> body) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.request)
          .where("id", isEqualTo: id)
          .get();
      final doc = data.docs.firstOrNull;
      await _fireStore.collection(Endpoints.request).doc(doc?.id).update(body);
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> deleteRequest(int id) async {
    try {
      final data = await _fireStore
          .collection(Endpoints.request)
          .where("id", isEqualTo: id)
          .get();
      final doc = data.docs.firstOrNull;
      await _fireStore.collection(Endpoints.request).doc(doc?.id).delete();
      return doc?.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getRequests(RequestType requestType) async {
    try {
      final response = await _fireStore.collection(Endpoints.request)
          .where("requestType",isEqualTo: requestType.name)
          .get();
      return response.docs;
    } catch (e) {
      rethrow;
    }
  }
}
