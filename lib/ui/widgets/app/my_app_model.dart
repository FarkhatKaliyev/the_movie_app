import 'package:the_movie_db/domain/data_providers/session_data_providre.dart';

class MyAppModel {
  final sessionDataProvider = SessionDataProvider();
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await sessionDataProvider.getSessionId();
    _isAuth = sessionId != null;
  }
}
