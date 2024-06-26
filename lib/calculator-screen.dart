import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String input = "";
  String result = "0";

  List<String> buttons = [
    ' ',
    'AC',
    ' ',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    'DEL',
    '0',
    '.',
    '=',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerRight,
                child: Text(
                  input,
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerRight,
                child: Text(
                  result,
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ]),
          ),
          Divider(color: const Color(0xFF1d2630)),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(buttons[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget CustomButton(String buttonText) {
    return InkWell(
      splashColor: Color.fromARGB(255, 14, 13, 13),
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        setState(() {
          handleButtons(buttonText);
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBackgroundColor(buttonText),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
              spreadRadius: 0.5,
              offset: Offset(-3, -3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
              color: getColor(buttonText),
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  getColor(String buttonText) {
    if (buttonText == '÷' ||
        buttonText == 'x' ||
        buttonText == '-' ||
        buttonText == '+' ||
        buttonText == 'DEL' ||
        buttonText == ' ' ||
        buttonText == ' ') {
      return Color(0xFFFF2F2F);
    }
    return Colors.white;
  }

  getBackgroundColor(String buttonText) {
    if (buttonText == 'AC') {
      return Color(0xFFFF2F2F);
    } else if (buttonText == '=') {
      return Color.fromARGB(255, 52, 199, 52);
    }
    return Color.fromARGB(255, 0, 0, 0);
  }

  handleButtons(String buttonText) {
    if (buttonText == 'AC') {
      input = "";
      result = "0";
    } else if (buttonText == 'DEL') {
      if (input.isNotEmpty)
        // Verifica se a string não está vazia
        input = input.substring(0, input.length - 1);
    } else if (buttonText == '=') {
      input = input.replaceAll('x', '*');
      input = input.replaceAll('÷', '/');

      try {
        Parser p = Parser();
        Expression exp = p.parse(input);
        result =
            '${exp.evaluate(EvaluationType.REAL, ContextModel())}'.toString();
      } catch (e) {
        result = "Error";
      }

      if (result == "Infinity") result = "Error";

      if (input.endsWith(".0")) input = input.replaceAll(".0", "");

      if (result.endsWith(".0")) {
        result = result.replaceAll(".0", "");
        return;
      }
    } else {
      input += buttonText;
    }
  }
}
