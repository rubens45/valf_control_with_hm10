import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:valf_control_with_hm10/main.dart';

import 'info_page.dart';

PreferredSizeWidget  appBar(BuildContext context){
  Icon bleIcon = Icon(Icons.bluetooth_connected_outlined);
  if(MyHomePage.bleService.connected){
    Icon bleIcon = Icon(Icons.bluetooth_connected_outlined);
  }else{
    Icon(Icons.bluetooth_searching_outlined);
  }

  String _time='';
  _time = DateFormat("HH:mm:ss").format(DateTime.now());
  return AppBar(
    leading: null,
    actions: <Widget>[
      Center(
        child: OutlinedButton(

          onPressed: () {

          },
          child:  Text(_time,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, InfoPage.id);
        },
        icon: const Icon(Icons.info_outline),
      ),
      IconButton(
        onPressed: () {
          print(MyHomePage.bleService.connected);
          MyHomePage.bleService.onConnectDevice(0, () {
          setState(){};
          });
        },
        icon: MyHomePage.bleService.bleIcon,
      ),
      // IconButton(
      //     icon: Icon(Icons.close),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     }),
    ],
    title: Text('Gemas Control'),
    backgroundColor: Colors.blue,
  )
  ;
}

//
// class AppBarView extends StatelessWidget {
//   const AppBarView({Key? key}) : super(key: key);
//   final String _title = "Akıllı Vana";
//
//   @override
//   Widget build(BuildContext context) {
//     return  AppBar(
//         title: Text(_title),
//         leading: const Icon(Icons.chevron_left),
//         centerTitle: true,
//         backgroundColor: Colors.red,
//         elevation: 0,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//         toolbarTextStyle: const TextStyle(color: Colors.red),
//         automaticallyImplyLeading: false,
//         actions: [
//
//           IconButton(
//               onPressed: (){},
//               icon: const Icon(Icons.info_outline),
//           ),
//           IconButton(
//             onPressed: (){},
//             icon: const Icon(Icons.bluetooth_connected_outlined),
//           ),
//
//           //const Center(child: CircularProgressIndicator()),
//         ],
//       );
//       //body: Column(children:const[]),
//
//   }
// }
//
