import 'package:app/apis/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static loignjwt() async {
    var res = await get('/api/user/loginjwt');
    return res;
  }
}
