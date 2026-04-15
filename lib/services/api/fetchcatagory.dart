import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Model/catagory.dart';

Future<List<CategorySummary>> fetchCategorySummary() async {
  final baseUrl = "https://managewallet.atwebpages.com";
  final url = Uri.parse("$baseUrl/category.php");

  try {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("HTTP Error: ${response.statusCode}");
    }

    final jsonData = json.decode(response.body);

    if (jsonData["status"] == "success") {
      final List data = jsonData["data"];

      return data.map((item) => CategorySummary.fromJson(item)).toList();
    } else {
      throw Exception(jsonData["message"] ?? "API Error");
    }
  } catch (e) {
    throw Exception("Network error: $e");
  }
}
