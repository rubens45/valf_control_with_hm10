import 'dart:async' show Future, Stream, StreamSubscription;
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ninja_hex/ninja_hex.dart';
//import 'package:ninja_hex/ninja_hex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

Uuid _UART_UUID = Uuid.parse("0000ffe0-0000-1000-8000-00805f9b34fb");
Uuid _UART_RX = Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb");
Uuid _UART_TX = Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb");

class BleService {
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> foundBleUARTDevices = [];
  late StreamSubscription<DiscoveredDevice> scanStream;
  late Stream<ConnectionStateUpdate> currentConnectionStream;
  late StreamSubscription<ConnectionStateUpdate> connection;
  late QualifiedCharacteristic txCharacteristic;
  late QualifiedCharacteristic rxCharacteristic;
  late Stream<List<int>> receivedDataStream;
  late TextEditingController dataToSendText;
  bool scanning = false;
  bool connected = false;
  String logTexts = "";
  Icon  bleIcon = const Icon(Icons.bluetooth_searching_outlined);

  List<int> receivedData = [];
  int numberOfMessagesReceived = 0;
  List<int> command = [0xA1, 0xB9, 0x01, 0x00, 0x00];

  void sendData(List<int> command) async {
    await flutterReactiveBle.writeCharacteristicWithResponse(rxCharacteristic,
        value: command); //_dataToSendText.text.codeUnits);
  }

    onNewReceivedData(List<int> data) {
    numberOfMessagesReceived += 1;
    receivedData=data;
    print('Cihazdan gelen veri : ${data.toHex}');
    final ValueChanged<String> update;

    Future<List<int>> getReceivedData() async {
      return receivedData;
    }

    //     () {
    //   update("100");
    // }        //.add("$numberOfMessagesReceived: ${String.fromCharCodes(data)}");

    // if (receivedData.length > 5) {
    //   receivedData.removeAt(0);
    // }
  }

  void disconnect() async {
    await connection.cancel();
    connected = false;
  }

  void stopScan() async {
    await scanStream.cancel();
    scanning = false;
  }

  void startScan(VoidCallback refreshScreen,  showNoPermissionDialog) async {
    bool goForIt = false;
    PermissionStatus permission;
    if (Platform.isAndroid) {
      permission = await Permission.bluetoothScan.request();
      Permission.bluetooth.request();
      Permission.location.request();
      Permission.bluetoothAdvertise.request();
      Permission.bluetoothConnect.request();

      if (permission == PermissionStatus.granted) goForIt = true;
      //print(permission);
    } else if (Platform.isIOS) {
      goForIt = true;
    }
    if (goForIt) {
      //TODO replace True with permission == PermissionStatus.granted is for IOS test
      foundBleUARTDevices = [];
      scanning = true;
      refreshScreen();
      scanStream = flutterReactiveBle
          .scanForDevices(withServices: [_UART_UUID]).listen((device) {
        if (foundBleUARTDevices.every((element) => element.id != device.id)) {
          foundBleUARTDevices.add(device);
          refreshScreen();
        }
      }, onError: (Object error) {
        logTexts = "${logTexts}ERROR while scanning:$error \n";
        refreshScreen();
      });
    } else {
      await showNoPermissionDialog();
    }
  }

  void onConnectDevice(index,VoidCallback refreshScreen) {
    currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id: foundBleUARTDevices[index].id,
      prescanDuration: Duration(seconds: 1),
      withServices: [_UART_UUID, _UART_RX, _UART_TX],
    );
    logTexts = "";
    refreshScreen();
    connection = currentConnectionStream.listen((event) {
      var id = event.deviceId.toString();
      switch (event.connectionState) {
        case DeviceConnectionState.connecting:
          {
            logTexts = "${logTexts}Connecting to $id\n";
            bleIcon = Icon(Icons.bluetooth_searching_outlined);
            break;
          }
        case DeviceConnectionState.connected:
          {
            connected = true;
            bleIcon = const Icon(Icons.bluetooth_connected_outlined);
            logTexts = "${logTexts}Connected to $id\n";
            numberOfMessagesReceived = 0;
            receivedData = [];
            txCharacteristic = QualifiedCharacteristic(
                serviceId: _UART_UUID,
                characteristicId: _UART_TX,
                deviceId: event.deviceId);
            receivedDataStream =
                flutterReactiveBle.subscribeToCharacteristic(txCharacteristic);
            receivedDataStream.listen((data) {
              onNewReceivedData(data);
            }, onError: (dynamic error) {
              logTexts = "${logTexts}Error:$error$id\n";
            });
            rxCharacteristic = QualifiedCharacteristic(
                serviceId: _UART_UUID,
                characteristicId: _UART_RX,
                deviceId: event.deviceId);
            break;
          }
        case DeviceConnectionState.disconnecting:
          {
            connected = false;
            logTexts = "${logTexts}Disconnecting from $id\n";
            break;
          }
        case DeviceConnectionState.disconnected:
          {
            logTexts = "${logTexts}Disconnected from $id\n";
            break;
          }
      }
      refreshScreen();
    });
  }
}
