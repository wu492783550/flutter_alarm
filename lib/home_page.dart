import 'package:flutter/material.dart';
import 'package:flutter_alarm/utils/notifi_service.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({ this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: ElevatedButton(
        child: const Text('Show notifications'),
        onPressed: () {
          print('showNotification');
          Future.delayed(Duration(seconds: 20), () {
            print('showNotification 1');
            NotificationService()
                .showNotification(title: '提醒打卡功能', body: '请去打卡吧');
          });
        },
      )),
    );
  }
}
