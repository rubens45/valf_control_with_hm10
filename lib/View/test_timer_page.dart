import 'dart:async';
//import 'dart:js';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valf_control_with_hm10/app_bar.dart';
import 'package:valf_control_with_hm10/main.dart';

import '../ViewModel/timer_service.dart';

class TestTimer extends StatefulWidget {
  static String id = 'test_timer_page';

  @override
  State<TestTimer> createState() => _TestTimerState();
}

class _TestTimerState extends State<TestTimer> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static late TimerService time;
  String? timeOfTimer = TimeOfDay.now().toString();
  void _getTime(String itemName) async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await _prefs;
    setState(() {
      timeOfTimer = prefs.getString(itemName) ?? '';
    });
  }

  @override
  void initState() {
    setState(() {
      _getTime('selectedBeginTime_1');
    });

    print('Test Timer Page');

    Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    time = TimerService();
    String returnedTime = '00:00';
    // TimeOfDay _time = TimeOfDay.now();

    // getTime(){
    //   time.sendTime(context,'testTimerPageBegin');
    //   time.getTime('testTimerPageBegin');
    // }

    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Timer 1',
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print('Timer Service:');
                          setState(() async {
                            print('Timer Service time:');
                            print(time.getSelectedTime(time));
                            await time.sendTime(context);//.then((rt){returnedTime=rt;return rt;}).then((_){time.saveTimeToSharedPreferences('selectedBeginTime_1');});
                            print(time.toString());

                            await time.saveTimeToSharedPreferences('selectedBeginTime_1');
                            print(time.getSelectedTime(time));
                            returnedTime=time.getSelectedTime(time);

                            //timeOfTimer = time.getTimeFromSharedPreferences('selectedBeginTime_1') as String?;
                          });
                          print('press');
                        },
                        child: Text("START"),
                      ),
                      Text(

                        returnedTime,//time.getSelectedTime(time),//timeOfTimer! == null ? time.selectedTime.toString() : timeOfTimer!,
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          //_selectTimeEnd1(context);
                        },
                        child: Text("STOP"),
                      ),
                      // Text(
                      //   "${_selectedTimeEnd1.hour}:${_selectedTimeEnd1.minute<10 ? '0':''}${_selectedTimeEnd1.minute}",
                      //   style: TextStyle(color: Colors.black87),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('SET'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
