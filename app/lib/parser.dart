import 'models.dart';

Ad parseAd(dynamic data) {
  Seller seller = Seller(data['user']['username'], data['user']['phone']);

  Engine engine = Engine(
      data['car']['engines'][0]['id'],
      data['car']['engines'][0]['type'],
      data['car']['engines'][0]['horse_power'],
      data['car']['engines'][0]['capacity'],
      data['car']['engines'][0]['torque'],
      data['car']['engines'][0]['fuel_consuption']);

  Suspension suspension = Suspension(
      data['car']['suspensions'][0]['id'],
      data['car']['suspensions'][0]['type'],
      data['car']['suspensions'][0]['clearance']);

  Gearbox gearbox = Gearbox(
      data['car']['gearboxes'][0]['id'],
      data['car']['gearboxes'][0]['type'],
      data['car']['gearboxes'][0]['gear_number']);

  Brand brand = Brand(data['car']['brand']['id'], data['car']['brand']['name']);

  Model model =
      Model(data['car']['model']['id'], brand, data['car']['model']['name']);

  Car car = Car(
      data['car']['id'],
      brand,
      model,
      engine,
      gearbox,
      suspension,
      data['car']['mileage'],
      data['car']['body_type'],
      data['car']['year'],
      data['car']['color'],
      data['car']['vin']);

  List<dynamic> rawImages = data['images'];
  List<String> images = [];
  for (var image in rawImages) {
    images.add(image['image']);
  }

  Ad ad = Ad(data['id'], data['price'], data['description'], data['status'],
      seller, car, images);

  return ad;
}