import 'package:flutter/material.dart';
import 'models.dart';
import 'api.dart';
import 'package:intl/intl.dart';

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
            Image.network(ad.images.length > 0
                ? 'http://10.0.2.2:8000/${ad.images.first}'
                : 'https://www.linearity.io/blog/content/images/size/w1576/format/avif/2023/06/how-to-create-a-car-NewBlogCover.png'),
            SizedBox(height: 10),
            Text(
                '${ad.car.year} г., ${ad.car.gearbox.type.toString().toLowerCase()}, ${ad.car.engine.capacity} л., ${ad.car.engine.type.toString().toLowerCase()}, ${ad.car.bodyType.toString().toLowerCase()}',
                maxLines: 3,
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}

Widget carCardForAuc(auction) {
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
            Text('${auction.car.brand.name} ${auction.car.model.name}',
                style: TextStyle(
                  fontSize: 22,
                )),
            Text('Начальная ставка: ${auction.price} руб.',
                style: TextStyle(fontSize: 16)),
            if (auction.bid != null)
              Text('Текущая ставка: ${auction.bid.amount} руб.',
                  style: TextStyle(fontSize: 16))
            else
              Text('Текущая ставка: -', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Image.network(auction.images.length > 0
                ? 'http://10.0.2.2:8000/${auction.images.first}'
                : 'https://www.linearity.io/blog/content/images/size/w1576/format/avif/2023/06/how-to-create-a-car-NewBlogCover.png'),
            SizedBox(height: 10),
            Text(
                '${auction.car.year} г., ${auction.car.gearbox.type.toString().toLowerCase()}, ${auction.car.engine.capacity} л., ${auction.car.engine.type.toString().toLowerCase()}, ${auction.car.bodyType.toString().toLowerCase()}',
                maxLines: 3,
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    ),
  );
}

class AdvertismentWidget extends StatefulWidget {
  final bool isAuth;
  AdvertismentWidget({required this.isAuth});

  @override
  State<AdvertismentWidget> createState() => _AdvertismentWidgetState();
}

