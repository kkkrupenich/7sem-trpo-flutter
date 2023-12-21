import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';
import 'package:app/api.dart';

class AdvertismentsPage extends StatefulWidget {
  final bool isAuthenticated;
  AdvertismentsPage({required this.isAuthenticated});

  @override
  State<AdvertismentsPage> createState() => _AdvertismentsPageState();
}

class _AdvertismentsPageState extends State<AdvertismentsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Ad>?>(
        future: Future.delayed(Duration(milliseconds: 100), () => getAllAds()),
        builder: (BuildContext context, AsyncSnapshot<List<Ad>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Отображаем индикатор загрузки пока данные загружаются
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Обработка ошибок, если они возникают
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Text('NO DATA');
          } else {
            // Используйте полученные данные здесь
            List<Ad>? list = snapshot.data;
            return Scaffold(
              appBar: appBar(),
              body: ListView(
                  children: list!
                      .map((ad) => GestureDetector(
                            child: carCard(ad),
                            onTap: () {
                              setState(() {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdvertismentWidget(
                                                  isAuth:
                                                      widget.isAuthenticated,
                                                ),
                                            settings:
                                                RouteSettings(arguments: ad)))
                                    .then((value) {
                                  if (value != null && value == 'updated') {
                                    setState(() {
                                      Future.delayed(
                                          Duration(milliseconds: 100),
                                          () => getAllAds());
                                    });
                                  }
                                });
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
                MaterialPageRoute(
                    builder: (context) => CreateAdvertisementPage()),
              ).then((value) {
                if (value != null && value == 'updated') {
                  setState(() {
                    Future.delayed(
                        Duration(milliseconds: 100), () => getAllAds());
                  });
                }
              });
            }
          },
        ),
      ],
    );
  }
}
