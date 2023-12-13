import 'package:flutter/material.dart';
import 'models.dart';

Widget carCard(car) {
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
                  fontSize: 20,
                )),
            Text('10000 руб.', style: TextStyle(fontSize: 16)),
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
  const AdvertismentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)!.settings.arguments as CarModel;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        title: Text('Ad', style: TextStyle(color: Colors.white)),
      ),
      body: stackWidget(car, context),
    );
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
                          Row(
                            children: [
                              Text(
                                '50 000 р.',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '  ≈ 10 000\$',
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
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage('assets/merc.webp'),
                      fit: BoxFit.cover,
                    ),
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
              // Add functionality for the tap event here
              print('Container clicked');
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
}
