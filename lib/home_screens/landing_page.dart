import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final String currentUser;

  LandingPage({required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Text('Welcome! Auth currentUser:\n\n$currentUser', textAlign: TextAlign.center),
      ),
    );
  }
}
