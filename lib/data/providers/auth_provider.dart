import 'package:flutter/material.dart';
import '/data/network/data_response.dart';
import '/data/models/user.dart';
import '/data/di/service_locator.dart';
import '/data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final _authRepository = getIt.get<AuthRepository>();
  User? _user;
  User? get user => _user;
  String? verificationId;
  Future<Result> signUp() async {
    if(_user==null)return Error();
    Result result = await _authRepository.signUp(_user!);
    if (result is Success) {
      _user = result.value;
    }
    return result;
  }

  Future<Result> signIn(String email, String password) async {
    Result result = await _authRepository.signIn(email, password);
    if (result is Success) {
      _user = result.value;
    }
    return result;
  }

  void setUser(User? user) {
    _user = user;
  }

  Future<void> signOut() async {
    Result result = await _authRepository.signOut();
    if (result is Success) {
      _user = null;
    }
  }


  Future<Result> sendCode(User user,bool withoutCheckUser) async {
    _user=user;
    return await _authRepository.sendCode(_user!.email,withoutCheckUser);
  }
  bool verifyCode(String code) {
    return _authRepository.verifyCode(code);
  }
  Future<bool> changePassword() async {
    return await _authRepository.changePassword(_user!.email, _user!.password!);
  }
}
