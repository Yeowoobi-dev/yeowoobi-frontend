// 임시 SNS 화면

import 'package:flutter/material.dart';

class SnsScreen extends StatelessWidget {
  const SnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SNS")),
      body: Center(
        child: Text(
          "SNS",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
