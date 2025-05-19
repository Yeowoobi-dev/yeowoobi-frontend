// 임시 독서록 화면

import 'package:flutter/material.dart';

class BookLogScreen extends StatelessWidget {
  const BookLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("내 독서록")),
      body: Center(
        child: Text(
          "독서록",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
