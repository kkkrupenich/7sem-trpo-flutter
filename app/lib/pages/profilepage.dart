import 'package:flutter/material.dart';
import '../api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  final bool isAuthenticated;
  final ValueChanged<bool> onChanged;
  ProfilePage({required this.isAuthenticated, required this.onChanged});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void updateLoginStatus(bool isLoggedIn) {
    setState(() {
      widget.onChanged(isLoggedIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: widget.isAuthenticated
          ? ProfileScreen(updateLoginStatus)
          : LoginScreen(updateLoginStatus),
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

Future<Map<String, String>> getUserDataFromSecureStorage() async {
  final storage = FlutterSecureStorage();
  Map<String, String> data = {
    'username': '',
    'email': '',
    'phone': '',
    'firstname': '',
  };

  for (String key in data.keys) {
    String? value = await storage.read(key: key);
    if (value != null) data[key] = value;
  }

  return data;
}

class ProfileScreen extends StatelessWidget {
  final Function(bool) updateLoginStatus;

  ProfileScreen(this.updateLoginStatus);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController firstnameController = TextEditingController();

    return FutureBuilder<Map<String, String>>(
        future: Future.delayed(
            Duration(seconds: 1), () => getUserDataFromSecureStorage()),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            ); // Отображаем индикатор загрузки пока данные загружаются
          } else if (snapshot.hasError) {
            return Text(
                'Error: ${snapshot.error}'); // Обработка ошибок, если они возникают
          } else {
            // Используйте полученные данные здесь
            Map<String, String>? data = snapshot.data;
            if (data != null) {
              emailController.text = data['email'] ?? '';
              phoneController.text = data['phone'] ?? '';
              firstnameController.text = data['firstname'] ?? '';
              return Scaffold(
                body: SingleChildScrollView(
                  child: Center(
                      child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        width: 300,
                        child: Column(children: [
                          Text('${data['username']}',
                              style: TextStyle(fontSize: 30)),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(hintText: 'Email'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: phoneController,
                            decoration: InputDecoration(hintText: 'Phone'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: firstnameController,
                            decoration: InputDecoration(hintText: 'First name'),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          update(emailController.text, phoneController.text,
                              firstnameController.text);
                        },
                        child: Text('Сохранить'),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          removeTokenFromSharedPreferences();
                          clearUserDataFromSecureStorage();
                          updateLoginStatus(
                              false); // Обновление статуса авторизации
                        },
                        child: Text('Выйти из профиля'),
                      ),
                    ],
                  )),
                ),
              );
            } else {
              return Text('No data available');
            }
          }
        });
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
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 300,
            child: Column(children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(hintText: 'Username'),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(hintText: 'Email'),
              ),
            ]),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () async {
              if (usernameController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                Future<bool> check = login(usernameController.text, passwordController.text);
                if (await check) {
                  widget.updateLoginStatus(true); 
                }
              }
            },
            child: Text('Войти'),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Нет аккаунта?'),
              TextButton(
                onPressed: () {
                  setState(() {
                    currentScreen =
                        RegistrationScreen(widget.updateLoginStatus);
                  });
                },
                child: Text('Зарегистрироваться'),
              ),
            ],
          )
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
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController firstnameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: Column(children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(hintText: 'Username'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(hintText: 'Phone'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: firstnameController,
                  decoration: InputDecoration(hintText: 'Firstname'),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                if (usernameController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    firstnameController.text.isNotEmpty) {
                  Future<bool> check = register(
                      usernameController.text,
                      emailController.text,
                      phoneController.text,
                      firstnameController.text,
                      passwordController.text);
                  if (await check) {
                    updateLoginStatus(true);
                  }
                }
              },
              child: Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }
}
