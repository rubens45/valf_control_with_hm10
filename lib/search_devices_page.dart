import 'dart:async';
import 'package:valf_control_with_hm10/pump_control_page.dart';

import 'app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:valf_control_with_hm10/app_bar.dart';
import 'package:valf_control_with_hm10/main.dart';

import 'info_page.dart';

class SearchDevices extends StatefulWidget {
  const SearchDevices({Key? key}) : super(key: key);

  @override
  State<SearchDevices> createState() => _SearchDevicesState();
}

class _SearchDevicesState extends State<SearchDevices> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if(this.mounted){
        refreshScreen();

      }
   });
    super.initState();
  }
  void refreshScreen() {
    setState(() {});
  }

  // void _sendData() async {
  //   await flutterReactiveBle.writeCharacteristicWithResponse(_rxCharacteristic,
  //       value: command);//_dataToSendText.text.codeUnits);
  // }

  void _onNewReceivedData(List<int> data) {
    // MyHomePage.bleService.numberOfMessagesReceived += 1;
    // MyHomePage.bleService.receivedData
    //     .add("$MyHomePage.bleService.numberOfMessagesReceived: ${String.fromCharCodes(data)}");
    // if (MyHomePage.bleService.receivedData.length > 5) {
    //   MyHomePage.bleService.receivedData.removeAt(0);
    // }
    MyHomePage.bleService.onNewReceivedData(data);
    refreshScreen();
  }
  void _sendTime(){
    List<int> _time = [0xA1,0xB0];
    print(_time);

    _time.add(DateTime.now().hour);
    _time.add(DateTime.now().minute);
    _time.add(DateTime.now().second);

    print(_time.toHex);

    //if top is not working -> converting time to hex
    final List<int> nums = [
      13,
      45,
      09
    ];

    List _convertedNum = nums.map((num) =>  num.toRadixString(16)).toList();
    print(_convertedNum);

    //
    MyHomePage.bleService.sendData(_time);

    setState(() {

    });
  }
  void _disconnect() {
    // await bleService.connection.cancel();
    // bleService.connected = false;
    MyHomePage.bleService.disconnect();
    refreshScreen();
  }
  void _onClickedSearchDeviceButton(){
    refreshScreen();
    if(!MyHomePage.bleService.scanning &&//if device is not scanning and connected then search device
        !MyHomePage.bleService.connected){

      print('if device is not scanning and connected then search device');
      print('Scanning:${MyHomePage.bleService.scanning}');
      print('Connection:${MyHomePage.bleService.connected}');
      _startScan();
      print('Scanning:${MyHomePage.bleService.scanning}');
      print('Connection:${MyHomePage.bleService.connected}');

    }
    else if(!MyHomePage.bleService.scanning &&//if device is not scanning but it is connected then search device
        MyHomePage.bleService.connected){
      print('if device is not scanning but it is connected then search device');
      print('Scanning:${MyHomePage.bleService.scanning}');
      print('Connection:${MyHomePage.bleService.connected}');

      _disconnect();
      _startScan();

      //_onClickedSearchDeviceButton();
    }
    else if(MyHomePage.bleService.scanning &&//if device is not scanning but it is connected then search device
        !MyHomePage.bleService.connected){
      print('Scanning:${MyHomePage.bleService.scanning}');
      print('Connection:${MyHomePage.bleService.connected}');
      print('restarting...');
      _stopScan();
      _startScan();
      //_onClickedSearchDeviceButton();
    }
    else if(MyHomePage.bleService.scanning &&//if device is not scanning but it is connected then search device
        MyHomePage.bleService.connected){
      print('Scanning:${MyHomePage.bleService.scanning}');
      print('Connection:${MyHomePage.bleService.connected}');
    }
  }
  void _restartScan(){
    _stopScan();
    _startScan();
    refreshScreen();
  }
  void _stopScan() {
    // await bleService.scanStream.cancel();
    // bleService.scanning = false;
    MyHomePage.bleService.stopScan();
    refreshScreen();
  }

  void _startScan() {
    // MyHomePage.bleService.startScan(() {
    //   setState(() {});
    // });
    MyHomePage.bleService.startScan(refreshScreen,_showNoPermissionDialog);

  }

  void _onConnectDevice(index) {
    MyHomePage.bleService.onConnectDevice(index, () {
      setState(() {});
    });
  }

  Future<void> _showNoPermissionDialog() async => showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) => AlertDialog(
      title: const Text('No location permission '),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('No location permission granted.'),
            Text(
                'Location permission is required for BLE to function.'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Acknowledge'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //const Text("Bulunan cihazlar:"),
            Container(
              margin: const EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white, width: 2)),
              height: 300,
              child: ListView.builder(
                itemCount: MyHomePage.bleService.foundBleUARTDevices.length,
                itemBuilder: (context, index) => Card(
                  child: ListTile(
                    dense: true,
                    enabled: !((!MyHomePage.bleService.connected &&
                        MyHomePage.bleService.scanning) ||
                        (!MyHomePage.bleService.scanning &&
                            MyHomePage.bleService.connected)),
                    trailing: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        _stopScan();
                        print('Tarama durduruldu.');
                        if((!MyHomePage.bleService.connected &&
                            MyHomePage.bleService.scanning) ||
                            (!MyHomePage.bleService.scanning &&
                                MyHomePage.bleService.connected)){
                          _onConnectDevice(index);
                          _sendTime();
                          Navigator.pushNamed(context, PumpControlPage.id);

                        }else{

                        }

                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add_link),
                      ),
                    ),
                    subtitle: Text(
                      MyHomePage.bleService.foundBleUARTDevices[index].id,
                      style: TextStyle(color: Colors.black),
                    ),
                    title: Text(
                      "$index: ${MyHomePage.bleService.foundBleUARTDevices[index].name}",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            // const Text("Durum mesajı:"),
            // Container(
            //     margin: const EdgeInsets.all(3.0),
            //     width: 1400,
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         border: Border.all(color: Colors.blue, width: 2)),
            //     height: 90,
            //     child: Scrollbar(
            //         child: SingleChildScrollView(
            //             child: Text(MyHomePage.bleService.logTexts)))),
            // const Text("Alınan veri:"),
            // Container(
            //   margin: const EdgeInsets.all(3.0),
            //   width: 1400,
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(color: Colors.blue, width: 2)),
            //   height: 90,
            //   child: Text(
            //     MyHomePage.bleService.receivedData.join("\n"),
            //   ),
            // ),
            // const Text("Komut Gönder:"),
            // Container(
            //     margin: const EdgeInsets.all(3.0),
            //     padding: const EdgeInsets.all(8.0),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(10),
            //         border: Border.all(color: Colors.blue, width: 2)),
            //     child: Row(children: <Widget>[
            //       Expanded(
            //           child: TextField(
            //         enabled: MyHomePage.bleService.connected,
            //         //controller: command,
            //         decoration: const InputDecoration(
            //             border: InputBorder.none, hintText: 'komut girin'),
            //       )),
            //       RaisedButton(
            //           child: Icon(
            //             Icons.send,
            //             color: MyHomePage.bleService.connected
            //                 ? Colors.blue
            //                 : Colors.white,
            //           ),
            //           onPressed: MyHomePage.bleService.connected
            //               ? () {
            //                   MyHomePage.bleService.sendData(this.command);
            //                 }
            //               : () {}),
            //     ]))
          ],
        ),
      ),
      persistentFooterButtons: [
        Container(
          color: Colors.blue,
          child: Row(

            mainAxisSize: MainAxisSize.max,

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: double.infinity),
                  color:Colors.blue,
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _onClickedSearchDeviceButton,
                        child:MyHomePage.bleService.scanning ? Text('SEARCHING DEVICES...',style:TextStyle(color: Colors.white))
                        // Icon(
                        //   Icons.play_arrow,
                        //   color: !MyHomePage.bleService.scanning &&
                        //       !MyHomePage.bleService.connected
                        //       ? Colors.white
                        //       : Colors.grey,
                        //   semanticLabel: 'SEARCH DEVICE',
                        // ),
                      : Text('SEARCH DEVICE',style:TextStyle(color: Colors.white)),),
                    ],
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     onPressed: MyHomePage.bleService.scanning ? _stopScan : () {},
              //     child: Icon(
              //       Icons.stop,
              //       color: MyHomePage.bleService.scanning
              //           ? Colors.white
              //           : Colors.grey,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     onPressed:
              //     MyHomePage.bleService.connected ? _disconnect : () {},
              //     child: Icon(
              //       Icons.cancel,
              //       color: MyHomePage.bleService.connected
              //           ? Colors.white
              //           : Colors.grey,
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(
              //     onPressed: MyHomePage.bleService.connected
              //         ? () {
              //       _sendTime();
              //       Navigator.pushNamed(context, PumpControlPage.id);
              //     }
              //         : () {},
              //     child: Image.asset(
              //       'images/valve.webp',
              //       color: MyHomePage.bleService.connected
              //           ? Color(0xFF0BFF01)
              //           : Colors.grey,
              //       width: 30,
              //     ),
              //     //color: _connected ? Colors.white : Colors.grey,
              //   ),
              // ),

              // Container(
              //   height: 35,
              //   child: Column(
              //     children: [
              //       if (_scanning)
              //         const Text("Scanning: Scanning")
              //       else
              //         const Text("Scanning: Idle"),
              //       if (_connected)
              //         const Text("Connected")
              //       else
              //         const Text("disconnected."),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
