import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> unidades = ["cm", "m", "km"];
  String? dropDownIn = "m";
  String? dropDownRes = "cm";
  double? resultado;
  final cantidad = TextEditingController();
  @override
  build(context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final spacer = SizedBox(height: height / 40);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Converter"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Medida Inicial"),
            spacer,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: TextField(
                    onChanged: (String val) {
                      setState(() {
                        calc(double.tryParse(val) ?? 0);
                      });
                    },
                    controller: cantidad,
                    decoration: const InputDecoration(
                        hintText: "Ingrese cantidad a convertir",
                        border: InputBorder.none),
                  ),
                ),
                mydropDown(dropDownIn, (select) {
                  setState(() {
                    dropDownIn = select;
                  });
                })
              ],
            ),
            const Text("Resultado"),
            spacer,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(resultado != null ? "$resultado" : "Resultado"),
                mydropDown(dropDownRes, (select) {
                  setState(() {
                    dropDownRes = select;
                    calc(double.tryParse(cantidad.text) ?? 0);
                  });
                })
              ],
            )
          ],
        ),
      ),
    );
  }

  void calc(double x) {
    // 1m = 100cm
    // 1km = 1000m
    // 5m *(1km)/1000m
    switch (dropDownIn) {
      case "m":
        switch (dropDownRes) {
          case "cm":
            //xm 100cm/1m = xcm
            resultado = x * 100;

            break;
          case "km":
            //xm 1km/1000m = xkm
            resultado = x / 1000;

            break;
          case "m":
            //xm 1km/1000m = xkm
            resultado = x;

            break;
          default:
        }
        break;
      case "cm":
        switch (dropDownRes) {
          case "cm":
            //xm 100cm/1m = xcm
            resultado = x;

            break;
          case "km":
            //xcm 1m/100cm = xm
            double m = x / 100;

            //1 km = 1000m
            resultado = m / 1000;

            break;
          case "m":
            // 1m = 100cm
            //xcm 1m/100cm = xm
            resultado = x / 100;

            break;
          default:
        }
        break;
      default:
    }
    // setState(() {});
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
