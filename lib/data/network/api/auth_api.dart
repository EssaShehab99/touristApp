import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_otp/email_otp.dart';
import 'package:flutter/foundation.dart';
import '/data/utils/extension.dart';
import 'constants/endpoint.dart';

class AuthApi {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  EmailOTP myauth = EmailOTP();
  Future<String?> setUser(Map<String, dynamic> body) async {
    try {
      if ((await checkUser(body["email"]))?.data() == null) {
        DocumentReference documentRef =
            await _fireStore.collection(Endpoints.users).add(body);
        return documentRef.id;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> sendCode(String email) async {
    try {
      debugPrint("=============AuthApi->sendCode =============");
      myauth.setConfig(
          appEmail: "app.program99@gmail.com",
          appName: "TU Smart Services",
          userEmail: email,
          otpLength: 6,
          otpType: OTPType.digitsOnly);
      return await await myauth.sendOTP();
    } catch (e) {
      rethrow;
    }
  }


  bool verifyCode(String code) {
    try {
      return myauth.verifyOTP(
        otp: code,
      );
    } catch (_) {
      return false;
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>> getUser(
      String email, String password) async {
    try {
      final response = await _fireStore
          .collection(Endpoints.users)
          .get();
      return response.docs.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> checkUser(String email) async {
    try {
      final response = await _fireStore
          .collection(Endpoints.users)
          .where("email", isEqualTo: email)
          .get();
      return response.docs.firstOrNull;
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> changePassword(String email,Map<String, dynamic> body) async {
    try {
      final response=  await _fireStore
          .collection(Endpoints.users)
          .where("email", isEqualTo: email)
          .get();
      await _fireStore
          .collection(Endpoints.users).doc(response.docs.firstOrNull?.id).update(body);
      return true;
    } catch (e) {
      rethrow;
    }
  }
}
