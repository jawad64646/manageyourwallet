
import 'package:flutter/material.dart';


/// ================= STATUS ITEM =================
Widget buildStatusItem(String title, dynamic value, Color color) {
  return Column(
    children: [
      Text(
        title,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
      const SizedBox(height: 5),
      Text(
        '$value',
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
