import 'package:flutter/material.dart';

void main() {
  runApp(const TestScreen());
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RadioListTile Demo',
      home: const RadioListTileDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RadioListTileDemo extends StatefulWidget {
  const RadioListTileDemo({super.key});

  @override
  State<RadioListTileDemo> createState() => _RadioListTileDemoState();
}

class _RadioListTileDemoState extends State<RadioListTileDemo> {
  String? selectedValue = "Android";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RadioListTile Demo"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildRadioTile("Android", Colors.purple),
          buildRadioTile("IOS", Colors.green),
          buildRadioTile("Flutter", Colors.green),
        ],
      ),
    );
  }

  Widget buildRadioTile(String value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selectedValue == value ? color : Colors.green,
        borderRadius: BorderRadius.circular(16),
      ),
      child: RadioListTile(
        title: Text(
          value,
          style: TextStyle(
            fontWeight:
                selectedValue == value ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        value: value,
        groupValue: selectedValue,
        activeColor: Colors.white,
        onChanged: (val) {
          setState(() {
            selectedValue = val.toString();
          });
        },
      ),
    );
  }
}
