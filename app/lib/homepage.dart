import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CarModel> cars = [
    CarModel('Dodge', 'Challenger', 'pizdec\npizdec\npizdec\npizdec'),
    CarModel('Dodge', 'Charger', 'pizdec'),
    CarModel('bmw', 'm6', 'favorites'),
    CarModel('bmw', '7', 'favorites'),
    CarModel('audi', 'sq4', 'auction'),
    CarModel('audi', 'e-tron', 'auction'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
          children: cars
              .map((car) => GestureDetector(
                    child: carCard(car),
                    onTap: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AdvertismentWidget(),
                          settings: RouteSettings(arguments: car)
                          ));
                      });
                    },
                  ))
              .toList()),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Home',
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
    );
  }
}