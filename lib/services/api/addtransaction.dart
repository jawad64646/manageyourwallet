import 'dart:convert';
import 'package:http/http.dart' as http;

final baseUrl = "https://managewallet.atwebpages.com";
final endpoint = "/addtran.php";

Future<String> addTransaction(
  String title,
  String amount,
  String type,
  String categoryId,
) async {
  final url = Uri.parse("$baseUrl$endpoint");

  try {
    final response = await http.post(
      url,

      body: {
        "title": title,
        "amount": amount,
        "type": type,
        "category_id": categoryId,
      },
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("HTTP Error: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      return data['status'];
    } else {
      throw Exception(data['message'] ?? "Unknown error");
    }
  } catch (e) {
    throw Exception("Request failed: $e");
  }
}
