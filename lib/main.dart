import 'dart:io';

import 'package:amap_base/amap_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/aminTest.dart';
import 'package:flutter_app2/dialogTest.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_app2/jiguan/JIGuan.dart';
import 'package:flutter_app2/login/Login.dart';
import 'package:flutter_app2/map/create_map/show_map.screen.dart';
import 'package:flutter_app2/map/draw_on_map/draw_point.screen.dart';
import 'package:flutter_app2/map/location/location.screen.dart';
import 'package:flutter_app2/objectD/Show3D.dart';
import 'package:flutter_app2/objectD/Widght_3D.dart';
import 'package:flutter_app2/permissionTest.dart';
import 'package:flutter_app2/pictureTest.dart';
import 'package:flutter_app2/shop/index.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    //沉浸状态栏
    if(Platform.isAndroid){
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light)
      );
    }
    return MaterialApp(

      debugShowCheckedModeBanner: false,  // 设置这一属性即可去掉debug
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  static const platform = const MethodChannel('dianliang/plugin');
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // Get battery level.
  String _batteryLevel = 'Unknown battery level.';
  //电量获取
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }
    setState(() {
      _batteryLevel = batteryLevel;
      Fluttertoast.showToast(
        msg: _batteryLevel,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos:1,

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            new RaisedButton(
                child: new Text("测试弹框"
                ),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder:  (context) => new HomePage()));
                }
            ),
            new RaisedButton(
                child: new Text("测试动画效果"
                ),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder:  (context) => new AminTest()));
                }
            ),
            new RaisedButton(
                child: new Text("城市选择器"
                ),
                onPressed: () async{
                  Result tempResult = await CityPickers.showCityPicker(
                    context: context,
                  );
                  if (tempResult == null) {
                    return ;
                  }
                  this.setState(() {
                    Fluttertoast.showToast(
                      msg: tempResult.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                    );
                  });
                }
            ),
            new RaisedButton(
                child: new Text("相册选择"
                ),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder:  (context) => new CustomImagePicker()));
                }
            ),
            new RaisedButton(
                child: new Text("权限列表"
                ),
                onPressed: () async {
                  Navigator.push(context, new MaterialPageRoute(builder:  (context) => new PermisstionTest()));
                  //List<Permissions> permissions = await Permission.requestPermissions([PermissionName.Calendar, PermissionName.Camera]);
                }
            ),
            new RaisedButton(
                child: new Text("电量获取"
                ),
                onPressed: () async {
                  _getBatteryLevel();
                  //List<Permissions> permissions = await Permission.requestPermissions([PermissionName.Calendar, PermissionName.Camera]);
                }
            ),
            new RaisedButton(
                child: new Text("登录"
                ),
                onPressed: () async {
                  Navigator.push(context, new MaterialPageRoute(builder:  (context) => new MyLoginWidget()));
                  //List<Permissions> permissions = await Permission.requestPermissions([PermissionName.Calendar, PermissionName.Camera]);
                }
            ),
            new RaisedButton(
                child: new Text("商城"
                ),
                onPressed: () {
                  Navigator.push(context, new MaterialPageRoute(builder:  (context) => new Index()));
                }
            ),
            new RaisedButton(

                child: new Text("地图"
                ),
                onPressed: () {
                  //AMap.init('4a90a0f4575ff0513c6f190e41060edc');
                  Navigator.of(context).push(new PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      //定位
                      //return LocationDemo();
                      //地图
                      //return ShowMapScreen();
                      //跳转到绘制点图标
                      return new DrawPointScreen();
                    },
                  ));
                }
            ),
            new RaisedButton(
                child: new Text("极光推送集成"
                ),
                onPressed: () {
                  Navigator.of(context).push(new PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      //跳转到极光推送演示
                      return new ShowJiGuan();
                    },
                  ));
                }
            ),
            new RaisedButton(

                child: new Text("3D效果图"
                ),
                onPressed: () {
                  //AMap.init('4a90a0f4575ff0513c6f190e41060edc');
                  Navigator.of(context).push(new PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) {
                      //定位
                      //return LocationDemo();
                      //地图
                      //return ShowMapScreen();
                      //跳转到绘制点图标
                      return Show3D();
                    },
                  ));
                }
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


}
