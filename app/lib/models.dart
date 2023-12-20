class CarModel {
  String brand;
  String model;
  String description;

  CarModel(this.brand, this.model, this.description);
}

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

  Ad(this.id, this.price, this.description, this.status, this.seller, this.car, this.images);
}