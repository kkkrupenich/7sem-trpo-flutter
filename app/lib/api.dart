import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models.dart';
import 'parser.dart';

Future<String?> getTokenFromSharedPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

void saveTokenToSharedPreferences(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

void removeTokenFromSharedPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('token');
}

void saveUserDataToSecureStorage(
    String name, String email, String phone, String firstname) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'username', value: name);
  await storage.write(key: 'email', value: email);
  await storage.write(key: 'phone', value: phone);
  await storage.write(key: 'firstname', value: firstname);
}

void updateUserDataToSecureStorage(
    String email, String phone, String firstname) async {
  final storage = FlutterSecureStorage();

  await storage.write(key: 'email', value: email);
  await storage.write(key: 'phone', value: phone);
  await storage.write(key: 'firstname', value: firstname);
}

Future<void> clearUserDataFromSecureStorage() async {
  final storage = FlutterSecureStorage();
  await storage.deleteAll();
}

Future<void> login(String username, String password) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/login');

  Map<String, dynamic> body = {
    'username': username,
    'password': password,
  };

  print(jsonEncode(body));
  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

  if (response.statusCode == 200) {
    print(response.body);
    print(json.decode(utf8.decode(response.bodyBytes))['token']);
    saveTokenToSharedPreferences(
        json.decode(utf8.decode(response.bodyBytes))['token']);
    saveUserDataToSecureStorage(
        json.decode(utf8.decode(response.bodyBytes))['user']['username'],
        json.decode(utf8.decode(response.bodyBytes))['user']['email'],
        json.decode(utf8.decode(response.bodyBytes))['user']['phone'],
        json.decode(utf8.decode(response.bodyBytes))['user']['first_name']);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<void> register(String username, String email, String phone,
    String firstname, String password) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/signup');

  Map<String, dynamic> body = {
    'username': username,
    'email': email,
    'first_name': firstname,
    'phone': phone,
    'password': password
  };

  print(jsonEncode(body));
  final response = await http.post(url,
      headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));

  if (response.statusCode == 201) {
    print(response.body);
    print(json.decode(utf8.decode(response.bodyBytes))['token']);
    saveTokenToSharedPreferences(
        json.decode(utf8.decode(response.bodyBytes))['token']);
    saveUserDataToSecureStorage(
        json.decode(utf8.decode(response.bodyBytes))['user']['username'],
        json.decode(utf8.decode(response.bodyBytes))['user']['email'],
        json.decode(utf8.decode(response.bodyBytes))['user']['phone'],
        json.decode(utf8.decode(response.bodyBytes))['user']['first_name']);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<void> getAllStatusAds() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/ads-status');

  String? token = await getTokenFromSharedPreferences();

  final response = await http.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token'
  });

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<Ad?> getAdById(int id) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/get-ad/$id');

  final response =
      await http.get(url, headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes))['ad'];

    return parseAd(data);
  } else {
    return null;
  }
}

Future<void> update(String email, String phone, String firstname) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/update');

  Map<String, dynamic> body = {
    'email': email,
    'first_name': firstname,
    'phone': phone,
    'last_name': 'powelnahuikozel'
  };

  String? token = await getTokenFromSharedPreferences();

  print(jsonEncode(body));
  final response = await http.put(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
      body: jsonEncode(body));

  if (response.statusCode == 200) {
    print(response.body);

    updateUserDataToSecureStorage(
        json.decode(utf8.decode(response.bodyBytes))['user']['email'],
        json.decode(utf8.decode(response.bodyBytes))['user']['phone'],
        json.decode(utf8.decode(response.bodyBytes))['user']['first_name']);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}
