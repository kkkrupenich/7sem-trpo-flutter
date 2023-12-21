import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/homepage.dart';
import 'pages/adspage.dart';
import 'pages/auctionspage.dart';
import 'pages/favoritespage.dart';
import 'pages/profilepage.dart';
import 'api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cars',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    checkAuthentication();
  }

  Future<void> checkAuthentication() async {
    final token = await getTokenFromSharedPreferences();
    setState(() {
      isAuth = token != null;
    });
  }

  List<Widget> getScreens() {
    return [
      HomePage(isAuthenticated: isAuth),
      AdvertismentsPage(isAuthenticated: isAuth),
      FavoritesPage(isAuthenticated: isAuth),
      AuctionsPage(isAuthenticated: isAuth),
      ProfilePage(
        isAuthenticated: isAuth,
        onChanged: (newValue) {
          setState(() {
            isAuth = newValue;
          });
        },
      ),
    ];
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: getScreens()[currentIndex],
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  Container _bottomNavBar() {
    return Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home_filled, text: 'Home'),
              GButton(icon: Icons.car_rental, text: 'Ads'),
              GButton(icon: Icons.favorite_border, text: 'Favotires'),
              GButton(icon: Icons.car_repair, text: 'Auctions'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
            onTabChange: (index) {
              setState(() {
                if (!isAuth && index == 2) {
                  final snackBar = SnackBar(
                      content: Text('You are not logged in, returning'),
                      duration: Duration(seconds: 2));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  currentIndex = index;
                }
              });
            },
            selectedIndex: currentIndex,
          ),
        ));
  }
}
