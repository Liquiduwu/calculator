import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _currentNumber = "";
  double _firstNumber = 0;
  String _operation = "";
  bool _isNewNumber = true;
  String _history = "";

  void _onNumberPressed(String number) {
    setState(() {
      if (_output == "Error") {
        _output = number;
        _isNewNumber = false;
        return;
      }

      if (_isNewNumber) {
        _output = number;
        _isNewNumber = false;
      } else {
        if (number == '.' && _output.contains('.')) return;
        if (_output.length < 12) {
          _output += number;
        }
      }
      _currentNumber = _output;
    });
  }

  void _onOperationPressed(String operation) {
    if (_output == "Error") return;
    
    setState(() {
      try {
        _firstNumber = double.parse(_output);
        _operation = operation;
        _isNewNumber = true;
        _history = '${_formatNumber(_firstNumber)} $operation';
      } catch (e) {
        _output = "Error";
        _clearAll();
      }
    });
  }

  String _formatNumber(double number) {
    String result = number.toString();
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0*$'), '')
                    .replaceAll(RegExp(r'\.$'), '');
    }
    return result;
  }

  void _onEqualPressed() {
    if (_operation.isEmpty || _output == "Error") return;

    setState(() {
      try {
        double secondNumber = double.parse(_currentNumber);
        double result;

        switch (_operation) {
          case '+':
            result = _firstNumber + secondNumber;
            break;
          case '-':
            result = _firstNumber - secondNumber;
            break;
          case '×':
            result = _firstNumber * secondNumber;
            break;
          case '÷':
            if (secondNumber == 0) {
              throw Exception('Division by zero');
            }
            result = _firstNumber / secondNumber;
            break;
          default:
            return;
        }

        _history = '${_formatNumber(_firstNumber)} $_operation ${_formatNumber(secondNumber)} =';
        _output = _formatNumber(result);
        
      } catch (e) {
        _output = "Error";
      }
      _isNewNumber = true;
    });
  }

  void _clearAll() {
    setState(() {
      _output = "0";
      _currentNumber = "";
      _firstNumber = 0;
      _operation = "";
      _isNewNumber = true;
      _history = "";
    });
  }

  void _clearEntry() {
    setState(() {
      if (_output == "Error") {
        _clearAll();
      } else {
        _output = "0";
        _isNewNumber = true;
      }
    });
  }

  Widget _buildButton(String text, {
    Color? color, 
    VoidCallback? onPressed,
    bool isWide = false
  }) {
    return Expanded(
      flex: isWide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: color != null ? Colors.white : Colors.black87,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomRight,
            child: Text(
              _history,
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.bottomRight,
            child: Text(
              _output,
              style: TextStyle(
                fontSize: _output.length > 10 ? 38 : 48,
                fontWeight: FontWeight.bold,
                color: _output == "Error" ? Colors.red : null,
              ),
            ),
          ),
          const Divider(thickness: 2),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildButton('CE', 
                        color: Colors.red[300],
                        onPressed: _clearEntry),
                      _buildButton('C', 
                        color: Colors.red[400],
                        onPressed: _clearAll),
                      _buildButton('⌫', 
                        color: Colors.orange[300],
                        onPressed: () {
                          if (_output.length > 1) {
                            setState(() {
                              _output = _output.substring(0, _output.length - 1);
                              _currentNumber = _output;
                            });
                          } else {
                            _clearEntry();
                          }
                        }),
                      _buildButton('÷', 
                        color: Colors.orange,
                        onPressed: () => _onOperationPressed('÷')),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('7', onPressed: () => _onNumberPressed('7')),
                      _buildButton('8', onPressed: () => _onNumberPressed('8')),
                      _buildButton('9', onPressed: () => _onNumberPressed('9')),
                      _buildButton('×', 
                        color: Colors.orange,
                        onPressed: () => _onOperationPressed('×')),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('4', onPressed: () => _onNumberPressed('4')),
                      _buildButton('5', onPressed: () => _onNumberPressed('5')),
                      _buildButton('6', onPressed: () => _onNumberPressed('6')),
                      _buildButton('-', 
                        color: Colors.orange,
                        onPressed: () => _onOperationPressed('-')),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('1', onPressed: () => _onNumberPressed('1')),
                      _buildButton('2', onPressed: () => _onNumberPressed('2')),
                      _buildButton('3', onPressed: () => _onNumberPressed('3')),
                      _buildButton('+', 
                        color: Colors.orange,
                        onPressed: () => _onOperationPressed('+')),
                    ],
                  ),
                  Row(
                    children: [
                      _buildButton('0', 
                        isWide: true,
                        onPressed: () => _onNumberPressed('0')),
                      _buildButton('.', onPressed: () => _onNumberPressed('.')),
                      _buildButton('=', 
                        color: Colors.blue,
                        onPressed: _onEqualPressed),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
