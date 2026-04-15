import 'package:flutter/material.dart';
import '../services/api/addtransaction.dart';

class Addoption extends StatelessWidget {
  Addoption({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String type = "";
  String category = "";

  // category ID → name
  final Map<String, String> categories = {
    "1": "Food",
    "2": "Transport",
    "3": "Shopping",
    "4": "Salary",
    "5": "Bonus",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          'ADD TRANSACTION',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TITLE
            TextField(
              controller: _titleController,
              decoration: _inputStyle("Title"),
            ),

            const SizedBox(height: 16),

            // AMOUNT
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: _inputStyle("Amount"),
            ),

            const SizedBox(height: 16),

            // TYPE
            DropdownButtonFormField<String>(
              decoration: _inputStyle("Type"),
              items: ["Income", "Expense"].map((t) {
                return DropdownMenuItem(
                  value: t,
                  child: Text(t, style: const TextStyle(color: Colors.blue)),
                );
              }).toList(),
              onChanged: (value) => type = value!,
            ),

            const SizedBox(height: 16),

            // CATEGORY (FIXED → sends ID)
            DropdownButtonFormField<String>(
              decoration: _inputStyle("Category"),
              items: categories.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key, // ID
                  child: Text(
                    entry.value,
                    style: const TextStyle(color: Colors.blue),
                  ),
                );
              }).toList(),
              onChanged: (value) => category = value!,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final title = _titleController.text;
                final amount = _amountController.text;

                // VALIDATION
                if (title.isEmpty || amount.isEmpty) {
                  _show(context, "Fill all fields", Colors.red);
                  return;
                }

                if (type.isEmpty || category.isEmpty) {
                  _show(context, "Select type & category", Colors.red);
                  return;
                }

                try {
                  final status = await addTransaction(
                    title,
                    amount,
                    type,
                    category,
                  );

                  if (status == "success") {
                    _show(context, "Transaction added", Colors.green);
                  } else {
                    _show(context, "Failed", Colors.red);
                  }
                } catch (e) {
                  _show(context, e.toString(), Colors.red);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                "Add Transaction",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // reusable UI
  InputDecoration _inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.blue),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.blue),
      ),
    );
  }

  void _show(BuildContext context, String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }
}
