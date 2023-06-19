import 'package:flutter/material.dart';
import 'package:phonefield/phone_form.dart';

void main() {
  runApp(const PhoneFormDemo());
}

class PhoneFormDemo extends StatelessWidget {
  const PhoneFormDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Form Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Phone Form Demo"),
        ),
        body: const PhoneForm(),
      ),
    );
  }
}

