import 'dart:convert';
import 'package:wallet1/Model/transaction.dart';
import 'package:http/http.dart' as http;

// It's better to keep the API logic in a service class or as a static method
class TransactionService {
  final String baseUrl = "https://managewallet.atwebpages.com";
  final String endpoint = "/alltran.php";

  Future<List<Transaction>> fetchTransactions({int limitType = 0}) async {
    final url = Uri.parse("$baseUrl$endpoint?limit_type=$limitType");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);

        if (decodedData['data'] != null) {
          final List<dynamic> dataList = decodedData['data'];
          return dataList.map((item) => Transaction.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }
}
