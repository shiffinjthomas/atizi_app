// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:xml/xml.dart';
import 'main.dart';
//import 'package:async/async.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Product extends StatefulWidget {
  final url;
  final ref;
  final shop_id;
  final lang;
  Product(this.url, this.ref, this.shop_id, this.lang);
  @override
  createState() => _ProductState(this.url, this.ref, this.shop_id, this.lang);
}

class _ProductState extends State<Product> {
  @override
  void initState() {
    super.initState();
  }

  // ignore: prefer_typing_uninitialized_variables
  late final _url;
  late final _ref;
  late final _shop_id;
  late final _lang;
  var connectionStatus = false;
  String _scanBarcode = 'Unknown';
  bool result = false;
  _ProductState(this._url, this._ref, this._shop_id, this._lang);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ifactiveController = TextEditingController();
  TextEditingController referencenumberController = TextEditingController();
  TextEditingController qtyonhandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController supplierController = TextEditingController();
  TextEditingController supplierrefController = TextEditingController();
  late bool _switchValue = false;
  late bool _exicuted = false;
  final _site = "https://aritzi.com/api";
  final _key = "ws_key=2UERA8VW94ILC2BU7QBNH3LUZQF2CYKI"; //live
  // final _site = "https://shiffin.gofenice.in/tutpre/api";
  // final _key = "ws_key=4PD3IN6G9WT6TYE67J54F7SCIF99MFC1	"; //local
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

