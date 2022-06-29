import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:valf_control_with_hm10/ViewModel/timer_service.dart';
import 'package:valf_control_with_hm10/pump_timer_page.dart';
import 'package:valf_control_with_hm10/set_timer.dart';
import 'main.dart';

class ReusableCard extends StatefulWidget {
  ReusableCard({
    Key? key,
    required this.timerPage,
    required this.timerButtonBackgroundColor,
    required this.pumpColor,
    required this.switchColor,
    required this.name,
    required this.commandOn,
    required this.commandOff,
    required this.pathOfImage,
    required this.checkStatusCommand,
    required this.isOnMessage,
    required this.isOffMessage,
  }) : super(key: key);



  String timerPage;
  Color timerButtonBackgroundColor;
  List<int> isOnMessage;
  List<int> isOffMessage;
  Color pumpColor;
  final Color switchColor;
  final String name;
  final List<int> commandOff;
  final List<int> commandOn;
  final String pathOfImage;
  final List<int> checkStatusCommand;
  @override
  State<ReusableCard> createState() => _ReusableCardState();
}

class _ReusableCardState extends State<ReusableCard> {
  Color onButtonColor = Colors.grey;
  Color offButtonColor = Colors.grey;
  Color colorsButtonColor = Colors.cyanAccent;
  //bool stateOfColorsButton = true;
  List<int> commandOnRgb = [0xA1, 0xBA, 0x01, 0x00, 0x00];
  List<int> commandOffRgb = [0xA1, 0xBA, 0x00, 0x00, 0x00];
  // void _checkStatusOn() {
  //   MyHomePage.bleService.sendData(widget.checkStatusCommand);
  //   print('Kontrol mesajı gönderildi');
  //   if (MyHomePage.bleService.receivedData == widget.isOnMessage) {
  //     setState(() {
  //       widget.pumpColor = Colors.green;
  //     });
  //   }
  // }
  //
  // void _checkStatusOff() {
  //   MyHomePage.bleService.sendData(widget.checkStatusCommand);
  //   print('Kontrol mesajı gönderildi');
  //   if (MyHomePage.bleService.receivedData == widget.isOffMessage) {
  //     setState(() {
  //       widget.pumpColor = Colors.red;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double sizeOfBox= (MediaQuery.of(context).size.width/4)-25;

