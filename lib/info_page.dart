import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);
  static String id = 'info_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {

                Navigator.pop(context);
              }),
        ],
        title: Text('About'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          height: 140,
          child: AutoSizeText(
            'This string will be automatically resized to fit in two lines.',
            style: TextStyle(fontSize: 30),
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