  Future check() async {
    try {
      if (_url != null && _ref == null) {
        if (_url.length == 8) {
          // print(
          //     '$_site/products?filter[reference]=${_url.substring(0, _url.length - 1)}&display=full&output_format=JSON&$_key');
          var response = await http.get(Uri.parse(
              '$_site/products?filter[reference]=${_url.substring(0, _url.length - 1)}&display=full&output_format=JSON&$_key'));
          var data = jsonDecode(utf8.decode(response.bodyBytes));

          var response2 = await http.get(Uri.parse(
              '$_site/stock_availables?filter[id_product]=${data['products'][0]['id']}&display=full&output_format=JSON&$_key'));
          var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
          data['stock'] = data2['stock_availables'][0];
          if (data != null) {
            connectionStatus = true;
          }

          if (!_exicuted) {
            if (data['products'][0]['active'].toString() == '1') {
              _switchValue = true;
            }
          }

          return data;
        }
        if (_url.length == 13) {
          var response = await http.get(Uri.parse(
              '$_site/products?filter[reference]=$_url&display=full&output_format=JSON&$_key'));
          var data = jsonDecode(utf8.decode(response.bodyBytes));
          if (data.isEmpty) {
            var response = await http.get(Uri.parse(
                '$_site/products?filter[reference]=${_url.substring(0, _url.length - 1)}&display=full&output_format=JSON&$_key'));
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            var response2 = await http.get(Uri.parse(
                '$_site/stock_availables?filter[id_product]=${data['products'][0]['id']}&display=full&output_format=JSON&$_key'));
            var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
            data['stock'] = data2['stock_availables'][0];
            if (data != null) {
              connectionStatus = true;
            }

            if (!_exicuted) {
              if (data['products'][0]['active'].toString() == '1') {
                _switchValue = true;
              }
            }

            return data;
          }
          var response2 = await http.get(Uri.parse(
              '$_site/stock_availables?filter[id_product]=${data['products'][0]['id']}&display=full&output_format=JSON&$_key'));
          var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
          data['stock'] = data2['stock_availables'][0];

          if (data != null) {
            connectionStatus = true;
            //  print("connected $connectionStatus");
          }

          if (!_exicuted) {
            if (data['products'][0]['active'].toString() == '1') {
              _switchValue = true;
            }
          }

          return data;
        }
      }
      if (_url == null && _ref != null) {
        var response = await http.get(Uri.parse(
            '$_site/products?filter[reference]=$_ref&display=full&output_format=JSON&$_key'));
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        var response2 = await http.get(Uri.parse(
            '$_site/stock_availables?filter[id_product]=${data['products'][0]['id']}&display=full&output_format=JSON&$_key'));
        var data2 = jsonDecode(utf8.decode(response2.bodyBytes));
        data['stock'] = data2['stock_availables'][0];
        // print(data);
        if (data != null) {
          connectionStatus = true;
          //  print("connected $connectionStatus");
        }

        if (!_exicuted) {
          if (data['products'][0]['active'].toString() == '1') {
            _switchValue = true;
          }
        }

        return data;
      }
    } on SocketException catch (_) {
      connectionStatus = false;
      // print("not connected $connectionStatus");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(title: const Text('Barcode scan')),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: primaryBlack[600],
              border: Border.all(
                color: primaryBlack,
              )),
          child: Text('Devoloped by :Gofenice Tecnologies',
              style: new TextStyle(
                fontSize: 18.0,
              )),
        ),
        body: FutureBuilder(
            future: check(), // a previously-obtained Future or null
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.data != null) {
                //if Internet is connected
                // print(snapshot.data['stock']['id']);
                // print(snapshot.data['products'][0]['name'][0]);

                return SafeArea(
                    child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: <Widget>[
                    for (var i = 0;
                        i < snapshot.data['products'][0]['name'].length;
                        i++)
                      if (snapshot.data['products'][0]['name'][i]['id']
                              .toString() ==
                          _lang)
                        Container(
                          padding: new EdgeInsets.only(right: 13.0),
                          child: new Text(
                            snapshot.data['products'][0]['name'][i]['value']
                                .toString(),
                            overflow: TextOverflow.fade,
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    for (var i = 0;
                        i < snapshot.data['products'][0]['name'].length;
                        i++)
                      if (snapshot.data['products'][0]['name'][i]['id']
                              .toString() ==
                          _lang)
                        TextField(
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                            controller: nameController,
                            decoration: InputDecoration(
                                labelText:
                                    "Name :${snapshot.data['products'][0]['name'][i]['value'].toString()}",
                                hintText: snapshot.data['products'][0]['name']
                                        [i]['value']
                                    .toString())),
                    Row(
                      children: [
                        Text('Active',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            )),
                        Switch(
                          value: _switchValue,
                          onChanged: (value) {
                            setState(() {
                              _switchValue = value;
                              _exicuted = true;
                            });
                          },
                          activeTrackColor: Colors.lightGreenAccent,
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    // ElevatedButton(
                    //   child: Text(' Update Quantity'),
                    //   style: ElevatedButton.styleFrom(
                    //     primary: Colors.red, // background
                    //     onPrimary: Colors.white, // foreground
                    //   ),
                    //   onPressed: () async {
                    //     _showSnackBar(context, 'Wrong Username or password');
                    //   },
                    // ),
                    // TextField(
                    //     controller: ifactiveController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //         labelText:
                    //             "Active :${snapshot.data['products'][0]['active'].toString()}",
                    //         hintText: "Active")),
                    TextField(
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: referencenumberController,
                        decoration: InputDecoration(
                            labelText:
                                "Reference :${snapshot.data['products'][0]['reference'].toString()}",
                            hintText: "Reference")),
                    // TextField(
                    //     style: new TextStyle(
                    //       fontSize: 18.0,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //     controller: supplierController,
                    //     decoration: InputDecoration(
                    //         labelText:
                    //             "Supplier name :${snapshot.data['products'][0]['manufacturer_name'].toString()}",
                    //         hintText: "Supplier name")),
                    TextField(
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: supplierrefController,
                        decoration: InputDecoration(
                            labelText:
                                "Supplier reference :${snapshot.data['products'][0]['supplier_reference'].toString()}",
                            hintText: "Supplier reference")),
                    TextField(
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: isbnController,
                        decoration: InputDecoration(
                            labelText:
                                "ISBN :${snapshot.data['products'][0]['isbn'].toString()}",
                            hintText: "ISBN")),
                    TextField(
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: qtyonhandController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText:
                                "Quantity :${snapshot.data['stock']['quantity'].toString()}",
                            hintText: "Quantity")),
                    TextField(
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText:
                                "Price :${snapshot.data['products'][0]['price'].toString()}",
                            hintText: "Price")),
                    TextField(
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: locationController,
                        decoration: InputDecoration(
                            labelText:
                                "Location :${snapshot.data['stock']['location'].toString()}",
                            hintText: "Location")),
                    ElevatedButton(
                        // onPressed: () => scanBarcodeNormal(),
                        onPressed: () async {
                          if (nameController.text == '') {
                            for (var i = 0;
                                i < snapshot.data['products'][0]['name'].length;
                                i++) {
                              if (snapshot.data['products'][0]['name'][i]['id']
                                      .toString() ==
                                  _lang) {
                                nameController.text = snapshot.data['products']
                                        [0]['name'][i]['value']
                                    .toString();
                              }
                            }
                          }
                          if (ifactiveController.text == '') {
                            ifactiveController.text = snapshot.data['products']
                                    [0]['active']
                                .toString();
                          }
                          var active = _switchValue ? '1' : '0';
                          if (referencenumberController.text == '') {
                            referencenumberController.text = snapshot
                                .data['products'][0]['reference']
                                .toString();
                          }
                          if (isbnController.text == '') {
                            isbnController.text =
                                snapshot.data['products'][0]['isbn'].toString();
                          }
                          if (supplierController.text == '') {
                            supplierController.text = snapshot.data['products']
                                    [0]['manufacturer_name']
                                .toString();
                          }
                          if (supplierrefController.text == '') {
                            supplierrefController.text = snapshot
                                .data['products'][0]['supplier_reference']
                                .toString();
                          }
                          if (qtyonhandController.text == '') {
                            qtyonhandController.text =
                                snapshot.data['stock']['quantity'].toString();
                          }
                          if (priceController.text == '') {
                            priceController.text = snapshot.data['products'][0]
                                    ['price']
                                .toString();
                          }
                          if (locationController.text == '') {
                            locationController.text =
                                snapshot.data['stock']['location'].toString();
                          }
                          var name = <String>[];
                          var meta_description = <String>[];
                          var meta_keywords = <String>[];
                          var meta_title = <String>[];
                          var link_rewrite = <String>[];
                          var description = <String>[];
                          var description_short = <String>[];
                          var available_now = <String>[];
                          var available_later = <String>[];
                          for (var i = 0;
                              i < snapshot.data['products'][0]['name'].length;
                              i++) {
                            name.add(
                                '<language id="${snapshot.data['products'][0]['name'][i]['id']}">${snapshot.data['products'][0]['name'][i]['value']}</language>');
                            meta_description.add(
                                '<language id="${snapshot.data['products'][0]['meta_description'][i]['id']}">${snapshot.data['products'][0]['meta_description'][i]['value']}</language>');
                            meta_keywords.add(
                                '<language id="${snapshot.data['products'][0]['meta_keywords'][i]['id']}">${snapshot.data['products'][0]['meta_keywords'][i]['value']}</language>');
                            meta_title.add(
                                '<language id="${snapshot.data['products'][0]['meta_title'][i]['id']}">${snapshot.data['products'][0]['meta_title'][i]['value']}</language>');
                            meta_title.add(
                                '<language id="${snapshot.data['products'][0]['meta_title'][i]['id']}">${snapshot.data['products'][0]['meta_title'][i]['value']}</language>');
                            link_rewrite.add(
                                '<language id="${snapshot.data['products'][0]['link_rewrite'][i]['id']}">${snapshot.data['products'][0]['link_rewrite'][i]['value']}</language>');
                            description.add(
                                '<language id="${snapshot.data['products'][0]['description'][i]['id']}"><![CDATA[${snapshot.data['products'][0]['description'][i]['value']} ]]></language>');
                            description_short.add(
                                '<language id="${snapshot.data['products'][0]['description_short'][i]['id']}"><![CDATA[${snapshot.data['products'][0]['description_short'][i]['value']} ]]></language>');
                            available_now.add(
                                '<language id="${snapshot.data['products'][0]['available_now'][i]['id']}">${snapshot.data['products'][0]['available_now'][i]['value']}</language>');
                            available_later.add(
                                '<language id="${snapshot.data['products'][0]['available_later'][i]['id']}">${snapshot.data['products'][0]['available_later'][i]['value']}</language>');
                          }
                          name.add(
                              '<language id="$_lang">${nameController.text.trim()}</language>');
                          final userXml =
                              '''<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
  <product>
    <id>${snapshot.data['products'][0]['id'].toString().trim()}</id>
    <id_manufacturer>${snapshot.data['products'][0]['id_manufacturer']}</id_manufacturer>
    <id_supplier>${snapshot.data['products'][0]['id_supplier']}</id_supplier>
    <id_category_default>${snapshot.data['products'][0]['id_category_default']}</id_category_default>
    <id_tax_rules_group>${snapshot.data['products'][0]['id_tax_rules_group']}</id_tax_rules_group>
    <id_shop_default>${snapshot.data['products'][0]['id_shop_default']}</id_shop_default>
    <reference>${referencenumberController.text.trim()}</reference>
    <supplier_reference>${supplierrefController.text.trim()}</supplier_reference>
    <location>${locationController.text.trim()}</location>
    <ean13>${referencenumberController.text.trim()}</ean13>
    <isbn>${isbnController.text.trim()}</isbn>
    <price>${priceController.text.trim()}</price>
    <active>$active</active>
    <meta_description>$meta_description</meta_description>
    <meta_keywords>$meta_keywords</meta_keywords>
    <meta_title>$meta_title</meta_title>
    <link_rewrite>$link_rewrite</link_rewrite>
    <name>$name</name>
    <description>$description</description>
    <description_short>$description_short</description_short>
    <available_now>$available_now </available_now>
    <available_later>$available_later</available_later>
   </product>
</prestashop>''';

                          final userXml2 =
                              '''<prestashop xmlns:xlink="http://www.w3.org/1999/xlink">
  <stock_available>
    <id>${snapshot.data['stock']['id'].toString().trim()}</id>
    <id_product>${snapshot.data['stock']['id_product'].toString().trim()}</id_product>
    <id_product_attribute>${snapshot.data['stock']['id_product_attribute'].toString().trim()}</id_product_attribute>
    <id_shop>${snapshot.data['stock']['id_shop'].toString().trim()}</id_shop>
    <id_shop_group>${snapshot.data['stock']['id_shop_group'].toString().trim()}</id_shop_group>
    <quantity>${qtyonhandController.text.trim()}</quantity>
    <depends_on_stock>${snapshot.data['stock']['depends_on_stock'].toString().trim()}</depends_on_stock>
    <out_of_stock>${snapshot.data['stock']['out_of_stock'].toString().trim()}</out_of_stock>
    <location>${locationController.text.trim()}</location>
  </stock_available>
</prestashop>''';
                          // print(userXml);
                          // print(description);
                          // print(userXml2);
                          if (_shop_id == '0') {
                            final http.Response result = await http.put(
                              Uri.parse(
                                  '$_site/products?$_key&language=$_lang'),
                              headers: <String, String>{
                                'Content-Type': 'text/xml; charset=UTF-8',
                              },
                              body: userXml,
                            );
                            // print(
                            //     '$_site/products?$_key&id_shop=$_shop_id&language=$_lang');
                            final http.Response result2 = await http.put(
                              Uri.parse(
                                  '$_site/stock_availables?$_key&language=$_lang'),
                              headers: <String, String>{
                                'Content-Type': 'text/xml; charset=UTF-8',
                              },
                              body: userXml2,
                            );
                            if (result.statusCode == 200 ||
                                result2.statusCode == 200) {
                              _showSnackBar(context, 'Updated Product');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                            } else {
                              _showSnackBar(
                                  context, 'Cannot Update Product Try Again');
                            }
                          } else {
                            final http.Response result = await http.put(
                              Uri.parse(
                                  '$_site/products?$_key&id_shop=$_shop_id&language=$_lang'),
                              headers: <String, String>{
                                'Content-Type': 'text/xml; charset=UTF-8',
                              },
                              body: userXml,
                            );
                            //  print(result.statusCode);
                            final http.Response result2 = await http.put(
                              Uri.parse(
                                  '$_site/stock_availables?$_key&id_shop=$_shop_id&language=$_lang'),
                              headers: <String, String>{
                                'Content-Type': 'text/xml; charset=UTF-8',
                              },
                              body: userXml2,
                            );
                            if (result.statusCode == 200 ||
                                result2.statusCode == 200) {
                              _showSnackBar(context, 'Updated Product');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()));
                            } else {
                              _showSnackBar(
                                  context, 'Cannot Update Product Try Again');
                            }
                          }
                        },
                        child: Text('Submit Data',
                            style: new TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ))),
                  ],
                ));
              } else {
                //If internet is not connected
                return SafeArea(
                    child: Center(
                  child: DelayedDisplay(
                    delay: Duration(seconds: 5),
                    child: Container(
                        padding: new EdgeInsets.only(top: 100),
                        child: ListView(
                          padding: const EdgeInsets.all(8),
                          children: <Widget>[
                            Text(
                              "Product not found. Try again later",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Row(
                              children: [
                                const Text(
                                  'Select a Shop ',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextField(
                                        style: new TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        controller: refController,
                                        decoration: InputDecoration(
                                            labelText: "Reference No",
                                            hintText: "Reference No")),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          //    fixedSize: const Size(40, 40)
                                          ),
                                      // onPressed: () => scanBarcodeNormal(),
                                      onPressed: () async {
                                        //  print(refController.text);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Product(
                                                    null,
                                                    refController.text,
                                                    dropdownvalue,
                                                    dropdownvalue2)));
                                      },
                                      child: Text('Go')),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            Center(
                              child: Text('OR',
                                  style: new TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(240, 80)),
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
                              child: Text('Scan Again'),
                            ),
                          ],
                        )),
                  ),
                ));
              }
            }));
  }
}

void _showSnackBar(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(message),
      content: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
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
