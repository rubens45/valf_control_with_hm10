import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:valf_control_with_hm10/View/time_starter_test_page.dart';
import 'package:valf_control_with_hm10/ViewModel/timer_service.dart';
import 'package:valf_control_with_hm10/main.dart';

class TimeToStartStopButton extends StatefulWidget {

  String buttonName;
  List<int> autoMode;
  List<int> beginOfCommand;
  BuildContext context;
  List<int> commandGetStartStopTimeFromDevice;
  TimeOfDay startStopTime;
  String result1 = '_sendTime';
  //String result2 = 'Gönderilmedi';
  String result3 = 'timeToSend';


  TimeToStartStopButton({
    Key? key,
    required this.startStopTime,
    required this.context,
    required this.beginOfCommand,
    required this.autoMode,
    required this.buttonName,
    required this.commandGetStartStopTimeFromDevice,
  }) :super(key: key);

  @override
  State<TimeToStartStopButton> createState() => _TimeToStartStopButtonState();
}

class _TimeToStartStopButtonState extends State<TimeToStartStopButton> {

  Future<void> _sendTime(_time) async {
    setState((){


    });
    List<int> _timeToSend = widget.beginOfCommand;
    List<int> _autoMod = widget.autoMode;
    _timeToSend.add(_time.hour);
    _timeToSend.add(_time.minute);
    int _zeroSecond = 0x00;
    _timeToSend.add(_zeroSecond);

try{
  MyHomePage.bleService.sendData(_timeToSend);
  // Timer(const Duration(milliseconds: 200), () {
  //   MyHomePage.bleService.sendData(_autoMod);
  // });
  // await Future.delayed(const Duration(milliseconds: 200), () {
  //   MyHomePage.bleService.sendData(_autoMod);
  // });
  // setState((){
  //   widget.result2= 'Gönderildi. time: ${_timeToSend.toHex} auto:${_autoMod.toHex}';
  // });
}catch(e){
  print(e);
  setState((){
    widget.result1 = e.toString();

  });
}

  }

  void _selectTime(BuildContext context) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: widget.startStopTime,
    );
    if (newTime != null) {
      _sendTime(newTime);
      print(widget.startStopTime);
      setState(() {
        try{
          widget.startStopTime = newTime;
        }catch(e){
          print(e);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String timeToSend;
    return Column(
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
            minimumSize:  Size(MediaQuery.of(context).size.width/5, MediaQuery.of(context).size.width/12), //////// HERE
          ),
          onPressed: () {
            _selectTime(widget.context);
          },
          child: Text(widget.buttonName),
        ),
        const SizedBox(height:0),
        Text(
          widget.startStopTime.format(context),
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),
        // Text(MyHomePage.bleService.receivedData.toHex,
        //   style: const TextStyle(color: Colors.black87, fontSize: 20)),
        // Text(widget.result1,
        //     style: const TextStyle(color: Colors.black87, fontSize: 20)),

      ],
    );
  }
}
