import 'package:app/api.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

class HomePage extends StatefulWidget {
  final bool isAuthenticated;
  HomePage({required this.isAuthenticated});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Ad?>(
        future:
            Future.delayed(Duration(seconds: 1), () => getAdById(5)),
        builder: (BuildContext context, AsyncSnapshot<Ad?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Отображаем индикатор загрузки пока данные загружаются
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Обработка ошибок, если они возникают
          } else {
            // Используйте полученные данные здесь
            List<Ad> list = [];
            Ad? ad = snapshot.data;
            print(ad!.id);
            list.add(ad);
            return Scaffold(
              appBar: appBar(),
              body: ListView(
                  children: list
                      .map((ad) => GestureDetector(
                            child: carCard(ad),
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AdvertismentWidget(
                                              isAuth: widget.isAuthenticated,
                                            ),
                                        settings:
                                            RouteSettings(arguments: ad)));
                              });
                            },
                          ))
                      .toList()),
            );
          }
        });
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
