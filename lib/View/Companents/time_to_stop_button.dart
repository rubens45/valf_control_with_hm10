import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:valf_control_with_hm10/View/time_starter_test_page.dart';
import 'package:valf_control_with_hm10/main.dart';

class TimeToStopButton extends StatefulWidget {
  String buttonName;

  List<int> autoMode;

  List<int> beginOfCommand;

  BuildContext context;

  List<int> commandGetStartStopTimeFromDevice;
  String result1 = '_sendTime';
  String result2 = 'Gönderilmedi';
  //TimeOfDay time;

  TimeToStopButton({
    Key? key,
    // required TimeOfDay this.time,
    required this.context,
    required this.beginOfCommand,
    required this.autoMode,
    required this.buttonName,
    required this.commandGetStartStopTimeFromDevice,
  }) : /*_time = time,*/ super(key: key);

  @override
  State<TimeToStopButton> createState() => _TimeToStopButtonState();
}

class _TimeToStopButtonState extends State<TimeToStopButton> {
  //late TimeOfDay _time;
//_time değişkeni TimeToStartStopPage.stopTime ile değiştirildi.
  //TimeOfDay _time = const TimeOfDay(hour: 7, minute: 25);

  @override
  void initState() {
    //_getTimeFromDevice();
    super.initState();
  }

  //incomingStartStopTimeMessageOfAux
  _getTimeFromDevice() {
    // _time = const TimeOfDay(hour: 8, minute: 15);
    //  await Future.delayed(const Duration(seconds: 1),(){
    //    setState((){
    //      _time = const TimeOfDay(hour: 8, minute: 45);
    //    });
    //  });
    MyHomePage.bleService.sendData(widget.commandGetStartStopTimeFromDevice);
    // Random random = Random();
    // MyHomePage.bleService.receivedData = [
    //   0xA1,
    //   0xC8,
    //   random.nextInt(24),
    //   random.nextInt(60)
    // ];
    //sleep(Duration(milliseconds: 20));
    TimeOfDay newTime = const TimeOfDay(hour: 8, minute: 00);
    try{
      if(MyHomePage.bleService.receivedData[0]==0xA1 && ( MyHomePage.bleService.receivedData[1]==0xC8)){
        newTime = newTime.replacing(
          hour: MyHomePage.bleService.receivedData[2].toInt(),
          minute: MyHomePage.bleService.receivedData[3].toInt(),
        );
      }

    }
    catch(e){
      print(e);
    }


    //Future.delayed(Duration(milliseconds: 200),(){});
    setState(
          () {
            try{
            if(MyHomePage.bleService.receivedData.isNotEmpty){
              if( MyHomePage.bleService.receivedData[0]==0xA1 && (MyHomePage.bleService.receivedData[1]==0xC8 )){

                //TimeToStartStopPage.startTime = newTime;

              }
            }

          }catch(e){
            print(e);
          }


      },
    );

    // await Future.delayed(const Duration(milliseconds: 1000), () {
    //   setState(
    //         () {
    //       _time = _time.replacing(hour: 9,minute: 45);
    //       //print('catched time: $_time');
    //     },
    //   );
    // });
  }

  Future<void> _sendTime(_time) async {
    setState((){
      widget.result1 = '_sendTime is running';

    });

    List<int> _timeToSend = widget.beginOfCommand;
    List<int> _autoMod = widget.autoMode;
    print(_time);
    print(_timeToSend);
    print(_time.hour);
    _timeToSend.add(_time.hour);
    _timeToSend.add(_time.minute);
    int _zeroSecond = 0x00;
    _timeToSend.add(_zeroSecond);
    print(_timeToSend.toHex);
    print(_timeToSend);
    try{
      MyHomePage.bleService.sendData(_timeToSend);
      Timer(Duration(milliseconds: 200), () {
        MyHomePage.bleService.sendData(_autoMod);
      });
      // await Future.delayed(const Duration(milliseconds: 200), () {
      //   MyHomePage.bleService.sendData(_autoMod);
      // });
      setState((){
        widget.result2= 'Gönderildi. time: ${_timeToSend.toHex} auto:${_autoMod.toHex}';
      });
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
      initialTime:TimeOfDay.now()// TimeToStartStopPage.stopTime,
    );
    if (newTime != null) {
      //print('Yeni zaman:$_time');
      _sendTime(newTime);
      setState((){
        widget.result1 = '_sendTime is calling';

      });
      print('sendtime is working');
      setState(() {
        //TimeToStartStopPage.stopTime = newTime;
      });
    } else {
      print('newTime is null');
    }
  }

  @override
  Widget build(BuildContext context) {
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
            minimumSize: const Size(150, 60), //////// HERE
          ),
          onPressed: () {
            _selectTime(context);
          },
          child: Text(widget.buttonName),
        ),
        const SizedBox(height: 8),
        // Text(
        //   TimeToStartStopPage.stopTime.format(context),
        //   style: const TextStyle(color: Colors.black87, fontSize: 20),
        // ),
        Text(MyHomePage.bleService.receivedData.toHex,
            style: const TextStyle(color: Colors.black87, fontSize: 20)),
        Text(widget.result1,
            style: const TextStyle(color: Colors.black87, fontSize: 20)),
        Text(widget.result2,
            style: const TextStyle(color: Colors.black87, fontSize: 20)),
      ],
    );
  }
}
