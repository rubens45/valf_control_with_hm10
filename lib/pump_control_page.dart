import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:valf_control_with_hm10/View/test_timer_page.dart';
import 'package:valf_control_with_hm10/View/time_starter_test_page.dart';
import 'package:valf_control_with_hm10/app_bar.dart';
import 'package:valf_control_with_hm10/aux_timer_page.dart';
import 'package:valf_control_with_hm10/main.dart';
import 'package:valf_control_with_hm10/pump_timer_page.dart';
import 'package:valf_control_with_hm10/reusable_card.dart';
import 'package:valf_control_with_hm10/rgb_timer_page.dart';
import 'info_page.dart';
import 'package:intl/intl.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'dart:async';
import 'package:valf_control_with_hm10/app_bar.dart';

class PumpControlPage extends StatefulWidget {
  //static PumpControlPage? _pumpControlPage;
  const PumpControlPage({Key? key}) : super(key: key);
  static String id = 'valf_control_page';

  // _PumpControlPage(){
  // PumpControlPage? getInstance(){
  //   return _pumpControlPage;
  // }
  // }

  @override
  State<PumpControlPage> createState() => _PumpControlPageState();
}

class _PumpControlPageState extends State<PumpControlPage> {
  List<int> commandOnPump = [0xA1, 0xB9, 0x01, 0x00, 0x00];
  List<int> commandOffPump = [0xA1, 0xB9, 0x00, 0x00, 0x00];
  List<int> commandOnRgb = [0xA1, 0xBA, 0x01, 0x00, 0x00];
  List<int> commandOffRgb = [0xA1, 0xBA, 0x00, 0x00, 0x00];
  List<int> commandOnAux = [0xA1, 0xBB, 0x01, 0x00, 0x00];
  List<int> commandOffAux = [0xA1, 0xBB, 0x00, 0x00, 0x00];
  List<int> commandOnDevice = [0xA1, 0xBC, 0x01, 0x00, 0x00];
  List<int> commandOffDevice = [0xA1, 0xBC, 0x00, 0x00, 0x00];
  List<int> incomingOnMessageOfPump = [0xA1, 0xC9, 0x01, 0x00, 0x00];
  List<int> incomingOnMessageOfRgb = [0xA1, 0xCA, 0x01, 0x00, 0x00];
  List<int> incomingOnMessageOfAux = [0xA1, 0xCB, 0x01, 0x00, 0x00];
  List<int> incomingOnMessageOfDevice = [0xA1, 0xCC, 0x01, 0x00, 0x00];
  List<int> incomingOffMessageOfPump = [0xA1, 0xC9, 0x00, 0x00, 0x00];
  List<int> incomingOffMessageOfRgb = [0xA1, 0xCA, 0x00, 0x00, 0x00];
  List<int> incomingOffMessageOfAux = [0xA1, 0xCB, 0x00, 0x00, 0x00];
  List<int> incomingOffMessageOfDevice = [0xA1, 0xCC, 0x00, 0x00, 0x00];
  List<int> checkStatusCommandPump = [0xA1, 0xC9, 0x00, 0x00, 0x00];
  List<int> checkStatusCommandRgb = [0xA1, 0xCA, 0x00, 0x00, 0x00];
  List<int> checkStatusCommandAux = [0xA1, 0xCB, 0x00, 0x00, 0x00];
  List<int> checkStatusCommandDevice = [0xA1, 0xCC, 0x01, 0x00, 0x00];
  List<int> checkAutoModOfPump = [0xA1, 0xC9, 0x09, 0x00, 0x00];
  List<int> incomingMessageOfPumpAutoModeOn = [0xA1, 0xC9, 0x02, 0x00, 0x00];
  List<int> checkAutoModOfRgb = [0xA1, 0xCA, 0x09, 0x00, 0x00];
  List<int> incomingMessageOfRgbAutoModeOn = [0xA1, 0xCA, 0x02, 0x00, 0x00];
  List<int> checkAutoModOfAux = [0xA1, 0xCB, 0x09, 0x00, 0x00];
  List<int> incomingMessageOfAuxAutoModeOn = [0xA1, 0xCB, 0x02, 0x00, 0x00];



