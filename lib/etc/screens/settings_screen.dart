// 설정 화면

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("설정")),
      body: ListView(
        children: [
          ListTile(
            title: Text("알림 설정"),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            title: Text("계정 관리"),
            onTap: () {},
          ),
          ListTile(
            title: Text("로그아웃"),
            onTap: () {
              print("로그아웃 버튼 클릭");
            },
          ),
        ],
      ),
    );
  }
}
