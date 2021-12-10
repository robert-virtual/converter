import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConverterPage extends StatefulWidget {
  @override
  createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final formatter = NumberFormat('#,###,###.######');

  List<String> unidades2 = ["Centimetros", "Metros", "Kilometros"];
  List<String> unidades = ["Metros", "Kilometros","Gramos","Kilogramos","Pies","Millas","Onzas","Libras"];
  String? _startMeasure = "Metros";
  String? _resMeasure = "Kilometros";
  String? resultado;

  // 1cm 1m/100cm = m || 1cm * (1/100) = m || 1cm * 0.01 = m
  // 1cm 1m/100cm = m || 1cm * (1/100) = m || 1cm * 0.01 = m
  // 1km = 1000m
  // 0.01m 1km/1000
  // 1cm = 100m
  // 1m = 0.01m
  // 1cm = 0.00001km
  // 1m 100cm/1m= cm
  // 1m 1km/1000m = km

  // 1km 1cm/0.00001km = cm
  // 1km 1000m/1km= m
  /*
     cm,  metros,   km 
  cm  1,    0.01,   0.00001
  m  100,      1,   0.001
  km 100000,1000,   1
  */
  Map indices2 = {"Centimetros": 0, "Metros": 1, "Kilometros": 2};
  Map indices = {"Metros":0, "Kilometros":1,"Gramos":2,"Kilogramos":3,"Pies":4,"Millas":5,"Onzas":6,"Libras":7};
  Map formulas2 = {
    "Centimetros": [1, 0.01, 0.00001],
    "Metros": [100, 1, 0.001],
    "Kilometros": [100000, 1000, 1]
  };
  /*              Metros,  Kilometros, Gramos,  Kilogramos, Pies,    Millas,      Onzas,    Libras
      Metros:     1,       0.001,      0,       0,          3.28,    0.000621,    0,        0
      Kilometros: 1000,    1,          0,       0,          3280.84, 0.621371,    0,        0
      Gramos:     0,       0,          1,       0.001,      0,       0,           0.002204, 0.035274
      Kilogramos: 0,       0,          1000,    1,          0,       0,           2.20462,  35.274
      Pies:       0.3048,  0.0003048,  0,       0,          1,       0.000189394, 0,        0
      Millas:     1609.34, 1.60934,    0,       0,          5280,    1,           0,        0
      Onzas:      0,       0,          28.3495, 0.0283495,  3.28084, 0,           0.0625,   1
      Libras:     0,       0,          453.592, 0.453592,   0,       0,           16,       1 
   */
  Map formulas = {
      "Metros":     [ 1,       0.001,     0,       0,         3.28,    0.000621,    0,        0        ],
      "Kilometros": [ 1000,    1,         0,       0,         3280.84, 0.621371,    0,        0        ],
      "Gramos":     [ 0,       0,         1,       0.001,     0,       0,           0.002204, 0.035274 ],
      'Kilogramos': [ 0,       0,         1000,    1,         0,       0,           2.20462,  35.274   ],
      'Pies':       [ 0.3048,  0.0003048, 0,       0,         1,       0.000189394, 0,        0        ],
      'Millas':     [ 1609.34, 1.60934,   0,       0,         5280,    1,           0,        0        ],
      'Onzas':      [ 0,       0,         28.3495, 0.0283495, 3.28084, 0,           0.0625,   1        ],
      'Libras':     [ 0,       0,         453.592, 0.453592,  0,       0,           1,        16       ],
    };

  final cantidad = TextEditingController();
  @override
  build(context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            title: Text("Converter"),
          )
        ],
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      mydropDown(_startMeasure, (select) {
                        setState(() {
                          _startMeasure = select;
                          calc(double.tryParse(cantidad.text) ?? 0);
                        });
                      }),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            var aux = _startMeasure;
                            _startMeasure = _resMeasure;
                            _resMeasure = aux;
                            calc(double.tryParse(cantidad.text) ?? 0);
                          });
                        },
                        icon: const Icon(Icons.swap_horiz),
                      ),
                      mydropDown(_resMeasure, (select) {
                        setState(() {
                          _resMeasure = select;
                          calc(double.tryParse(cantidad.text) ?? 0);
                        });
                      }),
                    ],
                  ),
                  const Divider(
                    height: 0,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.poll_rounded, size: 20),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(_startMeasure ?? "Convertir"),
                    ],
                  ),
                  TextField(
                    onChanged: (text) {
                      double amount = double.tryParse(text) ?? 0;
                      setState(() {
                        calc(amount);
                      });
                    },
                    controller: cantidad,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cantidad a convertir...",
                        suffix: IconButton(
                            onPressed: cantidad.clear,
                            icon: const Icon(Icons.close))),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ]),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_border,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        _resMeasure ?? "Resultado",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "${resultado ?? 0}",
                    style: const TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.white,
                          )),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void calc(double x) {
    
    setState(() {
      var res = x * formulas[_startMeasure][indices[_resMeasure]];
      resultado = formatter.format(res);
    });
  }

  Widget mydropDown(String? val, onChanged) {
    return DropdownButton(
      onChanged: onChanged,
      underline: Container(
        height: 0,
      ),
      style: const TextStyle(color: Colors.deepPurple),
      value: val,
      items: unidades
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
    );
  }
}
