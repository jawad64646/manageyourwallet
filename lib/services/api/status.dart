import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchStatus() async {
  final baseUrl = "https://managewallet.atwebpages.com";
  final String endpoint = "/status.php";

  final url = Uri.parse("$baseUrl$endpoint");

  try {
    final response = await http.get(url).timeout(const Duration(seconds: 10));

    debugPrint("STATUS CODE: ${response.statusCode}");
    debugPrint("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("HTTP Error: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    if (data is Map && data['status'] == 'success') {
      return Map<String, dynamic>.from(data['summary'] ?? {});
    }

    throw Exception(data['message'] ?? 'Server returned an error');
  } catch (e) {
    throw Exception('Connection failed: $e');
  }
}