class _AdvertismentWidgetState extends State<AdvertismentWidget> {
  @override
  Widget build(BuildContext context) {
    final ad = ModalRoute.of(context)!.settings.arguments as Ad;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Ad', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'updated');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: ad.isFavorite
                ? Icon(Icons.favorite)
                : Icon(Icons.favorite_outline),
            onPressed: () {
              if (widget.isAuth) {
                if (ad.isFavorite) {
                  deleteFromFavoriteAds(ad.id);
                } else {
                  addToFavoriteAds(ad.id);
                }
                setState(() {
                  ad.isFavorite = !ad.isFavorite;
                });
              }
            },
          ),
        ],
      ),
      body: stackWidget(ad, context),
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
                                '  ≈ ${ad.price / 3.3}\$',
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
                    itemCount: ad.images.isNotEmpty ? ad.images.length : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (ad.images.isNotEmpty) {
                        return Image.network(
                          'http://10.0.2.2:8000/${ad.images[index]}',
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.network(
                          'https://www.linearity.io/blog/content/images/size/w1576/format/avif/2023/06/how-to-create-a-car-NewBlogCover.png',
                          fit: BoxFit.cover,
                        );
                      }
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

class AuctionWidget extends StatefulWidget {
  final bool isAuth;
  AuctionWidget({required this.isAuth});

  @override
  State<AuctionWidget> createState() => _AuctionWidgetState();
}

class _AuctionWidgetState extends State<AuctionWidget> {
  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as Auction;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Auction', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'updated');
          },
        ),
      ),
      body: stackWidget(car, context),
    );
  }

  Stack stackWidget(Auction auction, BuildContext context) {
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
                            '${auction.car.brand.name} ${auction.car.model.name}',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Начальная ставка: ${auction.price} р.',
                            style: TextStyle(fontSize: 22),
                          ),
                          if (auction.bid != null)
                            Text(
                              'Текущая ставка: ${auction.bid!.amount} р.',
                              style: TextStyle(fontSize: 22),
                            )
                          else
                            Text(
                              'Текущая ставка: -',
                              style: TextStyle(fontSize: 22),
                            ),
                          Text(
                            'Начало аукциона: ${DateFormat('dd.MM HH:mm').format(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(auction.startDate))}',
                            style: TextStyle(fontSize: 22),
                          ),
                          Text(
                            'Конец аукциона: ${DateFormat('dd.MM HH:mm').format(DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(auction.endDate))}',
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
                    itemCount:
                        auction.images.isNotEmpty ? auction.images.length : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (auction.images.isNotEmpty) {
                        return Image.network(
                          'http://10.0.2.2:8000/${auction.images[index]}',
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Image.network(
                          'https://www.linearity.io/blog/content/images/size/w1576/format/avif/2023/06/how-to-create-a-car-NewBlogCover.png',
                          fit: BoxFit.cover,
                        );
                      }
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
                  '${auction.car.year} г., ${auction.car.gearbox.type.toLowerCase()}, ${auction.car.engine.capacity.toString().toLowerCase()} л., ${auction.car.engine.type.toLowerCase()}, ${auction.car.mileage} км, ${auction.car.bodyType}, ${auction.car.color}',
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
                  auction.description,
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
              if (widget.isAuth) {
                showInputDialog(context, auction);
              } else {
                print('not logged in');
              }
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

  Future<void> showInputDialog(BuildContext context, Auction auction) async {
    TextEditingController textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Введите вашу ставку'),
          content: TextField(
            controller: textFieldController,
            decoration: InputDecoration(hintText: 'Ставка'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Подтвердить'),
              onPressed: () async {
                String enteredText = textFieldController.text;
                int? parsedNumber = int.tryParse(enteredText);
                if (parsedNumber != null) {
                  print('Parsed number: $parsedNumber');
                  if ((auction.bid != null &&
                          parsedNumber > auction.bid!.amount) ||
                      auction.bid == null) {
                    Future<bool> check = placeBid(parsedNumber, auction.id);
                    if (await check) {
                      setState(() {
                        auction.bid = Bid(
                            -1,
                            parsedNumber,
                            DateTime.now().add(Duration(hours: 3)).toString(),
                            -1);
                        Navigator.of(context).pop();
                      });
                    }
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class CreateAdvertisementPage extends StatefulWidget {
  @override
  State<CreateAdvertisementPage> createState() =>
      _CreateAdvertisementPageState();
}

class _CreateAdvertisementPageState extends State<CreateAdvertisementPage> {
  TextEditingController horsePowerController = TextEditingController();
  TextEditingController capacityController = TextEditingController();
  TextEditingController torqueController = TextEditingController();
  TextEditingController fuelConsumptionController = TextEditingController();
  TextEditingController gearNumberController = TextEditingController();
  TextEditingController clearanceController = TextEditingController();
  TextEditingController mileageController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  late Future<List<Brand>?> brands;
  late Future<List<Model>?> models;
  Brand? selectedBrand;
  Model? selectedModel;
  String selectedColor = 'Белый';
  String selectedBodyType = 'Хэтчбэк';
  String selectedFuelType = 'Бензин';
  String selectedSuspensionType = 'Рессорная подвеска';
  String selectedGearboxType = 'Автоматическая';


  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    brands = getAllBrands();
    models = getAllModels();
    await Future.wait([brands, models]);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Advertisement'),
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: Future.wait([brands, models]),
        builder:
            (BuildContext context, AsyncSnapshot<List<dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            List<Brand>? brandList = snapshot.data![0];
            List<Model>? modelList = snapshot.data![1];

            return Center(
              child: Column(
                children: [
                  DropdownButton<Brand>(
                    value: selectedBrand,
                    items: brandList!.map((Brand brand) {
                      return DropdownMenuItem<Brand>(
                        value: brand,
                        child: Text(brand.name),
                      );
                    }).toList(),
                    onChanged: (Brand? brand) {
                      setState(() {
                        selectedBrand = brand;
                      });
                    },
                    hint: Text('Select a Brand'),
                  ),
                  DropdownButton<Model>(
                    value: selectedModel,
                    items: modelList!
                        .where((model) =>
                            selectedBrand != null &&
                            model.brand.name ==
                                selectedBrand!
                                    .name) // Filter models based on brand name if selectedBrand is not null
                        .map((Model model) {
                      return DropdownMenuItem<Model>(
                        value: model,
                        child: Text(model
                            .name), // Assuming 'name' is the field in Model
                      );
                    }).toList(),
                    onChanged: (Model? model) {
                      setState(() {
                        selectedModel = model;
                      });
                    },
                    hint: Text('Select a Model'),
                  ),
                  // DropdownButton<String>(
                  //   value: selectedColor,
                  //   items: <String>[
                  //     'White',
                  //     'Black',
                  //     'Blue',
                  //     'Yellow',
                  //   ].map((String color) {
                  //     return DropdownMenuItem<String>(
                  //       value: color,
                  //       child: Text(color),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? color) {
                  //     setState(() {
                  //       selectedColor = color!;
                  //     });
                  //   },
                  //   hint: Text('Select a color'),
                  // ),
                  // DropdownButton<String>(
                  //   value: selectedBodyType,
                  //   items: <String>[
                  //     'Hatchback>',
                  //     'Sedan',
                  //     'Coupe',
                  //     'Universal',
                  //   ].map((String bodyType) {
                  //     return DropdownMenuItem<String>(
                  //       value: bodyType,
                  //       child: Text(bodyType),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? bodyType) {
                  //     setState(() {
                  //       selectedBodyType = bodyType!;
                  //     });
                  //   },
                  //   hint: Text('Select a body type'),
                  // ),
                  // DropdownButton<String>(
                  //   value: selectedFuelType,
                  //   items: <String>[
                  //     'Petrol',
                  //     'Diesel',
                  //     'Hybrid',
                  //     'Electic',
                  //   ].map((String fuelType) {
                  //     return DropdownMenuItem<String>(
                  //       value: fuelType,
                  //       child: Text(fuelType),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? fuelType) {
                  //     setState(() {
                  //       selectedFuelType = fuelType!;
                  //     });
                  //   },
                  //   hint: Text('Select a engine type'),
                  // ),
                  // DropdownButton<String>(
                  //   value: selectedSuspensionType,
                  //   items: <String>[
                  //     'Ressornaya',
                  //     'Torsionnaya',
                  //     'Independent',
                  //     'Pnevmaticheskaya',
                  //   ].map((String bodyType) {
                  //     return DropdownMenuItem<String>(
                  //       value: bodyType,
                  //       child: Text(bodyType),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? bodyType) {
                  //     setState(() {
                  //       selectedSuspensionType = bodyType!;
                  //     });
                  //   },
                  //   hint: Text('Select a color'),
                  // ),
                  TextField(
                    controller: horsePowerController,
                    decoration: InputDecoration(hintText: 'Лошадиные силы'),
                  ),
                  TextField(
                    controller: capacityController,
                    decoration: InputDecoration(hintText: 'Объем двигателя'),
                  ),
                  TextField(
                    controller: torqueController,
                    decoration: InputDecoration(hintText: 'Крутящий момент'),
                  ),
                  TextField(
                    controller: fuelConsumptionController,
                    decoration: InputDecoration(hintText: 'Расход топлива'),
                  ),
                  TextField(
                    controller: gearNumberController,
                    decoration: InputDecoration(hintText: 'Количество передач'),
                  ),
                  TextField(
                    controller: clearanceController,
                    decoration: InputDecoration(hintText: 'Клиренс'),
                  ),
                  TextField(
                    controller: mileageController,
                    decoration: InputDecoration(hintText: 'Пробег'),
                  ),
                  TextField(
                    controller: yearController,
                    decoration: InputDecoration(hintText: 'Год выпуска'),
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(hintText: 'Цена'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      createAd(
                          'Audi',
                          'Q5',
                          'бензин',
                          500,
                          5.0,
                          600,
                          7.0,
                          'автомат',
                          4,
                          'пневма',
                          15.0,
                          50000,
                          'Хэтчбэк',
                          2020,
                          'Серобуромалиновый',
                          '12345678901234567',
                          500000,
                          'afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd ');
                      Navigator.pop(context, 'updated');
                    },
                    child: Text('Создать'),
                  ),
                ],
              ),
            );
          }
        },
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
            createAuction(
                'Audi',
                'A4',
                'бензин',
                500,
                5.0,
                600,
                7.0,
                'автомат',
                4,
                'пневма',
                15.0,
                50000,
                'Хэтчбэк',
                2020,
                'Серобуромалиновый',
                '12345678901234567',
                500000,
                'afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd afjsdfjas kfhsfkjashdfkj asAA DAd asd ',
                DateFormat('yyyy-MM-ddTHH:mm')
                    .format(DateTime.now().add(Duration(hours: 3))),
                DateFormat('yyyy-MM-ddTHH:mm')
                    .format(DateTime.now().add(Duration(days: 3, hours: 3))));
            Navigator.pop(context, 'updated');
          },
          child: Text('Создать'),
        ),
      ),
    );
  }
}