  //String _time = '';
  //bool _statusOfBle = MyHomePage.bleService.connected;
  //
  Color pumpColor = Colors.grey;//Color(0xFF0BFF01);
  Color auxColor = Colors.grey;//Color(0xFF0BFF01);
  Color rgbColor = Colors.grey;//Color(0xFF0BFF01);
  Color switchColor = Color(0xFF1262C5);
  Color timerButtonOfPump = Colors.grey;
  Color timerButtonOfRgb = Colors.grey;
  Color timerButtonOfAux = Colors.grey;
  Color deviceStateColor = Colors.grey;
  bool statusOfDevice = false;
  bool statusOfRgb = false;
//@override

  //
checkStateOfDevices() async {
  if(MyHomePage.bleService.connected){
    //Sending check message
    await Future.delayed(Duration(milliseconds: 100),(){MyHomePage.bleService.sendData(checkAutoModOfPump);
      print('checkAutoModOfPump komutu gönderildi');
    print(DateTime.now());
    print(MyHomePage.bleService.receivedData.toHex);
    });
    //waiting incoming message
    await Future.delayed(Duration(milliseconds: 100),() {
      setState(() {
        if (incomingOffMessageOfPump.toHex ==
            MyHomePage.bleService.receivedData.toHex) {
          pumpColor = Colors.red;
          timerButtonOfPump = Colors.white; //if Pump is off then auto mode is also off
        }
        else if (incomingOnMessageOfPump.toHex ==
            MyHomePage.bleService.receivedData.toHex) {
          pumpColor = Colors.green;
          timerButtonOfPump = Colors.white; //if pump is only on then auto mode is off
        }
        if (incomingMessageOfPumpAutoModeOn.toHex ==
            MyHomePage.bleService.receivedData.toHex) {
          pumpColor = Colors.green; //if automatic mode is on, the pump is also on
          timerButtonOfPump = Colors.blue;
        }
      });

    });
    await Future.delayed(Duration(milliseconds: 100),(){
      MyHomePage.bleService.sendData(checkAutoModOfRgb);
      print('checkAutoModOfRgb komutu gönderildi');
      print(DateTime.now());
      print(MyHomePage.bleService.receivedData.toHex);
    });
    await Future.delayed(Duration(milliseconds: 100), () {
      if (incomingOffMessageOfRgb.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        rgbColor = Colors.red;
        timerButtonOfRgb = Colors.white; //if rgb is off then outo mode is already off
        //statusOfRgb = false;
      }
      if (incomingOnMessageOfRgb.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        rgbColor = Colors.green;
        timerButtonOfRgb =  Colors.white; //rgb is on but auto mode is off
        //statusOfRgb = true;
      }
      if (incomingMessageOfRgbAutoModeOn.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        rgbColor = Colors.green; //if auto mode is on, rgb should be on
        timerButtonOfRgb = Colors.blue;
      }

    });
    await Future.delayed(Duration(milliseconds: 100),(){
      MyHomePage.bleService.sendData(checkAutoModOfAux);
      print('checkAutoModOfAux komutu gönderildi');
      print(DateTime.now());
      print(MyHomePage.bleService.receivedData.toHex);    });
    await Future.delayed(Duration(milliseconds: 100), () {
      if (incomingOffMessageOfAux.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        auxColor = Colors.red;
        timerButtonOfAux = Colors.white; //if aux is off then auto mode is also off
      }
      if (incomingOnMessageOfAux.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        auxColor = Colors.green;
        timerButtonOfAux = Colors.white; //if aux is only on then auto mode is off
      }
      if (incomingMessageOfAuxAutoModeOn.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        auxColor = Colors.green; //if auto mode is on the aux is also on
        timerButtonOfAux = Colors.blue;
      }
    });

    await Future.delayed(Duration(milliseconds: 100),(){
      MyHomePage.bleService.sendData(checkStatusCommandDevice);
      print(DateTime.now());
    });
    await Future.delayed(Duration(milliseconds: 100), () {
      if (incomingOffMessageOfDevice.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        deviceStateColor = Colors.red;
        statusOfDevice=false;
      }
      if (incomingOnMessageOfDevice.toHex ==
          MyHomePage.bleService.receivedData.toHex) {
        deviceStateColor = Colors.green;
        statusOfDevice=true;


      }
    });
  }else{
    print('Bağlantı kurulamadığından veriler alınamadı, tekrar deneniyor');
    await Future.delayed(Duration(seconds: 1),checkStateOfDevices);
    print(DateTime.now());
  }
}
  @override
  void initState() {

    super.initState();
    MyHomePage.bleService.onConnectDevice(0, () {
      setState(() {});
    });

    checkStateOfDevices();

    Timer.periodic(Duration(seconds: 1), (timer) {
      if(this.mounted){
        checkStateOfDevices();

          // Future.delayed(Duration(milliseconds: 500),(){MyHomePage.bleService.sendData(checkAutoModOfPump);
          // print('checkAutoModOfPump komutu gönderildi');
          // print(DateTime.now());
          // print(MyHomePage.bleService.receivedData);
          // });
        setState(() {
          if (incomingOffMessageOfPump.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            pumpColor = Colors.red;
            timerButtonOfPump = Colors.white; //if Pump is off then auto mode is also off
          }
          if (incomingOnMessageOfPump.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            pumpColor = Colors.green;
            timerButtonOfPump = Colors.white; //if pump is only on then auto mode is off
          }
          if (incomingMessageOfPumpAutoModeOn.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            pumpColor = Colors.green; //if automatic mode is on, the pump is also on
            timerButtonOfPump = Colors.blue;
          }
          if (incomingOffMessageOfAux.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            auxColor = Colors.red;
            timerButtonOfAux = Colors.white; //if aux is off then auto mode is also off
          }
          if (incomingOnMessageOfAux.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            auxColor = Colors.green;
            timerButtonOfAux = Colors.white; //if aux is only on then auto mode is off
          }
          if (incomingMessageOfAuxAutoModeOn.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            auxColor = Colors.green; //if auto mode is on the aux is also on
            timerButtonOfAux = Colors.blue;
          }
          if (incomingOffMessageOfRgb.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            rgbColor = Colors.red;
            timerButtonOfRgb = Colors.white; //if rgb is off then outo mode is already off
            statusOfRgb = false;
          }
          if (incomingOnMessageOfRgb.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            rgbColor = Colors.green;
            timerButtonOfRgb = Colors.white; //rgb is on but auto mode is off
            statusOfRgb = true;
          }
          if (incomingMessageOfRgbAutoModeOn.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            rgbColor = Colors.green; //if auto mode is on, rgb should be on
            timerButtonOfRgb = Colors.blue;
          }
          if (incomingOffMessageOfDevice.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            deviceStateColor = Colors.red;
            statusOfDevice=false;
          }
          if (incomingOnMessageOfDevice.toHex ==
              MyHomePage.bleService.receivedData.toHex) {
            deviceStateColor = Colors.green;
            statusOfDevice=true;
          }

          if(MyHomePage.bleService.connected){

          }
          //_time = DateFormat("HH:mm:ss").format(DateTime.now());
          //_statusOfBle = !MyHomePage.bleService.connected;
          //pumpColor=Colors.red;
          //print('test2');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context
          //     (
          //         leading: null,
          //     actions: <Widget>[
          //     Center(
          //         child: OutlinedButton(
          //
          //         onPressed: () {
          //
          //   },
          //     child:  Text(_time,
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
          // IconButton(
          // onPressed: () {
          // Navigator.pushNamed(context, InfoPage.id);
          // },
          // icon: const Icon(Icons.info_outline),
          // ),
          // IconButton(
          // onPressed: () {},
          // icon: const Icon(Icons.bluetooth_connected_outlined),
          // ),
          // IconButton(
          // icon: Icon(Icons.close),
          // onPressed: () {
          // Navigator.pop(context);
          // }),
          // ],
          // title: Text('Pompa Kontrol'),
          // backgroundColor: Colors.blue,
          // ),
          ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ReusableCard(
                timerPage: PumpTimer.id,
                timerButtonBackgroundColor: timerButtonOfPump,
                isOnMessage: commandOnPump,
                isOffMessage: commandOffPump,
                checkStatusCommand: checkStatusCommandPump,
                pathOfImage: 'images/water-pump-4-64.png',
                pumpColor: pumpColor,
                switchColor: switchColor,
                name: "PUMP",
                commandOn: commandOnPump,
                commandOff: commandOffPump,
              ),
              ReusableCard(
                timerPage: RgbTimer.id,//RgbTimer.id,
                timerButtonBackgroundColor: timerButtonOfRgb,
                isOnMessage: [0xA1, 0xCA, 0x01, 0x00, 0x00],
                isOffMessage: [0xA1, 0xCA, 0x00, 0x00, 0x00],
                checkStatusCommand: checkStatusCommandRgb,
                pathOfImage: 'images/Clicker56.png',
                pumpColor: rgbColor,
                switchColor: switchColor,
                name: "LAMP",
                commandOn: commandOnRgb,
                commandOff: commandOffRgb,
              ),
              ReusableCard(
                timerPage: TimeToStartStopPage.id,
                timerButtonBackgroundColor: timerButtonOfAux,
                isOnMessage: [0xA1, 0xCA, 0x01, 0x00, 0x00],
                isOffMessage: [0xA1, 0xCA, 0x00, 0x00, 0x00],
                checkStatusCommand: checkStatusCommandAux,
                pathOfImage: 'images/aux1.png',
                pumpColor: auxColor,
                switchColor: switchColor,
                name: "AUX",
                commandOn: commandOnAux,
                commandOff: commandOffAux,
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  //color: Color(0xff282E3A),
                    borderRadius: BorderRadius.circular(0.0),
                    border: Border.all(width: 2.0, color: Colors.black87)),
                width: MediaQuery.of(context).size.width-25,
                height:50,// MediaQuery.of(context).size.width/4,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Padding(
                      padding:  EdgeInsets.only(left: (MediaQuery.of(context).size.width/8.0)),
                      child: const Text('TIMER SET',style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),),
                    ),
                    IconButton(
                      alignment: Alignment.center,
                        onPressed: (){
                          Navigator.pushNamed(context,TimeToStartStopPage.id);
                    },
                        icon: Padding(
                          padding:  EdgeInsets.only(right: (MediaQuery.of(context).size.width/3.0)),
                          child: Icon(Icons.access_alarm_outlined),
                        )),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    //color: Color(0xff282E3A),
                    borderRadius: BorderRadius.circular(0.0),
                    border: Border.all(width: 2.0, color: Colors.black87)),
                child: Row(
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if(statusOfDevice){
                              Timer(const Duration(milliseconds: 100), () {
                                MyHomePage.bleService.sendData(commandOffDevice);
                                Timer(const Duration(milliseconds: 300), () {
                                  MyHomePage.bleService
                                      .sendData(checkStatusCommandDevice);
                                });
                                //statusOfDevice=false;
                              });
                            }else{
                              Timer(Duration(milliseconds: 100), () {
                                MyHomePage.bleService.sendData(commandOnDevice);
                                Timer(Duration(milliseconds: 300), () {
                                  MyHomePage.bleService
                                      .sendData(checkStatusCommandDevice);
                                });
                                //statusOfDevice=true;
                              });
                            }

                          },
                          icon: Icon(Icons.power_settings_new_outlined,
                            color:statusOfDevice == true ? Colors.green : Colors.red,),
                        ),

                      ],
                    ),
                    Column(
                      children: [
                        Text('Device Status:',style: TextStyle(color: Colors.black87),)
                      ],
                    ),
                    Column(
                      children: [
                        TextButton(
                            onPressed: (){},
                            child:statusOfDevice==true ? Text('Online'):Text('Offline')),
                      ],
                    )

                  ],
                ),

              ),

              Image.asset('images/smartpool.png'),

            ],
          ),
        ),
      ),
    );
  }
}