    return Container(
      //padding: EdgeInsets.only(left: 15),
      //width: double.infinity,
      //alignment: Alignment.center,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        //color: Color(0xff282E3A),
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(width: 2.0,color: Colors.black87)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text(
              widget.name,
              style: const TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
            ),
          ]),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

            Column(

              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        left: 2.0,
                        right: 2.0,
                        top: 2.0,
                        bottom: 2.0,
                        child: Container(
                          alignment: Alignment.center,
                          width: sizeOfBox,
                          height: sizeOfBox,
                          child:Image.asset(

                              widget.pumpColor == Colors.green ? 'images/power_green.png' : 'images/power_gray.png',
                              fit: BoxFit.cover,

                          ),
                          // decoration: BoxDecoration(
                          //   color: widget.pumpColor == Colors.green ? Colors.green : Colors.grey, //onButtonColor,
                          //   border: Border.all(
                          //     color: Colors.black87,
                          //     width: 3,
                          //   ),
                          // ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: Size(sizeOfBox, sizeOfBox),
                          padding: const EdgeInsets.all(5.0),
                          primary: Colors.black87,
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            onButtonColor=Colors.green;
                            offButtonColor=Colors.grey;
                          });
                          MyHomePage.bleService.sendData(widget.commandOn);
                          Timer(const Duration(milliseconds: 300), () {
                            MyHomePage.bleService
                                .sendData(widget.checkStatusCommand);
                          });

                          print(widget.commandOn);
                          // _checkStatusOn();
                        },
                        child: const Text(''),
                      ),
                    ],
                  ),
                ),
                const Text('ON',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black87),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Image.asset(
                    widget.pathOfImage,
                    color: widget.pumpColor,
                    width: 50,
                    height: 50,
                    

                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        left: 10.0,
                        right: 10.0,
                        top: 10.0,
                        bottom: 10.0,
                        child: Container(
                          // decoration: BoxDecoration(
                          //   color: widget.timerButtonBackgroundColor,
                          //   //color: Color(0xff282E3A),
                          //   border: Border.all(
                          //     color: Colors.black87,
                          //     width: 2,
                          //   ),
                          // ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(child:
                              Image.asset(
                                  widget.timerButtonBackgroundColor == Colors.white ? 'images/auto_gray.png' : 'images/auto_green.png',
                                  width:sizeOfBox+30
                              ) ,
                              onTap: (){
                                widget.timerButtonBackgroundColor = Colors.blue;
                                TimerService().sendAuto(widget.name);
                              },
                          )
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     IconButton(
                      //         icon: Icon(
                      //           Icons.watch_later_outlined,
                      //           size: sizeOfBox/2,
                      //           color: widget.switchColor,
                      //         ),
                      //         onPressed: () {
                      //           Navigator.pushNamed(context, SetTimer.id);
                      //         }),
                      //   ],
                      // ),

                    ],
                  ),
                ),
                widget.name == 'LAMP' ? Row(//Begin of turnery operator
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            left: 10.0,
                            right: 10.0,
                            top: 10.0,
                            bottom: 10.0,
                            child: Container(
                              // decoration: BoxDecoration(
                              //   color: colorsButtonColor,
                              //   //color: Color(0xff282E3A),
                              //   border: Border.all(
                              //     color: Colors.black87,
                              //     width: 2,
                              //   ),
                              // ),
                            ),
                          ),
                          Column(
                            children: [

                              GestureDetector(child:Image.asset('images/colors.png',width: sizeOfBox+30),
                                  // style: TextButton.styleFrom(
                                  //   fixedSize: Size(sizeOfBox, sizeOfBox/2),
                                  //   padding: const EdgeInsets.all(0.0),
                                  //   primary: widget.switchColor,
                                  //   textStyle: const TextStyle(
                                  //       fontSize: 15, fontWeight: FontWeight.bold),
                                  // ),
                                  onTap: () async {

                                    //setState(() {
                                      print('pressed');
                                      if(widget.pumpColor==Colors.green){
                                        MyHomePage.bleService
                                            .sendData(commandOffRgb);
                                        await Future.delayed(Duration(seconds: 1), () {
                                          MyHomePage.bleService
                                              .sendData(commandOnRgb);
                                          //stateOfColorsButton=false;

                                        });
                                      }
                                      // else if(widget.pumpColor==Colors.red){
                                      //   //off basılı iken açıyor - kapatıp tekrar açıyor - en son colors.red yapıyor
                                      //   await Future.delayed(Duration(seconds: 1), () {
                                      //     MyHomePage.bleService
                                      //         .sendData(commandOnRgb);
                                      //     //stateOfColorsButton=false;
                                      //
                                      //   });
                                      //   await Future.delayed(Duration(seconds: 1), () {
                                      //     MyHomePage.bleService
                                      //         .sendData(commandOffRgb);
                                      //     //stateOfColorsButton=true;
                                      //
                                      //   });
                                      //
                                      //   await Future.delayed(Duration(seconds: 1), () {
                                      //     MyHomePage.bleService
                                      //         .sendData(commandOnRgb);
                                      //     //stateOfColorsButton=false;
                                      //
                                      //   });
                                      //
                                      //   setState(() {
                                      //     widget.pumpColor=Colors.green;
                                      //     onButtonColor=Colors.green;
                                      //     offButtonColor=Colors.grey;
                                      //   });
                                      //
                                      // }


                                   // });


                                  },
                                  //child: Text('',style: TextStyle(color: Colors.black87),)
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ):
                Container(),//End of turnery operator
              ],
            ),


            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        left: 2.0,
                        right: 2.0,
                        top: 2.0,
                        bottom: 2.0,
                        child: Container(
                          alignment: Alignment.center,
                          width: sizeOfBox,
                          height: sizeOfBox,
                          child:Image.asset(

                            widget.pumpColor == Colors.red ? 'images/power_red.png' : 'images/power_gray.png',
                            fit: BoxFit.cover,

                          ),
                          // decoration: BoxDecoration(
                          //   color: widget.pumpColor == Colors.red ? Colors.red : Colors.grey,//offButtonColor,
                          //   //color: Color(0xff282E3A),
                          //   border: Border.all(
                          //     color: Colors.black87,
                          //     width:0,
                          //   ),
                          // ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          fixedSize: Size(sizeOfBox,sizeOfBox),
                          padding: const EdgeInsets.all(5.0),
                          primary: widget.switchColor,
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          setState(() {
                            print('pressed');
                            offButtonColor=Colors.red;
                            onButtonColor=Colors.grey;
                          });
                          MyHomePage.bleService.sendData(widget.commandOff);
                          Timer(Duration(milliseconds: 500), () {
                            MyHomePage.bleService
                                .sendData(widget.checkStatusCommand);
                          });
                        },
                        child: const Text(
                          '',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                Text('OFF',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black87),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [



              ],
            ),
          ]),


        ],
      ),
    );
  }
}
