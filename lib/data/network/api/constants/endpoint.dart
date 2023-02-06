class Endpoints {
  Endpoints._privateConstructor();
  static final Endpoints _instance = Endpoints._privateConstructor();
  static Endpoints get instance => _instance;

  static const int connectionTimeout = 300;
  static const users = 'users';
  static const services = 'services';
  static const helpers = 'helpers';
  static const areas = 'areas';
  static const event = 'events';
  static const request = 'request';

}