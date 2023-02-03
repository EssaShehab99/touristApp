import 'dart:convert';

import '/data/network/http_exception.dart';
import 'package:flutter/foundation.dart';
import '/data/local/sharedpref_helper/preference_variable.dart';
import '/data/local/sharedpref_helper/preferences.dart';
import '/data/models/user.dart';
import '/data/network/data_response.dart';
import '/data/network/api/auth_api.dart';

class AuthRepository {
  final AuthApi _authApi;
  final _preferences = Preferences.instance;
  AuthRepository(this._authApi);

  Future<Result> signUp(User user) async {
    try {
      debugPrint(
          "==========AuthRepository->signUp->user:${user.toJson()} ==========");
      String? id = await _authApi.setUser(user.toJson());
      if (id == null) {
        return Error(ExistUserException());
      }
      await _preferences.delete(PreferenceVariable.user);
      await _preferences.insert(
          PreferenceVariable.user, jsonEncode(user.toJson()));
      return Success(user);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> signIn(String email, String password) async {
    try {
      debugPrint(
          "==========AuthRepository->signIn->email/password:$email / $password ==========");
      final response = await _authApi.getUser(email, password);
      final user = User.fromJson(response.data());
      await _preferences.delete(PreferenceVariable.user);
      await _preferences.insert(
          PreferenceVariable.user, jsonEncode(user.toJson()));
      return Success(user);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> signOut() async {
    try {
      bool status = await _preferences.delete(PreferenceVariable.user);
      return Success(status);
    } catch (e) {
      return Error(e);
    }
  }

  Future<Result> sendCode(String email, bool withoutCheckUser) async {
    try {
      if (withoutCheckUser ||
          (await _authApi.checkUser(email))?.data() == null) {
        bool status = await _authApi.sendCode(email);
        return Success(status);
      } else {
        return Error(ExistUserException());
      }
    } catch (e) {
      return Error(e);
    }
  }

  bool verifyCode(String code) {
    try {
      return _authApi.verifyCode(code);
    } catch (_) {
      return false;
    }
  }

  Future<bool> changePassword(String email, String password) async {
    try {
      return await _authApi.changePassword(email, {"password": password});
    } catch (_) {
      return false;
    }
  }
}
