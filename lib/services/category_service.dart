class CategoryService {
  static const List<String> categories = [
    'None',
    'Fruits',
    'Vegetables',
    'Dairy',
    'Meat & Poultry',
    'Frozen Food',
    'Daily Use',
    'Beverages',
    'Snacks',
    'Bakery',
    'Canned Goods',
    'Spices & Condiments',
    'Grains & Cereals',
    'Seafood',
    'Organic',
    'Other',
  ];

  static const Map<String, String> categoryIcons = {
    'None': '📦',
    'Fruits': '🍎',
    'Vegetables': '🥕',
    'Dairy': '🥛',
    'Meat & Poultry': '🍗',
    'Frozen Food': '🧊',
    'Daily Use': '🧴',
    'Beverages': '🥤',
    'Snacks': '🍿',
    'Bakery': '🥖',
    'Canned Goods': '🥫',
    'Spices & Condiments': '🧂',
    'Grains & Cereals': '🌾',
    'Seafood': '🐟',
    'Organic': '🌱',
    'Other': '📦',
  };

  static const Map<String, int> categoryColors = {
    'None': 0xFF64748B,
    'Fruits': 0xFFEF4444,
    'Vegetables': 0xFF22C55E,
    'Dairy': 0xFF3B82F6,
    'Meat & Poultry': 0xFFDC2626,
    'Frozen Food': 0xFF06B6D4,
    'Daily Use': 0xFF8B5CF6,
    'Beverages': 0xFFF59E0B,
    'Snacks': 0xFFEC4899,
    'Bakery': 0xFFD97706,
    'Canned Goods': 0xFF6B7280,
    'Spices & Condiments': 0xFFEF4444,
    'Grains & Cereals': 0xFF84CC16,
    'Seafood': 0xFF0EA5E9,
    'Organic': 0xFF10B981,
    'Other': 0xFF64748B,
  };

  static String getIcon(String category) {
    return categoryIcons[category] ?? '📦';
  }

  static int getColor(String category) {
    return categoryColors[category] ?? 0xFF64748B;
  }
}
