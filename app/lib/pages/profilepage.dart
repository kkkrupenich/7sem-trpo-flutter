import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isUserLoggedIn = true;

  void updateLoginStatus(bool isLoggedIn) {
    setState(() {
      isUserLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: isUserLoggedIn ? ProfileScreen(updateLoginStatus) : LoginScreen(updateLoginStatus),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'Profile',
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

class ProfileScreen extends StatelessWidget {
  final Function(bool) updateLoginStatus;

  ProfileScreen(this.updateLoginStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            updateLoginStatus(false); // Обновление статуса авторизации
          },
          child: Text('Выйти из профиля'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final Function(bool) updateLoginStatus;

  LoginScreen(this.updateLoginStatus);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  Widget? currentScreen;

  @override
  void initState() {
    super.initState();
    currentScreen = buildLoginScreen();
  }

  Widget buildLoginScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              widget.updateLoginStatus(true); // Некоторая логика входа пользователя
            },
            child: Text('Войти'),
          ),
          SizedBox(height: 20),
          OutlinedButton(
            onPressed: () {
              setState(() {
                currentScreen = RegistrationScreen(widget.updateLoginStatus);
              });
            },
            child: Text('Регистрация'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentScreen,
    );
  }
}


class RegistrationScreen extends StatelessWidget {
  final Function(bool) updateLoginStatus;

  RegistrationScreen(this.updateLoginStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                updateLoginStatus(true); // Здесь происходит регистрация (или любая другая логика)
                
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
