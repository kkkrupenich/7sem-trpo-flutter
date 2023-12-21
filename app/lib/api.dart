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

Future<bool> login(String username, String password) async {
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
    return true;
  } else {
    print('Ошибка: ${response.statusCode}');
    return false;
  }
}

Future<bool> register(String username, String email, String phone,
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
    return true;
  } else {
    print('Ошибка: ${response.statusCode}');
    return false;
  }
}

Future<List<Ad>?> getAllStatusAds() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/ads-status');

  final response =
      await http.get(url, headers: {'Content-Type': 'application/json'});

  String? token = await getTokenFromSharedPreferences();
  if (token != null) {
    final urlFavorite = Uri.parse('http://10.0.2.2:8000/api/get-favorite-ids');

    final responseFavorite = await http.get(
      urlFavorite,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );

    if (response.statusCode == 200) {
      dynamic data = json.decode(utf8.decode(response.bodyBytes))['ads'];
      List<Ad> result = [];
      for (var ad in data) {
        result.add(parseAd(
            ad,
            json.decode(
                utf8.decode(responseFavorite.bodyBytes))['favorite_ad_ids']));
      }
      return result;
    } else {
      return null;
    }
  }

  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes))['ads'];
    List<Ad> result = [];
    for (var ad in data) {
      result.add(parseAdnotLogin(ad));
    }
    return result;
  } else {
    return null;
  }
}

Future<List<Ad>?> getAllAds() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/all-ads');

  final response =
      await http.get(url, headers: {'Content-Type': 'application/json'});

  final urlFavorite = Uri.parse('http://10.0.2.2:8000/api/get-favorite-ids');

  String? token = await getTokenFromSharedPreferences();
  if (token != null) {
    final responseFavorite = await http.get(
      urlFavorite,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      dynamic data = json.decode(utf8.decode(response.bodyBytes))['ads'];
      print(json
          .decode(utf8.decode(responseFavorite.bodyBytes))['favorite_ad_ids']);
      List<Ad> result = [];
      for (var ad in data) {
        result.add(parseAd(
            ad,
            json.decode(
                utf8.decode(responseFavorite.bodyBytes))['favorite_ad_ids']));
      }
      return result;
    } else {
      return null;
    }
  }

  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes))['ads'];
    List<Ad> result = [];
    for (var ad in data) {
      result.add(parseAdnotLogin(ad));
    }
    return result;
  } else {
    return null;
  }
}

Future<List<Ad>?> getAllFavoriteAds() async {
  final urlFavorite = Uri.parse('http://10.0.2.2:8000/api/get-favorite-ids');

  String? token = await getTokenFromSharedPreferences();
  final responseFavorite = await http.get(
    urlFavorite,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token'
    },
  );

  final url = Uri.parse('http://10.0.2.2:8000/api/get-favorite');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Token $token'
    },
  );

  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes))['favorite_ads'];
    if (data == null) {
      return null;
    }

    List<Ad> result = [];
    for (var ad in data) {
      result.add(parseAd(
          ad,
          json.decode(
              utf8.decode(responseFavorite.bodyBytes))['favorite_ad_ids']));
    }
    return result;
  } else {
    return null;
  }
}

Future<void> addToFavoriteAds(int adId) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/toggle-favorite/$adId/');

  String? token = await getTokenFromSharedPreferences();

  final response = await http.post(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token'
  });

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<void> deleteFromFavoriteAds(int adId) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/toggle-favorite/$adId/');

  String? token = await getTokenFromSharedPreferences();

  final response = await http.delete(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Token $token'
  });

  if (response.statusCode == 200) {
    print(response.body);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<List<Auction>?> getAllAuctions() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/all-auctions');

  final response =
      await http.get(url, headers: {'Content-Type': 'application/json'});

  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes))['auctions'];
    List<Auction> result = [];
    for (var auction in data) {
      result.add(parseAuction(auction));
    }
    return result;
  } else {
    return null;
  }
}

