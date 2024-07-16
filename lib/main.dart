import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculator());
}

class Calculator extends StatelessWidget {
  const Calculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const CalculatorHome(),
    );
  }
}

class CalculatorHome extends StatefulWidget {
  const CalculatorHome({super.key});

  @override
  State<StatefulWidget> createState() => CalculatorHomeState();
}

class CalculatorHomeState extends State<CalculatorHome> {
  String result = '';
  String view = '';
  String last = '';
  var opr = ['%', '÷', '×', '-', '+', '.', 'e', 'r', 'y'];
  var sign = ['%', '÷', '×', '-', '+', '.'];
  void btnpress(String btnName) {
    setState(() {
      if (btnName == 'AC') {
        result = '';
        view = '';
      } else if (btnName == 'DE') {
        if (result == 'Error' ||
            result == 'NaN' ||
            result == 'Infinity' ||
            result == "Can't Calculate") {
          result = '';
        } else {
          if (result.isNotEmpty) {
            result = result.substring(0, result.length - 1);
            view = view.substring(0, view.length - 1);
          }
        }
        // view = view + btnName;
      } else if (sign.contains(btnName)) {
        if (result.isNotEmpty) {
          last = result[result.length - 1];
          // print(last);
          if (!opr.contains(last)) {
            result = result + btnName;
            view = view + btnName;
          }
        }
      } else if (btnName == '=') {
        if (result.isNotEmpty) {
          String userEquation = result;
          userEquation = userEquation.replaceAll('×', '*');
          userEquation = userEquation.replaceAll('÷', '/');
          try {
            Parser p = Parser();
            Expression exp = p.parse(userEquation);
            ContextModel cm = ContextModel();
            var tampresult = '${exp.evaluate(EvaluationType.REAL, cm)}';
            if (tampresult == 'Error' ||
                tampresult == 'NaN' ||
                tampresult == 'Infinity') {
              result = "Can't Calculate";
            } else {
              // don't show point in integers result
              if (tampresult.contains('.')) {
                var indexOfPoint = tampresult.lastIndexOf('.');
                var valAfterPoint = tampresult.substring(indexOfPoint + 1);
                var vaf = int.parse(valAfterPoint);
                var intResult = (vaf > 0)
                    ? tampresult
                    : tampresult.substring(0, indexOfPoint);
                result = intResult;
                // print(intResult);
              } else {
                result = tampresult;
              }
              // print(result.runtimeType);
            }
          } catch (e) {
            result = 'Error';
          }
        }
      } else if (btnName == '0' || btnName == '00') {
        if (result.isNotEmpty) {
          last = result[result.length - 1];
          if (last == 'e' || last == 'r' || last == 'y') {
            // result = result+btnName;
          } else {
            result = result + btnName;
            view = view + btnName;
          }
        } else {
          result = result + btnName;
          view = view + btnName;
        }
      } else {
        if (result.isNotEmpty) {
          last = result[result.length - 1];
          if (last == 'e' || last == 'r' || last == 'y') {
            // result = result+btnName;
          } else {
            result = result + btnName;
            view = result;
          }
        } else {
          result = result + btnName;
          view = result;
        }
      }
    });
  }

  Widget calcButton(String btnName, Color bgColor, TextStyle textStyle) {
    return SizedBox(
      height: 70,
      width: 70,
      child: ElevatedButton(
        onPressed: () {
          // callback!();
          btnpress(btnName);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shadowColor: Colors.black,

          shape: const CircleBorder(),
          // backgroundColor: Color.fromARGB(255, 30, 39, 54),
        ),
        child: Text(
          btnName,
          style: textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        // height: double.infinity,
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                // height: 200,
                // width: double.infinity,
                // color: Colors.white,
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    reverse: true,
                    scrollDirection: Axis.vertical,
                    child: Text(
                      result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              // color: Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  reverse: true,
                  child: Text(
                    view,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // calcButton('10', Colors.red, TextStyle(fontSize: 25)),

                        calcButton(
                          'AC',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                        calcButton(
                          'DE',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 17,
                          ),
                        ),
                        calcButton(
                          '%',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                              color: Colors.greenAccent, fontSize: 25),
                        ),
                        calcButton(
                          '÷',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                              color: Colors.greenAccent, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton(
                          '7',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '8',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '9',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 30),
                        ),
                        calcButton(
                          '×',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                              color: Colors.greenAccent, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton(
                          '4',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '5',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '6',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 30),
                        ),
                        calcButton(
                          '-',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                              color: Colors.greenAccent, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton(
                          '1',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '2',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '3',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 30),
                        ),
                        calcButton(
                          '+',
                          const Color.fromARGB(255, 30, 39, 54),
                          const TextStyle(
                              color: Colors.greenAccent, fontSize: 25),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton(
                          '00',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 18),
                        ),
                        calcButton(
                          '0',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 25),
                        ),
                        calcButton(
                          '.',
                          const Color.fromARGB(255, 30, 39, 54),
                          TextStyle(
                              color: Colors.greenAccent[100], fontSize: 30),
                        ),
                        calcButton(
                          '=',
                          Colors.green,
                          const TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
