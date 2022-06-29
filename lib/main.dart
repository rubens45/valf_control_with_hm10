import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:valf_control_with_hm10/View/time_starter_test_page.dart';
import 'package:valf_control_with_hm10/aux_timer_page.dart';
import 'package:valf_control_with_hm10/pump_control_page.dart';
import 'package:valf_control_with_hm10/pump_timer_page.dart';
import 'package:valf_control_with_hm10/rgb_timer_page.dart';
import 'package:valf_control_with_hm10/search_devices_page.dart';
import 'package:valf_control_with_hm10/set_timer.dart';
//import 'dart:io' show Platform;
import 'View/test_timer_page.dart';
import 'ble_service.dart';
import 'info_page.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// This flutter app demonstrates an usage of the flutter_reactive_ble flutter plugin
// This app works only with BLE devices which advertise with a Nordic UART Service (NUS) UUID
Uuid _UART_UUID = Uuid.parse("0000ffe0-0000-1000-8000-00805f9b34fb");
Uuid _UART_RX = Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb");
Uuid _UART_TX = Uuid.parse("0000ffe1-0000-1000-8000-00805f9b34fb");

Future main() async{
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}
// Future initialization(BuildContext? context) async {
//   await Future.delayed(const Duration(seconds: 3));
// }
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemas Control',
      theme: ThemeData().copyWith(
        textTheme: TextTheme(button: TextStyle(color: Colors.black87)),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        //primarySwatch: Colors.blue,
        //scaffoldBackgroundColor: Color(0xFF212530),
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: ConnectionPage(),
      home: MyHomePage(title: 'Gemas Control'),
      initialRoute: MyHomePage.id,
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        InfoPage.id: (context) => InfoPage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        PumpControlPage.id: (context) => PumpControlPage(),
        SetTimer.id : (context) => SetTimer(),
        PumpTimer.id : (context) => PumpTimer(),
        AuxTimer.id : (context) => AuxTimer(),
        RgbTimer.id : (context) => RgbTimer(),
        TestTimer.id : (context) => TestTimer(),
        TimeToStartStopPage.id :(context) =>   TimeToStartStopPage( buttonName: 'START',),
        //ChatScreen.id : (context) => ChatScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  static String id = 'my_home_page';
  static BleService bleService = BleService();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  void initState() {
    super.initState();
    MyHomePage.bleService.dataToSendText = TextEditingController();
  }

  @override
  Widget build(BuildContext context) => const SearchDevices();
}
