import 'dart:convert';
import 'dart:io';

import 'package:app/public/constants.dart';
import 'package:app/public/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

post(url, body) async {
  var headers;
  SharedPreferences sp = await SharedPreferences.getInstance();
  var token = sp.getString('token');
  if (token == null) token = '';
  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: token.toString()
  };
  body = jsonEncode(body);
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response =
        await http.post(uri, headers: headers, body: body);
    var result = json.decode(response.body);
    return result;
  } catch (e) {
    return {'success': false, 'message': e};
  }
}

get(url) async {
  var headers;
  SharedPreferences sp = await SharedPreferences.getInstance();
  var token = sp.getString('token');
  if (token == null) token = '';
  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: token.toString()
  };
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response = await http.get(uri, headers: headers);
    var result = json.decode(response.body);
    return result;
  } catch (e) {
    return {'success': false, 'error': e};
  }
}

delete(url) async {
  var headers;
  SharedPreferences sp = await SharedPreferences.getInstance();
  var token = sp.getString('token');

  if (token == null) token = '';
  headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: token.toString()
  };
  try {
    var uri = Uri.parse(SERVER + url);
    final http.Response response = await http.delete(uri, headers: headers);
    var result = json.decode(response.body);
    return result;
  } catch (e) {
    return {'success': false, 'message': e};
  }
}
