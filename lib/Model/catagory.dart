class CategorySummary {
  final String category;
  final double total;
  final String color;

  CategorySummary({
    required this.category,
    required this.total,
    required this.color,
  });

  factory CategorySummary.fromJson(Map<String, dynamic> json) {
    return CategorySummary(
      category: json['category'],
      total: (json['total'] as num).toDouble(),
      color: json['color'],
    );
  }
}