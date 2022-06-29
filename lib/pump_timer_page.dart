import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:valf_control_with_hm10/app_bar.dart';
import 'package:valf_control_with_hm10/main.dart';

class PumpTimer extends StatefulWidget {
  static String id = 'pump_timer_page';

  @override
  State<PumpTimer> createState() => _PumpTimerState();
}

class _PumpTimerState extends State<PumpTimer> {
  TimeOfDay _selectedTimeBegin1 = TimeOfDay.now();
  TimeOfDay _selectedTimeEnd1 = TimeOfDay.now();
  TimeOfDay _selectedTimeBegin2 = TimeOfDay.now();
  TimeOfDay _selectedTimeEnd2 = TimeOfDay.now();
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(this.mounted){
        setState(() { });
      }
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text('Timer 1',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(150, 60), //////// HERE
                        ),
                        onPressed: () {
                          _selectTimeBegin1(context);
                        },
                        child: Text("START"),
                      ),
                      Text(
                          "${_selectedTimeBegin1.hour}:${_selectedTimeBegin1.minute<10 ? '0':''}${_selectedTimeBegin1.minute}",
                      style: TextStyle(color: Colors.black87,fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(150, 60), //////// HERE
                        ),
                        onPressed: () {
                          _selectTimeEnd1(context);
                        },
                        child: Text("STOP"),
                      ),
                      Text(
                        "${_selectedTimeEnd1.hour}:${_selectedTimeEnd1.minute<10 ? '0':''}${_selectedTimeEnd1.minute}",
                        style: TextStyle(color: Colors.black87,fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Text('Timer 2',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(150, 60), //////// HERE
                        ),
                        onPressed: () {
                          _selectTimeBegin2(context);
                        },
                        child: Text("START"),
                      ),
                      Text(
                        "${_selectedTimeBegin2.hour}:${_selectedTimeBegin2.minute<10 ? '0':''}${_selectedTimeBegin2.minute}",
                        style: TextStyle(color: Colors.black87,fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                          shadowColor: Colors.greenAccent,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(150, 60), //////// HERE
                        ),
                        onPressed: () {
                          _selectTimeEnd2(context);
                        },
                        child: Text("STOP"),
                      ),
                      Text(
                        "${_selectedTimeEnd2.hour}:${_selectedTimeEnd2.minute<10 ? '0':''}${_selectedTimeEnd2.minute}",
                        style: TextStyle(color: Colors.black87,fontSize: 20),
                      ),
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shadowColor: Colors.greenAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    minimumSize: Size(150, 60), //////// HERE
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("SET"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _selectTimeEnd1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimeEnd1,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTimeEnd1) {
      setState(() {
        _selectedTimeEnd1 = timeOfDay;
      });
      List<int> _time = [0xA1, 0xB2]; //Pump1 timer off
      List<int> _autoMod = [0xA1, 0xB9, 0x02, 0x00, 0x00];
      print(_time);

      _time.add(_selectedTimeEnd1.hour);
      _time.add(_selectedTimeEnd1.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);
      Timer(Duration(milliseconds: 200), () {
        MyHomePage.bleService.sendData(_autoMod);
      });
    } else {

    }
  }
  _selectTimeEnd2(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimeEnd2,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTimeEnd2) {
      setState(() {
        _selectedTimeEnd2 = timeOfDay;
      });
      List<int> _time = [0xA1, 0xB4]; //Pump1 timer off
      List<int> _autoMod = [0xA1, 0xB9, 0x02, 0x00, 0x00];
      print(_time);

      _time.add(_selectedTimeEnd2.hour);
      _time.add(_selectedTimeEnd2.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);
      Timer(Duration(milliseconds: 200), () {
        MyHomePage.bleService.sendData(_autoMod);
      });
    } else {

    }
  }

  _selectTimeBegin1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimeBegin1,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTimeBegin1) {
      setState(() {
        _selectedTimeBegin1 = timeOfDay;
      });
      List<int> _time = [0xA1, 0xB1]; //Pump1 timer on
      List<int> _autoMod = [0xA1, 0xB9, 0x02, 0x00, 0x00];
      print(_time);

      _time.add(_selectedTimeBegin1.hour);
      _time.add(_selectedTimeBegin1.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);
      Timer(Duration(milliseconds: 200), () {
        MyHomePage.bleService.sendData(_autoMod);
      });
    } else {

    }
  }
  _selectTimeBegin2(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTimeBegin2,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTimeBegin2) {
      setState(() {
        _selectedTimeBegin2 = timeOfDay;
      });
      List<int> _time = [0xA1, 0xB3]; //Pump1 timer on
      List<int> _autoMod = [0xA1, 0xB9, 0x02, 0x00, 0x00];
      print(_time);

      _time.add(_selectedTimeBegin2.hour);
      _time.add(_selectedTimeBegin2.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);
      Timer(Duration(milliseconds: 200), () {
        MyHomePage.bleService.sendData(_autoMod);
      });
    } else {

    }
  }
}
