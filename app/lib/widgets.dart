import 'package:flutter/material.dart';
import 'models.dart';

Widget carCard(ad) {
  return Card(
    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 200, 200, 200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${ad.car.brand.name} ${ad.car.model.name}',
                style: TextStyle(
                  fontSize: 22,
                )),
            Text('${ad.price} р.', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Image.network('http://10.0.2.2:8000/${ad.images.first}'),
            SizedBox(height: 10),
            Text('${ad.car.year} г., ${ad.car.gearbox.type.toString().toLowerCase()}, ${ad.car.engine.capacity} л., ${ad.car.engine.type.toString().toLowerCase()}, ${ad.car.bodyType.toString().toLowerCase()}',
                maxLines: 3, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}

Widget carCardForAuc(car) {
  return Card(
    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
    child: Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(100, 200, 200, 200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${car.brand} ${car.model}',
                style: TextStyle(
                  fontSize: 22,
                )),
            Text('Начальная ставка: 5000 руб.', style: TextStyle(fontSize: 16)),
            Text('Текущая ставка: 10000 руб.', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Image.asset('assets/merc.webp'),
            SizedBox(height: 10),
            Text('1998 г., механика, 1.6 л., бензин, купе',
                maxLines: 3, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}

class AdvertismentWidget extends StatelessWidget {
  final bool isAuth;
  AdvertismentWidget({required this.isAuth});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as Ad;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Ad', style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.favorite_outline),
            onPressed: () {
              if (isAuth) {
                print('favorite');
              }
            },
          ),
        ],
      ),
      body: stackWidget(car, context),
    );
  }

  Stack stackWidget(Ad ad, BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(100, 200, 200, 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ad.car.brand.name} ${ad.car.model.name}',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              Text(
                                '${ad.price} р.',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '  ≈ ${ad.price/3.3}\$',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ]),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: ad.images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        'http://10.0.2.2:8000/${ad.images[index]}',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Color.fromARGB(255, 200, 200, 200),
                height: 30,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  '${ad.car.year} г., ${ad.car.gearbox.type.toLowerCase()}, ${ad.car.engine.capacity.toString().toLowerCase()} л., ${ad.car.engine.type.toLowerCase()}, ${ad.car.mileage} км, ${ad.car.bodyType}, ${ad.car.color}',
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Color.fromARGB(255, 200, 200, 200),
                thickness: 2,
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  ad.description,
                  maxLines: 100,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 20, // Adjust the top position
        left: 20, // Adjust the right position
        child: GestureDetector(
            onTap: () {
              showInfoDialog(context, ad.seller);
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 189, 88),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Call seller',
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )),
      ),
    ]);
  }

  Future<void> showInfoDialog(BuildContext context, dynamic seller) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Информация'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Продавец: ${seller.name}'),
              SizedBox(height: 10),
              Text('Номер телефона: ${seller.phone}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Закрыть'),
              onPressed: () {
                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
            ),
          ],
        );
      },
    );
  }
}

class AuctionWidget extends StatelessWidget {
  const AuctionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as CarModel;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Auction', style: TextStyle(color: Colors.white)),
      ),
      body: stackWidget(car, context),
    );
  }

  void placeBid(String enteredText) {
    print('Введенный текст: $enteredText');
  }

  Stack stackWidget(CarModel car, BuildContext context) {
    return Stack(children: [
      SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(100, 200, 200, 200),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${car.brand} ${car.model}',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Начальная ставка: 50 000 р.',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            'Текущая ставка 70 000 р.',
                            style: TextStyle(fontSize: 22),
                          ),
                        ]),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: 5,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        'assets/merc.webp',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Color.fromARGB(255, 200, 200, 200),
                height: 30,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  '1998 г., механика, 1.6 л, бензин, 300000 км, купе, передний привод, синий, снят с учета',
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 22),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Color.fromARGB(255, 200, 200, 200),
                thickness: 2,
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Кузов в достойном состоянии (отражено на фото), передние крылья из пластика (про корозиию можно забыть), мотор как часы,заводиться на холодную и горячюю без проблем,новое лобовое( в которое прекрасно видно,а не затертое родное!!! Новые передние тормозные диски и колодки.в машине делать ничего не надо,сел и поехал.адекватный торг имееться... Кузов в достойном состоянии (отражено на фото), передние крылья из пластика (про корозиию можно забыть), мотор как часы,заводиться на холодную и горячюю без проблем,новое лобовое( в которое прекрасно видно,а не затертое родное!!! Новые передние тормозные диски и колодки.в машине делать ничего не надо,сел и поехал.адекватный торг имееться...',
                  maxLines: 100,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
      Positioned(
        bottom: 20, // Adjust the top position
        left: 20, // Adjust the right position
        child: GestureDetector(
            onTap: () {
              showInputDialog(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 20, 189, 88),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Place a bid',
                  style: TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            )),
      ),
    ]);
  }

  Future<void> showInputDialog(BuildContext context) async {
    TextEditingController textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите что-то'),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: 'Введите здесь'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Подтвердить'),
              onPressed: () {
                String enteredText = textFieldController.text;
                placeBid(enteredText);

                Navigator.of(context).pop(); // Закрыть диалоговое окно
              },
            ),
          ],
        );
      },
    );
  }
}

class CreateAdvertisementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Advertisement'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Здесь можно добавить логику выхода из страницы и возврата назад
            Navigator.pop(context);
          },
          child: Text('Создать'),
        ),
      ),
    );
  }
}

class CreateAuctionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Auction'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Здесь можно добавить логику выхода из страницы и возврата назад
            Navigator.pop(context);
          },
          child: Text('Создать'),
        ),
      ),
    );
  }
}