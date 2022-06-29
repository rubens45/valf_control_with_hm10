import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:valf_control_with_hm10/main.dart';

class SetTimer extends StatefulWidget {
  static String id = 'set_timer';

  @override
  State<SetTimer> createState() => _SetTimerState();
}

class _SetTimerState extends State<SetTimer> {
  TimeOfDay selectedTimeBegin1 = TimeOfDay.now();
  TimeOfDay selectedTimeEnd1 = TimeOfDay.now();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pompa Zaman Ayarı"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectTimeBegin1(context);
                        },
                        child: Text("Başlangıç Zamanı"),
                      ),
                      Text("${selectedTimeBegin1.hour}:${selectedTimeBegin1.minute}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _selectTimeEnd1(context);
                        },
                        child: Text("Bitiş Zamanı"),
                      ),
                      Text("${selectedTimeEnd1.hour}:${selectedTimeEnd1.minute}"),
                    ],
                  ),

                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
  _selectTimeEnd1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeEnd1,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if(timeOfDay != null && timeOfDay != selectedTimeEnd1)
    {
      setState(() {
        selectedTimeEnd1 = timeOfDay;

      });
    }else
    {

      List<int> _time = [0xA1,0xB2];//Pump1 timer off
      List<int> _autoMod = [0xA1,0xB9,0x02,0x00,0x00];
      print(_time);

      _time.add(selectedTimeEnd1.hour);
      _time.add(selectedTimeEnd1.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);
      Timer(Duration(milliseconds: 200), (){MyHomePage.bleService.sendData(_autoMod);});
    }
  }
  _selectTimeBegin1(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTimeBegin1,
      initialEntryMode: TimePickerEntryMode.dial,

    );
    if(timeOfDay != null && timeOfDay != selectedTimeBegin1)
    {
      setState(() {
        selectedTimeBegin1 = timeOfDay;

      });
    }else
    {

      List<int> _time = [0xA1,0xB1];//Pump1 timer on
      print(_time);

      _time.add(selectedTimeBegin1.hour);
      _time.add(selectedTimeBegin1.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);
    }
  }
}
