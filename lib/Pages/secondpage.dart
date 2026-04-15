import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../Model/catagory.dart';
import '../Model/transaction.dart';
import '../services/api/fetchcatagory.dart';
import '../services/api/status.dart';
import 'package:wallet1/services/api/Alltransactions.dart';
import '../widgets/buildStatus.dart';

class Spage extends StatefulWidget {
  const Spage({super.key});

  @override
  State<Spage> createState() => _SpageState();
}

class _SpageState extends State<Spage> {
  int touchedIndex = -1;

  late Future<List<CategorySummary>> _categoryFuture;
  late Future<Map<String, dynamic>> _statusFuture;
  late Future<List<Transaction>> _transactionFuture;

  @override
  void initState() {
    super.initState();
    _categoryFuture = fetchCategorySummary();
    _statusFuture = fetchStatus();
    // 1 --> latest 4 transactions
    // 0 --> all transactions
    _transactionFuture = TransactionService().fetchTransactions(limitType: 1);
  }

  @override
  Widget build(BuildContext context) {
    const bgColor = Color(0xFFF5F7FB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: Colors.white),
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text(
          'HOME',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// ================= PIE CHART =================
              FutureBuilder<List<CategorySummary>>(
                future: _categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Error loading chart');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No Data');
                  }

                  final data = snapshot.data!;

                  return SizedBox(
                    height: 250,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!
                                  .touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: _buildSections(data),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// ================= STATUS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _statusFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData) {
                      return const Text('No Data');
                    }

                    final data = snapshot.data!;

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildStatusItem(
                            'Balance',
                            data['balance'],
                            Colors.blue,
                          ),
                          buildStatusItem(
                            'Income',
                            data['total_income'],
                            Colors.green,
                          ),
                          buildStatusItem(
                            'Expense',
                            data['total_expense'],
                            Colors.red,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              /// ================= TRANSACTIONS =================
              FutureBuilder<List<Transaction>>(
                future: _transactionFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Error loading data');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No transactions yet');
                  }

                  final transactions = snapshot.data!;

                  return Column(
                    children: transactions.map((transaction) {
                      final isIncome = transaction.type == 'income';

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? Colors.green.shade100
                                : Colors.red.shade100,
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(
                            transaction.title ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${transaction.amount}',
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                          trailing: Text(
                            transaction.type ?? '',
                            style: TextStyle(
                              color: isIncome ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(List<CategorySummary> data) {
    final total = data.fold<double>(
      0,
      (sum, item) => sum + (double.tryParse(item.total.toString()) ?? 0),
    );

    return List.generate(data.length, (i) {
      final item = data[i];
      final isTouched = i == touchedIndex;

      final rawValue = double.tryParse(item.total.toString()) ?? 0;

      final double percentage = total == 0 ? 0 : (rawValue / total) * 100;

      final double displayValue = percentage < 5 ? 5 : percentage;

      final radius = isTouched ? 60.0 : 50.0;
      final fontSize = isTouched ? 16.0 : 11.0;

      final color = _parseColor(item.color);

      return PieChartSectionData(
        color: color,
        value: displayValue,

        title: '${percentage.toStringAsFixed(0)}%',
        badgeWidget: Text(
          item.category,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(int.parse(item.color.replaceFirst('#', '0xff'))),
          ),
        ),

        // Outside the circle (pie chart)
        // 1.5 --> transport --> outside circle
        badgePositionPercentageOffset: item.category == "Transport" ? 1.5 : 1.3,

        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  /// ================= COLOR PARSER =================
  Color _parseColor(String? color) {
    try {
      if (color == null || color.isEmpty) return Colors.grey;
      return Color(int.parse(color.replaceFirst('#', '0xff')));
    } catch (_) {
      return Colors.grey;
    }
  }
}
