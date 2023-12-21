import 'package:app/api.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets.dart';

class AuctionsPage extends StatefulWidget {
  final bool isAuthenticated;
  AuctionsPage({required this.isAuthenticated});

  @override
  State<AuctionsPage> createState() => _AuctionsPageState();
}

class _AuctionsPageState extends State<AuctionsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Auction>?>(
      future:
          Future.delayed(Duration(milliseconds: 100), () => getAllAuctions()),
      builder: (BuildContext context, AsyncSnapshot<List<Auction>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error} ${snapshot.data}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text(
              'No data available'); // Обработка случая, когда данных нет
        } else {
          List<Auction> list = [];
          for (var auc in snapshot.data!) {
            if (DateTime.parse(auc.endDate).isAfter(DateTime.now())) {
              list.add(auc);
            }
          }
          return Scaffold(
            appBar: appBar(),
            body: ListView(
              children: list.map((auction) {
                return GestureDetector(
                  child: carCardForAuc(auction),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuctionWidget(
                          isAuth: widget.isAuthenticated,
                        ),
                        settings: RouteSettings(arguments: auction),
                      ),
                    ).then((value) {
                      if (value != null && value == 'updated') {
                        setState(() {
                          Future.delayed(Duration(milliseconds: 100),
                              () => getAllAuctions());
                        });
                      }
                    });
                  },
                );
              }).toList(),
            ),
          );
        }
      },
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
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            if (widget.isAuthenticated) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateAuctionPage()),
              ).then((value) {
                if (value != null && value == 'updated') {
                  setState(() {
                    Future.delayed(
                        Duration(milliseconds: 100), () => getAllAuctions());
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
