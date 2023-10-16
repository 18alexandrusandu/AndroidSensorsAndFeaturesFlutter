import 'package:flutter/material.dart';
import 'package:all_sensors/all_sensors.dart';
import 'package:light/light.dart';
import "package:syncfusion_flutter_charts/charts.dart";
import "tables.dart";

GlobalKey<NavigatorState> nav1 = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => MyHomePage(
            title: "Sensors measurements page",
            chartIndex: ModalRoute.of(context)!.settings.arguments != null
                ? ModalRoute.of(context)!.settings.arguments! as int
                : 3),
        "/tables": (context) => SensorTables()
      },
      navigatorKey: nav1,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, required this.chartIndex});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final int chartIndex;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState(indexOfChart: chartIndex);
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey nav2 = GlobalKey();
  GlobalKey nav3 = GlobalKey();
  GlobalKey nav4 = GlobalKey();
  GlobalKey nav5 = GlobalKey();

  void scrollInView() {
    switch (indexOfChart) {
      case 1:
        Scrollable.ensureVisible(nav5.currentContext!);
        print("one");
        break;
      case 2:
        Scrollable.ensureVisible(nav2.currentContext!);
        print("two");
        break;
      case 3:
        Scrollable.ensureVisible(nav4.currentContext!);
        print("tree");
        break;
      default:
        Scrollable.ensureVisible(nav4.currentContext!);
        break;
    }
  }

  late int indexOfChart;

  bool isInit = false;
  _MyHomePageState({required this.indexOfChart}) {
    isInit = true;
  }

  @override
  void initState() {
    super.initState();

    isInit = true;
    accelerometerEvents?.listen((event) {
      // print("Accelometer:$event");
      setState(() {
        acc.add(<double>[event.x, event.y, event.z]);
      });
    });
    userAccelerometerEvents?.listen((event) {
      setState(() {
        // print("User Accelometer:$event");
        uacc.add(<double>[event.x, event.y, event.z]);
      });
    });
    proximityEvents?.listen((event) {});

    gyroscopeEvents?.listen((event) {
      setState(() {
        // print("Gyroscope:$event");
        gyro.add(<double>[event.x, event.y, event.z]);
      });
    });

    light = Light();
    light.lightSensorStream.listen((event) {
      setState(() {
        lights.add(event);
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInit) {
        print("IT IS INIT");
        scrollInView();
      }
    });
  }

  List<List<double>> acc = <List<double>>[];
  List<List<double>> uacc = <List<double>>[];
  List<List<double>> gyro = <List<double>>[];
  List<int> lights = <int>[];
  late Light light;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SensorTables()));
              },
              child: const Icon(Icons.table_chart_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const Text(
            'You will see phone sensors data',
          ),
          Container(
              height: 300,
              key: nav5,
              child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableDoubleTapZooming: true,
                      enableSelectionZooming: true),
                  title: ChartTitle(text: "Acceleration absolute"),
                  enableAxisAnimation: true,
                  series: <ChartSeries>[
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute x",
                        dataSource: acc,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[0];
                        }),
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute y",
                        dataSource: acc,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[1];
                        }),
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute y",
                        dataSource: acc,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[2];
                        }),
                  ])),
          Container(
              key: nav3,
              height: 300,
              child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableDoubleTapZooming: true,
                      enableSelectionZooming: true),
                  enableAxisAnimation: true,
                  title: ChartTitle(text: "Acceleration relative"),
                  series: <ChartSeries>[
                    SplineSeries<List<double>, int>(
                        name: "Acceleration relative",
                        dataSource: uacc,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[0];
                        }),
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute y",
                        dataSource: uacc,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[1];
                        }),
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute y",
                        dataSource: uacc,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[2];
                        }),
                  ])),
          Container(
              height: 300,
              key: nav2,
              child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableDoubleTapZooming: true,
                      enableSelectionZooming: true),
                  enableAxisAnimation: true,
                  title: ChartTitle(text: "Gyroscope"),
                  series: <ChartSeries>[
                    SplineSeries<List<double>, int>(
                        name: "Acceleration relative",
                        dataSource: gyro,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[0];
                        }),
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute y",
                        dataSource: gyro,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[1];
                        }),
                    SplineSeries<List<double>, int>(
                        name: "Acceleration absolute y",
                        dataSource: gyro,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value[2];
                        }),
                  ])),
          Container(
              key: nav4,
              height: 300,
              child: SfCartesianChart(
                  zoomPanBehavior: ZoomPanBehavior(
                      enablePinching: true,
                      enablePanning: true,
                      enableDoubleTapZooming: true,
                      enableSelectionZooming: true),
                  enableAxisAnimation: true,
                  title: ChartTitle(text: "Lightning"),
                  series: <ChartSeries>[
                    SplineSeries<int, int>(
                        name: "lights",
                        dataSource: lights,
                        xValueMapper: (value, par) {
                          return par;
                        },
                        yValueMapper: (value, _) {
                          return value;
                        }),
                  ]))
        ]),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
