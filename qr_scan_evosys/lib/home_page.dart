import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'modals/registros.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String datos = "";
  List<Registros> data = [];
  Future<List<Registros>> nitifications() async {
    // Preferences.codcng = "MA31CR97PA";
    var url = Uri(
      scheme: 'https',
      host: 'url web',
      path: 'EVOSYS/cnDatas.php',
    );
    var response = await http.post(url).timeout(const Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    print(response.body);

    List<Registros> registros = [];
    for (datos in datos) {
      registros.add(Registros.fromJson(datos));
    }

    return registros;
  }

  Future<void> reload() async {
    data = [];
    var url = Uri(
      scheme: 'https',
      host: 'url web',
      path: 'EVOSYS/cnDatas.php',
    );
    var response = await http.post(url).timeout(const Duration(seconds: 90));

    var datos = jsonDecode(response.body);

    print(response.body);

    List<Registros> registros = [];
    for (datos in datos) {
      registros.add(Registros.fromJson(datos));
    }
    setState(() {
      data.addAll(registros);
    });
  }

  @override
  void initState() {
    super.initState();
    nitifications().then((value) async {
      setState(() {
        data.addAll(value);
        // loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Color.fromARGB(255, 230, 230, 230),
          ),
          SafeArea(
            child: Column(
              children: [
                GestureDetector(
                  child: Container(
                      width: double.infinity,
                      child: Icon(
                        Icons.qr_code_scanner,
                        size: _screenSize.width * 0.35,
                      )),
                  onTap: () async {
                    String barcosScan = await FlutterBarcodeScanner.scanBarcode(
                        '#3D8BEF', 'Cancelar', false, ScanMode.QR);

                    setState(() {
                      datos = barcosScan;
                    });

                    if (datos != "-1") {
                      var dats = datos.replaceAll("\n", "\$nom");
                      var datas = dats.replaceAll("\\n", "\$nom");
                      var nombre = datas.split('N:');
                      var nombre2 = nombre[2].split('\$nom');
                      var telefono = datas.split('TEL:');
                      var telefono2 = telefono[1].split('\$nom');

                      var email = datas.split('EMAIL:');
                      var email2 = email[1].split('\$nom');

                      var orgnz = datas.split('ORG:');
                      var orgnz2 = orgnz[1].split('\$nom');

                      Confirmacion(nombre2[0], telefono2[0], email2[0],
                          orgnz2[0], datos);
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: reload,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: ((context, index) {
                      return Datos(
                          data[index].nombre.toString(),
                          data[index].telefono.toString(),
                          data[index].email.toString(),
                          data[index].org.toString());
                    }),
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget Datos(String nombre, String movil, String email, String organizacin) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: ListTile(
          // leading: Image(image: AssetImage('assets/modulo.png')),
          title: Text('$nombre'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Telefono: $movil '),
              Text('Email: $email'),
              Text('$organizacin')
            ],
          ),
        ),
      ),
    );
  }

  void Confirmacion(tel, organizacion, email, nombre, data) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: double.infinity, child: Text(data)),
            ],
          ),
          actions: [
            GestureDetector(
              child: const Text('Cancelar'),
              onTap: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
                onPressed: () async {
                  var url = Uri(
                    scheme: 'https',
                    host: 'url web',
                    path: 'EVOSYS/rgDatasScan.php',
                  );
                  var response = await http.post(url, body: {
                    'NOM': nombre,
                    'TEL': tel,
                    'EML': email,
                    'ORG': organizacion,
                    'DTA': data
                  }).timeout(const Duration(seconds: 90));

                  if (response.body != '') {
                    Navigator.of(context).pop();

                    data = nitifications();
                  }
                },
                child: Text('Guardar')),
          ],
        );
      },
    );
  }
}
