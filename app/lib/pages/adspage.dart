import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

class AdvertismentsPage extends StatefulWidget {
  final bool isAuthenticated;
  AdvertismentsPage({required this.isAuthenticated});

  @override
  State<AdvertismentsPage> createState() => _AdvertismentsPageState();  
}



class _AdvertismentsPageState extends State<AdvertismentsPage> {
  List<CarModel> cars = [
    CarModel('dodge', 'challenger', 'pizdec\npizdec\npizdec\npizdec'),
    CarModel('dodge', 'charger', 'pizdec'),
    CarModel('dodge', 'durango', 'pizdec'),
    CarModel('dodge', 'asd', 'pizdec'),
    CarModel('dodge', 'fds', 'pizdec'),
    CarModel('dodge', '13123', 'pizdec'),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdvertismentWidget(isAuth: widget.isAuthenticated,),
                                settings: RouteSettings(arguments: car)));
                      });
                    },
                  ))
              .toList()),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Advertisments',
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            if (widget.isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAdvertisementPage()),
              );
            }
          },
        ),
      ],
    );
  }
}
