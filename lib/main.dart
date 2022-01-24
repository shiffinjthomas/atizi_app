// ignore_for_file: unnecessary_new

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'product.dart';
import 'shop.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scanBarcode = 'Unknown';

  bool result = false;
  // final _site = "https://aritzi.com/api";
  // final _key = "ws_key=4PD3IN6G9WT6TYE67J54F7SCIF99MFC1"; //live
  // final _site = "https://shiffin.gofenice.in/tutpre/api";
  // final _key = "ws_key=QCZIYHRUY39FQZU1MSNSM76QLX1RRIFP	"; //local
  @override
  void initState() {
    _shops();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes = 'Unknown';

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      if (_scanBarcode != 'Failed to get platform version.' ||
          _scanBarcode != 'Unknown') {
        result = true;
      } else {
        result = false;
      }
    });
  }

  _shops() async {
    // var response = await http
    //     .get(Uri.parse('$_site/shops&display=full&output_format=JSON&$_key'));
    // var data = jsonDecode(utf8.decode(response.bodyBytes));
    // print(data);
    // setState(() {
    //   List<Shop> shops = data;
    // });
  }

  String dropdownvalue = '0';

  List<Shop> shops = <Shop>[
    const Shop('0', 'All Shops'),
    const Shop('1', 'Aritzi General'),
    const Shop('5', 'Verzati General'),
    const Shop('6', 'Aritzi Spain'),
    const Shop('7', 'Aritzi France'),
    const Shop('8', 'Aritzi Germany'),
    const Shop('9', 'Aritzi Italy'),
    const Shop('10', 'Verzati Spain'),
    const Shop('11', 'Verzati France'),
    const Shop('12', 'Verzati Germany'),
    const Shop('13', 'Verzati Italy'),
  ];
  String dropdownvalue2 = '1';

  List<Languages> languages = <Languages>[
    const Languages('1', 'English (English)'),
    const Languages('3', 'Español (Spanish)'),
    const Languages('6', 'Deutsch (German)'),
    const Languages('7', 'Français (French)'),
    const Languages('8', 'Italiano (Italian)'),
  ];
  static const MaterialColor primaryBlack = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFFDAB22E),
      100: Color(0xFFDAB22E),
      200: Color(0xFFDAB22E),
      300: Color(0xFFDAB22E),
      400: Color(0xFFDAB22E),
      500: Color(_blackPrimaryValue),
      600: Color(0xFFDAB22E),
      700: Color(0xFFDAB22E),
      800: Color(0xFFDAB22E),
      900: Color(0xFFDAB22E),
    },
  );
  static const int _blackPrimaryValue = 0xFFDAB22E;
  TextEditingController refController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: primaryBlack,
            fontFamily: "Arial",
            textTheme: const TextTheme(
              button: TextStyle(color: Colors.white, fontSize: 20.0),
            )),
        home: Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: primaryBlack[600],
                  border: Border.all(
                    color: primaryBlack,
                  )),
              child: const Text('Devoloped by :Gofenice Tecnologies',
                  style: TextStyle(
                    fontSize: 18.0,
                  )),
            ),
            body: Builder(builder: (BuildContext context) {
              return ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  const SizedBox(
                    height: 100.0,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Shop  ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton(
                        value: dropdownvalue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: shops.map((Shop items) {
                          return DropdownMenuItem(
                            value: items.id,
                            child: Text(items.name),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Lang  ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      DropdownButton(
                        value: dropdownvalue2,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: languages.map((Languages items) {
                          return DropdownMenuItem(
                            value: items.id,
                            child: Text(items.name),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue2 = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: <Widget>[
                      new Flexible(
                        child: new TextField(
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: refController,
                            decoration: const InputDecoration(
                                labelText: "Reference No",
                                hintText: "Reference No")),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              //    fixedSize: const Size(40, 40)
                              ),
                          // onPressed: () => scanBarcodeNormal(),
                          onPressed: () async {
                            // print(dropdownvalue);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Product(
                                        null,
                                        refController.text,
                                        dropdownvalue,
                                        dropdownvalue2)));
                          },
                          child: const Text('Go')),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Center(
                    child: Text('OR',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Flex(
                          direction: Axis.vertical,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(240, 80)),
                                // onPressed: () => scanBarcodeNormal(),
                                onPressed: () async {
                                  await scanBarcodeNormal();
                                  // print(_scanBarcode);
                                  if (result) {
                                    if (_scanBarcode != '' ||
                                        _scanBarcode !=
                                            'Failed to get platform version.' ||
                                        _scanBarcode != 'Unknown') {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Product(
                                                  _scanBarcode,
                                                  null,
                                                  dropdownvalue,
                                                  dropdownvalue2)));
                                    }
                                  }
                                },
                                child: const Text('Scan')),
                          ])),
                ],
              );
            })));
  }
}

class Shop {
  const Shop(this.id, this.name);

  final String name;
  final String id;
}

class Languages {
  const Languages(this.id, this.name);

  final String name;
  final String id;
}