Future<Ad?> getAdById(int id) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/get-ad/$id');

  final response =
      await http.get(url, headers: {'Content-Type': 'application/json'});

  final urlFavorite = Uri.parse('http://10.0.2.2:8000/api/get-favorite-ids');

  String? token = await getTokenFromSharedPreferences();
  if (token != null) {
    final responseFavorite = await http.get(
      urlFavorite,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
    );
    if (response.statusCode == 200) {
      dynamic data = json.decode(utf8.decode(response.bodyBytes))['ad'];

      return parseAd(
          data,
          json.decode(
              utf8.decode(responseFavorite.bodyBytes))['favorite_ad_ids']);
    } else {
      return null;
    }
  }

  if (response.statusCode == 200) {
    dynamic data = json.decode(utf8.decode(response.bodyBytes))['ad'];

    return parseAdnotLogin(data);
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
    'last_name': 'powelkozel'
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

Future<bool> placeBid(int bid, int auctionId) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/place-bid/$auctionId/');

  String? token = await getTokenFromSharedPreferences();

  Map<String, dynamic> body = {
    'amount': bid,
  };

  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
      body: jsonEncode(body));

  if (response.statusCode == 201) {
    print(response.body);
    return true;
  } else {
    print('Ошибка: ${response.statusCode}');
    return false;
  }
}

Future<void> createAd(
    String brand,
    String model,
    String engineType,
    int horsePower,
    double capacity,
    int torque,
    double fuelConsuption,
    String gearboxType,
    int gearNumber,
    String suspensionType,
    double clearance,
    int mileage,
    String bodyType,
    int year,
    String color,
    String vin,
    int price,
    String description) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/create-ad');

  String? token = await getTokenFromSharedPreferences();

  final Map<String, dynamic> adData = {
    'brand': {'selected_brand_name': brand},
    'model': {'selected_model_name': model},
    'engine': {
      'type': engineType,
      'horse_power': horsePower,
      'capacity': capacity,
      'torque': torque,
      'fuel_consuption': fuelConsuption,
    },
    'gearbox': {
      'type': gearboxType,
      'gear_number': gearNumber,
    },
    'suspension': {
      'type': suspensionType,
      'clearance': clearance,
    },
    'car': {
      'mileage': mileage,
      'body_type': bodyType,
      'year': year,
      'color': color,
      'vin': vin,
    },
    'price': price,
    'description': description,
  };

  print(jsonEncode(adData));

  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
      body: jsonEncode(adData));

  if (response.statusCode == 201) {
    print(response.body);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<void> createAuction(
    String brand,
    String model,
    String engineType,
    int horsePower,
    double capacity,
    int torque,
    double fuelConsuption,
    String gearboxType,
    int gearNumber,
    String suspensionType,
    double clearance,
    int mileage,
    String bodyType,
    int year,
    String color,
    String vin,
    int price,
    String description,
    String startDate,
    String endDate) async {
  final url = Uri.parse('http://10.0.2.2:8000/api/create-auction');

  String? token = await getTokenFromSharedPreferences();

  final Map<String, dynamic> adData = {
    'brand': {'selected_brand_name': brand},
    'model': {'selected_model_name': model},
    'engine': {
      'type': engineType,
      'horse_power': horsePower,
      'capacity': capacity,
      'torque': torque,
      'fuel_consuption': fuelConsuption,
    },
    'gearbox': {
      'type': gearboxType,
      'gear_number': gearNumber,
    },
    'suspension': {
      'type': suspensionType,
      'clearance': clearance,
    },
    'car': {
      'mileage': mileage,
      'body_type': bodyType,
      'year': year,
      'color': color,
      'vin': vin,
    },
    'price': price,
    'description': description,
    'start_date': startDate,
    'end_date': endDate
  };

  print(jsonEncode(adData));

  final response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token'
      },
      body: jsonEncode(adData));

  if (response.statusCode == 201) {
    print(response.body);
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}

Future<List<Brand>?> getAllBrands() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/get-brands');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<Brand> list = []; 
    for (var brand in jsonDecode(response.body)['brands']) {
      Brand tmp = Brand(brand['id'], brand['name']);
      list.add(tmp);
    }

    return list;
  } else {
    print(response.statusCode);
    return null;
  }
}

Future<List<Model>?> getAllModels() async {
  final url = Uri.parse('http://10.0.2.2:8000/api/get-models');

  final response = await http.get(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    List<Model> list = [];
    for (var model in jsonDecode(response.body)['models']) {
      Model tmp = Model(model['id'], Brand(model['brand']['id'], model['brand']['name']), model['name']);
      list.add(tmp);
    }
    return list;
  } else {
    print(response.statusCode);
    return null;
  }
}