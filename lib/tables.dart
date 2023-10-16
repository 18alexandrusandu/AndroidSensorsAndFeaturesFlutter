import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'main.dart';

class SensorTables extends StatefulWidget {
  const SensorTables({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<SensorTables> createState() => SensorTableState();
}

class SensorGridSource extends DataGridSource {
  @override
  List<DataGridRow> rows = [];

  SensorGridSource({required List<String> sensorNames}) {
    rows = sensorNames.map<DataGridRow>((name) {
      return DataGridRow(cells: [
        DataGridCell(columnName: "Index", value: sensorNames.indexOf(name)),
        DataGridCell(columnName: "Sensor name", value: name),
        DataGridCell(columnName: "Action", value: 0)
      ]);
    }).toList();
  }

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((cell) {
      if (cell.columnName == "Action") {
        if (row.getCells()[1].value == "accelerometer")
          return ElevatedButton(
              onPressed: () {
                nav1.currentState?.pushNamed("/", arguments: 1);
              },
              child: Text("Go to chart"));
        if (row.getCells()[1].value == "gyroscope")
          return ElevatedButton(
              onPressed: () {
                nav1.currentState?.pushNamed("/", arguments: 2);
              },
              child: Text("Go to chart"));
        if (row.getCells()[1].value == "light")
          return ElevatedButton(
              onPressed: () {
                nav1.currentState?.pushNamed("/", arguments: 3);
              },
              child: Text("Go to chart"));

        return Container(child: Text("No action"));
      } else
        return Container(
          child: Text(
            cell.value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
        );
    }).toList());
  }
}

class SensorTableState extends State<SensorTables> {
  late DeviceInfoPlugin plugin;
  late List<String> devicesAndSensors = <String>[];
  @override
  void initState() {
    super.initState();
    plugin = DeviceInfoPlugin();

    printDeviceInfos();
  }

  void printDeviceInfos() async {
    AndroidDeviceInfo androidDeviceInfo = await plugin.androidInfo;
    BaseDeviceInfo baseDeviceInfo = await plugin.deviceInfo;
    // print(baseDeviceInfo.data.toString());

    setState(() {
      devicesAndSensors = androidDeviceInfo.systemFeatures.map((element) {
        return element.substring(element.lastIndexOf(".") + 1);
      }).toList();
    });
    /*
    print("Features:${androidDeviceInfo.systemFeatures}");
    print("Board: ${androidDeviceInfo.board}");
    print("Device: ${androidDeviceInfo.device}");
    print("hardware: ${androidDeviceInfo.hardware}");
    print("Display: ${androidDeviceInfo.display}");
    print("Model: ${androidDeviceInfo.model}");
    print("Prodtuct: ${androidDeviceInfo.product}");
    print("Serial number: ${androidDeviceInfo.serialNumber}");
    print("64ABI : ${androidDeviceInfo.supported64BitAbis}");
    print("32ABI : ${androidDeviceInfo.supported32BitAbis}");
    print("D Metrics : ${androidDeviceInfo.displayMetrics}");
    print("Manufacturer:${androidDeviceInfo.manufacturer}");
    print("Manufacturer:${androidDeviceInfo.data}");
    */
  }

  List<List<double>> acc = <List<double>>[];

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
          title: Text("Sensors info"),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          const Text(
            'You will see tables with sensors  technical data',
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              child: SfDataGrid(
                  allowEditing: true,
                  allowSorting: true,
                  allowFiltering: true,
                  allowColumnsResizing: true,
                  rowsPerPage: 3,
                  source: SensorGridSource(sensorNames: devicesAndSensors),
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: "Index", label: Text("Index sensor")),
                    GridColumn(
                        columnName: "Sensor name", label: Text("Sensor name")),
                    GridColumn(columnName: "Action", label: Text("Action")),
                  ]))
        ])

            // This trailing comma makes auto-formatting nicer for build methods.
            ));
  }
}
