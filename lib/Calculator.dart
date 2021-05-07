// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'bignum.dart';

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.grey[800],
        brightness: Brightness.dark,
        toolbarHeight: 34,
        shadowColor: Colors.transparent,
      ),
      body: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final operators = ['+', '-', 'x', '÷'];
  final List<String> _calculatorString = [''];
  var _inputString = '';

  void _setCalculatorEquation(value) {
    setState(() {
      if (operators.contains(value)) {
        if (_calculatorString.length == 1 && _calculatorString[0] == '') return;
        if (!operators.contains(_calculatorString.last)) {
          debugPrint("input string: $_inputString");
          debugPrint("calculate string: $_calculatorString");
          _calculatorString.add(value);
          _calculatorString.add('');
          _inputString = '';
        }
      } else if (value == 'AC') {
        _calculatorString.clear();
        _calculatorString.add('');
        _inputString = '';
      } else if (value == '=') {
        _inputString = '';
        _calculate();
      } else if (value == '.') {
        if (_inputString.isEmpty)
          _inputString = '0';
        else if (_inputString.contains('.')) return;
        _inputString = _inputString + value;
        _calculatorString.last = _inputString;
      } else {
        if (_inputString.isEmpty && value == '0') return;
        _inputString = _inputString + value;
        _calculatorString.last = _inputString;
      }
    });
  }

  void separateEquation(List operator, List number) {
    operator.clear();
    number.clear();

    if (_calculatorString.last == '') {
      _calculatorString.removeRange(
          _calculatorString.length - 2, _calculatorString.length - 1);
    }
    for (var i = 0; i < _calculatorString.length; i++) {
      if (i % 2 == 1) {
        operator.add(_calculatorString[i]);
      } else {
        number.add(BigNum.tryParse(_calculatorString[i])!);
      }
    }
  }

  void _calculate() {
    final List<String> _operatorList = [];
    final List<BigNum> _numList = [];

    setState(() {
      separateEquation(_operatorList, _numList);
      debugPrint('calculatorString: $_calculatorString');

      while (true) {
        if (_operatorList.indexOf('x') != -1) {
          var i = _operatorList.indexOf('x');
          var res = _numList[i] * _numList[i + 1];
          _operatorList.removeAt(i);
          _numList.replaceRange(i, i + 2, [res]);
        } else if (_operatorList.indexOf('÷') != -1) {
          var i = _operatorList.indexOf('÷');
          var res = _numList[i] / _numList[i + 1];
          _operatorList.removeAt(i);
          _numList.replaceRange(i, i + 2, [res]);
        } else if (_operatorList.indexOf('+') != -1) {
          var i = _operatorList.indexOf('+');
          var res = _numList[i] + _numList[i + 1];
          _operatorList.removeAt(i);
          _numList.replaceRange(i, i + 2, [res]);
        } else if (_operatorList.indexOf('-') != -1) {
          var i = _operatorList.indexOf('-');
          var res = _numList[i] - _numList[i + 1];
          _operatorList.removeAt(i);
          _numList.replaceRange(i, i + 2, [res]);
        } else {
          break;
        }
      }
      _calculatorString.replaceRange(
          0, _calculatorString.length, [_numList[0].round(15).toString()]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[800],
      child: Column(
        children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(
                      _calculatorString[0] == ''
                          ? '0'
                          : _calculatorString.join(""),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _calculatorString.isNotEmpty &&
                                _calculatorString.length > 5
                            ? 48.0
                            : 72.0,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: SafeArea(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      children: [
                        _girdButton(Colors.grey[700], 'AC'),
                        _girdButton(Colors.grey[700], '+/-'),
                        _girdButton(Colors.grey[700], '%'),
                        _girdButton(Colors.orange, '÷'),
                      ],
                    ),
                    Row(
                      children: [
                        _girdButton(Colors.grey[600], '7'),
                        _girdButton(Colors.grey[600], '8'),
                        _girdButton(Colors.grey[600], '9'),
                        _girdButton(Colors.orange, 'x'),
                      ],
                    ),
                    Row(
                      children: [
                        _girdButton(Colors.grey[600], '4'),
                        _girdButton(Colors.grey[600], '5'),
                        _girdButton(Colors.grey[600], '6'),
                        _girdButton(Colors.orange, '-'),
                      ],
                    ),
                    Row(
                      children: [
                        _girdButton(Colors.grey[600], '1'),
                        _girdButton(Colors.grey[600], '2'),
                        _girdButton(Colors.grey[600], '3'),
                        _girdButton(Colors.orange, '+'),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(right: 2, top: 2),
                            color: Colors.grey[600],
                            child: TextButton(
                              onPressed: () => _calculatorString.isEmpty
                                  ? null
                                  : _setCalculatorEquation('0'),
                              child: Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27.5,
                                  fontWeight: FontWeight.w300,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        _girdButton(Colors.grey[600], '.'),
                        _girdButton(Colors.orange, '='),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _girdButton(Color? color, String text) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        margin: EdgeInsets.only(right: 2, top: 2),
        color: color,
        child: FittedBox(
          fit: BoxFit.fill,
          child: TextButton(
            onPressed: () => _setCalculatorEquation(text),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27.5,
                  fontWeight: FontWeight.w300),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
