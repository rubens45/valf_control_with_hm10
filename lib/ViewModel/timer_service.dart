import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:ninja_hex/ninja_hex.dart';
import 'package:valf_control_with_hm10/main.dart';

import '../View/time_starter_test_page.dart';

class  TimerService {
  BuildContext? context;
  TimeOfDay _selectedTime = TimeOfDay.now();
  //TimerService(this.context);
  Future<String?> getTimeFromSharedPreferences(String itemName) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();

    final String? action = prefs.getString(itemName);
    return action;
  }
  TimeOfDay getStartTimeFromDevice()  {
    var startTime = const TimeOfDay(hour: 00, minute: 00);
    try{
      MyHomePage.bleService.sendData(commandGetStartStopTimeFromDeviceAuxOn);
      sleep(const Duration(milliseconds: 200));
    }catch(e){
      print(e);
    }

    try{
      if(MyHomePage.bleService.receivedData.isNotEmpty){
        if( MyHomePage.bleService.receivedData[0]==0xA1 && (MyHomePage.bleService.receivedData[1]==0xC5 )){
           startTime.replacing(
            hour: MyHomePage.bleService.receivedData[2].toInt(),
            minute: MyHomePage.bleService.receivedData[3].toInt(),
          );
        }
      }
      // else{
      //   return startTime;
      // }

    }catch(e){
      print(e.toString());

    }
    return startTime;

  }
  TimeOfDay getStopTimeFromDevice() {
    var stopTime = const TimeOfDay(hour: 00, minute: 00);
    try{
      MyHomePage.bleService.sendData(commandGetStartStopTimeFromDeviceAuxOff);
      sleep(const Duration(milliseconds: 200));
    }catch(e){
      print(e);
    }

    try{
      if(MyHomePage.bleService.receivedData.isNotEmpty){
        if(MyHomePage.bleService.receivedData[0]==0xA1 && (MyHomePage.bleService.receivedData[1]==0xC6 )){
           stopTime.replacing(
            hour: MyHomePage.bleService.receivedData[2].toInt(),
            minute: MyHomePage.bleService.receivedData[3].toInt(),
          );
        }
      }

    }catch(e){
      print(e);
    }
    return stopTime;
  }
  sendTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != _selectedTime) {
      _selectedTime = timeOfDay;
      List<int> _time = [0xA1, 0xB6]; //Pump1 timer off
      List<int> _autoMod = [0xA1, 0xBA, 0x02, 0x00, 0x00];
      print(_time);

      _time.add(timeOfDay.hour);
      _time.add(timeOfDay.minute);
      int _zero_Second = 0x00;
      _time.add(_zero_Second);
      print(_time.toHex);
      print(_time);

      MyHomePage.bleService.sendData(_time);

      Timer(Duration(milliseconds: 200), () {
        MyHomePage.bleService.sendData(_autoMod);
      });
     // return _selectedTime;
    }
  }
  sendAuto(device){
    if (device == 'LAMP'){
      List<int> _autoMod = [0xA1, 0xBA, 0x02, 0x00, 0x00];
      MyHomePage.bleService.sendData(_autoMod);
    }
    if (device == 'AUX'){
      List<int> _autoMod = [0xA1, 0xBB, 0x02, 0x00, 0x00];
      MyHomePage.bleService.sendData(_autoMod);
    }
    if (device == 'PUMP'){
      List<int> _autoMod = [0xA1, 0xB9, 0x02, 0x00, 0x00];
      MyHomePage.bleService.sendData(_autoMod);
    }
    if (device == 'PUMP'){
      List<int> _autoMod = [0xA1, 0xB9, 0x02, 0x00, 0x00];
      MyHomePage.bleService.sendData(_autoMod);
    }

  }
  saveTimeToSharedPreferences(String itemName) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    String _prefsHour = _selectedTime.hour < 10
        ? '0' + _selectedTime.hour.toString()
        : _selectedTime.hour.toString();
    String _prefsMinute = _selectedTime.minute < 10
        ? '0' + _selectedTime.minute.toString()
        : _selectedTime.minute.toString();
    String _prefsTime = _prefsHour + ':' + _prefsMinute;
    await prefs.setString(itemName, _prefsTime);
  }

  String getSelectedTime(Object time) {
    return _selectedTime.toString()+time.toString();
  }
}
