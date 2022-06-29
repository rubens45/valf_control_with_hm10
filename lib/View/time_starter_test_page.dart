import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:valf_control_with_hm10/app_bar.dart';
import 'package:valf_control_with_hm10/main.dart';

import '../ViewModel/timer_service.dart';
import 'Companents/time_to_start_stop_button.dart';
import 'Companents/time_to_stop_button.dart';

class TimeToStartStopPage extends StatefulWidget {
   TimeToStartStopPage({Key? key,required String buttonName }) : super(key: key);
  static String id = 'time_starter_test_page';

  @override
  State<TimeToStartStopPage> createState() => _TimeToStartStopPageState();
}

class _TimeToStartStopPageState extends State<TimeToStartStopPage> {
  var timerService = TimerService();
  TimeOfDay _startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay _stopTime = TimeOfDay(hour: 00, minute: 00);
  @override
  // void initState() {
  //   try{
  //     //_getStartTimeFromDevice();
  //     //_startTime = timerService.getStartTimeFromDevice();
  //     sleep(const Duration(milliseconds: 200));
  //     //_getStopTimeFromDevice();
  //     //_stopTime = timerService.getStopTimeFromDevice();
  //   }catch(e){
  //     print(e);
  //   }
  //
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     if(this.mounted){
  //       try{
  //         //_getStartTimeFromDevice();
  //         //_startTime = timerService.getStartTimeFromDevice();
  //         sleep(const Duration(milliseconds: 200));
  //         //_getStopTimeFromDevice();
  //         //_stopTime = timerService.getStopTimeFromDevice();
  //       }catch(e){
  //         print(e);
  //       }
  //       setState(() {
  //
  //       });
  //     }
  //   });
  //   super.initState();
  // }

  //incomingStartStopTimeMessageOfAux

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('PUMP',style:TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('Timer 1',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                          buttonName: 'START',
                          context: context,
                          beginOfCommand:beginOfCommandPump1TimerOn,
                          autoMode: autoMode,
                          commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOn,
                          startStopTime: _startTime,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                          buttonName: 'STOP',
                          context: context,
                          beginOfCommand: beginOfCommandPump1TimerOff,
                          autoMode: autoMode,
                          commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOff,
                          startStopTime: _stopTime,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/4,
                    )
                  ],
                )
              ],
            ),
            Row(
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('SET'))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Text('Timer 2',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                        buttonName: 'START',
                        context: context,
                        beginOfCommand:beginOfCommandPump2TimerOn,
                        autoMode: autoMode,
                        commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOn,
                        startStopTime: _startTime,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                        buttonName: 'STOP',
                        context: context,
                        beginOfCommand: beginOfCommandPump2TimerOff,
                        autoMode: autoMode,
                        commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOff,
                        startStopTime: _stopTime,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width/4,
                    )
                  ],
                )
              ],
            ),
            Row(
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('SET'))
              ],
            ),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.black87,)),
              ],
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: const [

                Text('LAMP',style:TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding:  const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                        buttonName: 'START',
                        context: context,
                        beginOfCommand:beginOfCommandLampTimerOn,
                        autoMode: autoMode,
                        commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOn,
                        startStopTime: _startTime,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                        buttonName: 'STOP',
                        context: context,
                        beginOfCommand: beginOfCommandLampTimerOff,
                        autoMode: autoMode,
                        commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOff,
                        startStopTime: _stopTime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('SET'))
              ],
            ),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.black87,)),
              ],
            ),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: const [

                Text('AUX',style:TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                        buttonName: 'START',
                        context: context,
                        beginOfCommand:beginOfCommandAuxTimerOn,
                        autoMode: autoMode,
                        commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOn,
                        startStopTime: _startTime,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0,0.0),
                      child: TimeToStartStopButton(
                        buttonName: 'STOP',
                        context: context,
                        beginOfCommand: beginOfCommandAuxTimerOff,
                        autoMode: autoMode,
                        commandGetStartStopTimeFromDevice: commandGetStartStopTimeFromDeviceAuxOff,
                        startStopTime: _stopTime,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
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
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('SET'))
              ],
            ),

          ],
        ),
      ),
    );
  }
}
List<int> beginOfCommandAuxTimerOn =  [0xA1, 0xB7];
List<int> beginOfCommandAuxTimerOff =  [0xA1, 0xB8];
List<int> beginOfCommandPump1TimerOn =  [0xA1, 0xB1];
List<int> beginOfCommandPump1TimerOff =  [0xA1, 0xB2];
List<int> beginOfCommandPump2TimerOn =  [0xA1, 0xB3];
List<int> beginOfCommandPump2TimerOff =  [0xA1, 0xB4];
List<int> beginOfCommandLampTimerOn =  [0xA1, 0xB5];
List<int> beginOfCommandLampTimerOff =  [0xA1, 0xB6];

const List<int> autoMode = [0xA1, 0xBA, 0x02, 0x00, 0x00];

const List<int> commandGetStartStopTimeFromDeviceAuxOn =  [0xA1,0xC5,0x01];
const List<int> commandGetStartStopTimeFromDeviceAuxOff =  [0xA1,0xC6,0x01];

