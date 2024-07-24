import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CurrencyRates(),
    );
  }
}

class CurrencyRates extends StatefulWidget {
  @override
  _CurrencyRatesState createState() => _CurrencyRatesState();
}

class _CurrencyRatesState extends State<CurrencyRates> {
  Map<String, dynamic> _rates = {};
  String _error = '';

  Future<void> _fetchRates() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/exchange/rates/'));
      if (response.statusCode == 200) {
        setState(() {
          _rates = json.decode(response.body)['rates'];
          _error = '';
        });
      } else {
        setState(() {
          _error = 'Failed to load exchange rates';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rates'),
      ),
      body: Center(
        child: _rates.isEmpty
            ? _error.isNotEmpty
                ? Text(_error)
                : Text('Press the button to fetch rates')
            : ListView.builder(
                itemCount: _rates.length,
                itemBuilder: (context, index) {
                  String currency = _rates.keys.elementAt(index);
                  return ListTile(
                    title: Text('$currency: ${_rates[currency]}'),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchRates,
        child: Icon(Icons.refresh),
      ),
    );
  }
}
