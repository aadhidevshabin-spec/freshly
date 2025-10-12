class GroceryItem {
  final String id;
  final String name;
  final DateTime expiryDate;
  final DateTime createdAt;
  final String category;
  bool isSelected;

  GroceryItem({
    required this.id,
    required this.name,
    required this.expiryDate,
    required this.createdAt,
    this.category = 'None',
    this.isSelected = false,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'expiryDate': expiryDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'category': category,
      'isSelected': isSelected,
    };
  }

  // Create from JSON
  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'],
      name: json['name'],
      expiryDate: DateTime.parse(json['expiryDate']),
      createdAt: DateTime.parse(json['createdAt']),
      category: json['category'] ?? 'None',
      isSelected: json['isSelected'] ?? false,
    );
  }

  // Calculate days until expiry
  int get daysUntilExpiry {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    return difference;
  }

  // Check if item is expired
  bool get isExpired {
    return daysUntilExpiry < 0;
  }

  // Get color based on expiry status
  String get colorStatus {
    if (isExpired) return 'red';
    if (daysUntilExpiry <= 10) return 'red';
    if (daysUntilExpiry <= 30) return 'yellow';
    if (daysUntilExpiry <= 90) return 'green';
    return 'blue';
  }

  // Copy with method for updates
  GroceryItem copyWith({
    String? id,
    String? name,
    DateTime? expiryDate,
    DateTime? createdAt,
    String? category,
    bool? isSelected,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      expiryDate: expiryDate ?? this.expiryDate,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
