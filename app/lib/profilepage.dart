import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Text(
      'Profile'
      ),
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