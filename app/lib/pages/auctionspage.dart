import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

class AuctionsPage extends StatefulWidget {
  const AuctionsPage({Key? key}) : super(key: key);

  @override
  State<AuctionsPage> createState() => _AuctionsPageState();
}

class _AuctionsPageState extends State<AuctionsPage> {
  List<CarModel> cars = [
    CarModel('audi', 'rs6', 'auction'),
    CarModel('audi', 'a4', 'auction'),
    CarModel('audi', 'r8', 'auction'),
    CarModel('audi', 'q3', 'auction'),
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
                    child: carCardForAuc(car),
                    onTap: () {
                      setState(() {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const AuctionWidget(),
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
      'Auctions',
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
          icon: Icon(Icons.add, color: Colors.white,),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateAuctionPage()),
            );
          },
        ),
      ],
  );
}
}
