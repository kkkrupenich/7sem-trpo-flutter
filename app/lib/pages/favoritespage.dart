import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

class FavoritesPage extends StatefulWidget {
  final bool isAuthenticated;
  FavoritesPage({required this.isAuthenticated});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  List<CarModel> cars = [
    CarModel('bmw', 'm3', 'favorites'),
    CarModel('bmw', 'm5 e60', 'favorites'),
    CarModel('bmw', 'm6', 'favorites'),
    CarModel('bmw', '7', 'favorites'),
    CarModel('bmw', '8', 'favorites'),
    CarModel('bmw', 'xm', 'favorites'),
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
                          builder: (context) => AdvertismentWidget(isAuth: widget.isAuthenticated,),
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
      'Favorites',
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
