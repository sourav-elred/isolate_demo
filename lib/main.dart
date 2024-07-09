import 'package:flutter/material.dart';
import 'dart:isolate';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PrimeNumberScreen(),
    );
  }
}

class PrimeNumberScreen extends StatefulWidget {
  const PrimeNumberScreen({super.key});

  @override
  PrimeNumberScreenState createState() => PrimeNumberScreenState();
}

class PrimeNumberScreenState extends State<PrimeNumberScreen> {
  int _number = 0;
  bool _isCalculating = false;
  List<int> _primes = [];

  void _startCalculation() async {
    setState(() {
      _isCalculating = true;
      _primes = [];
    });
    List<int> result = await Isolate.run(() => _generatePrimes(_number));
    setState(() {
      _primes = result;
      _isCalculating = false;
    });
  }

  static List<int> _generatePrimes(int max) {
    final primes = <int>[];
    for (var i = 2; i <= max; i++) {
      var isPrime = true;
      for (var j = 2; j <= i ~/ 2; j++) {
        if (i % j == 0) {
          isPrime = false;
          break;
        }
      }
      if (isPrime) primes.add(i);
    }
    return primes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prime Number Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter a number'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _number = int.tryParse(value) ?? 0;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isCalculating ? null : _startCalculation,
              child:
                  Text(_isCalculating ? 'Calculating...' : 'Calculate Primes'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _primes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_primes[index].toString()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
