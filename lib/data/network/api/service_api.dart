import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'constants/endpoint.dart';

class ServiceApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final _fireStorage = FirebaseStorage.instance;

  Future<String?> addService(Map<String, dynamic> body) async {
    try {
      if (body["images"]!=null&& body["images"] is List) {
        List<String> images=[];
        for(String image in (body["images"] as List)){
          if(await File(image).exists()) {
            final uploadTask = await _fireStorage.ref("images/${DateTime.now().millisecondsSinceEpoch}").putFile(File(image));
            String url = await uploadTask.ref.getDownloadURL();
            images.add(url);
          }
        }
        body["images"] =images;
      }
      DocumentReference documentRef =
      await _fireStore.collection(Endpoints.services).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> addHelper(Map<String, dynamic> body) async {
    try {
      if (body["images"]!=null&& body["images"] is List) {
        List<String> images=[];
        for(String image in (body["images"] as List)){
          if(await File(image).exists()) {
            final uploadTask = await _fireStorage.ref("images/${DateTime.now().millisecondsSinceEpoch}").putFile(File(image));
            String url = await uploadTask.ref.getDownloadURL();
            images.add(url);
          }
        }
        body["images"] =images;
      }
      DocumentReference documentRef =
      await _fireStore.collection(Endpoints.helpers).add(body);
      return documentRef.id;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getServices() async {
    try {
      final response = await _fireStore
          .collection(Endpoints.services)
          .get();
      return response.docs;
    } catch (e) {
      rethrow;
    }
  }
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getHelpers() async {
    try {
      final response = await _fireStore
          .collection(Endpoints.helpers)
          .get();
      return response.docs;
    } catch (e) {
      rethrow;
    }
  }

}
