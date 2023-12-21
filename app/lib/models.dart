class Seller {
  String name;
  String phone;

  Seller(this.name, this.phone);
}

class Brand {
  int id;
  String name;

  Brand(this.id, this.name);
}

class Model {
  int id;
  Brand brand;
  String name;

  Model(this.id, this.brand, this.name);
}

class Engine {
  int id;
  String type;
  int horsePower;
  double capacity;
  int torque;
  double fuelConsumption;

  Engine(this.id, this.type, this.horsePower, this.capacity, this.torque, this.fuelConsumption);
}

class Gearbox {
  int id;
  String type;
  int gearNumber;

  Gearbox(this.id, this.type, this.gearNumber);
}

class Suspension {
  int id;
  String type;
  double clearance;

  Suspension(this.id, this.type, this.clearance);
}

class Car {
  int id;
  Brand brand;
  Model model;
  Engine engine;
  Gearbox gearbox;
  Suspension suspension;
  int mileage;
  String bodyType;
  int year;
  String color;
  String vin;

  Car(this.id, this.brand, this.model, this.engine, this.gearbox, this.suspension, this.mileage, this.bodyType, this.year, this.color, this.vin);
}

class Ad {
  int id;
  int price;
  String description;
  bool status;
  Seller seller;
  Car car;
  List<String> images;
  bool isFavorite;

  Ad(this.id, this.price, this.description, this.status, this.seller, this.car, this.images, this.isFavorite);
}

class Bid {
  int id;
  int amount;
  String date;
  int buyer;

  Bid(this.id, this.amount, this.date, this.buyer);
}

class Auction {
  int id;
  int price;
  String description;
  Seller seller;
  Car car;
  String startDate;
  String endDate;
  List<String> images;
  Bid? bid;

  Auction(this.id, this.price, this.description, this.seller, this.car, this.startDate, this.endDate, this.images, this.bid);
}