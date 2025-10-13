import 'package:flutter/material.dart';

class StepThreeForm extends StatefulWidget {
  final VoidCallback onBack;

  const StepThreeForm({super.key, required this.onBack});

  @override
  State<StepThreeForm> createState() => _StepThreeFormState();
}

class _StepThreeFormState extends State<StepThreeForm> {
  final TextEditingController facultyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Step 3", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(controller: facultyCtrl, decoration: InputDecoration(labelText: "Faculty")),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(onPressed: widget.onBack, child: const Text("Back")),
              ElevatedButton(
                onPressed: () {
                  // TODO: submit data ke server
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Form submitted!")),
                  );
                },
                child: const Text("Submit"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
