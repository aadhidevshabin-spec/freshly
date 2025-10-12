import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grocery_item.dart';

class DataService {
  static const String _itemsKey = 'grocery_items';
  static DataService? _instance;
  static DataService get instance => _instance ??= DataService._();
  
  DataService._();

  // Save items to local storage
  Future<void> saveItems(List<GroceryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final itemsJson = items.map((item) => item.toJson()).toList();
    await prefs.setString(_itemsKey, jsonEncode(itemsJson));
    // Debug log
    // ignore: avoid_print
    print('[DataService] saveItems: saved ${items.length} items');
  }

  // Load items from local storage
  Future<List<GroceryItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final itemsString = prefs.getString(_itemsKey);
    
    if (itemsString == null) return [];
    
    try {
      final List<dynamic> itemsJson = jsonDecode(itemsString);
      final items = itemsJson.map((json) => GroceryItem.fromJson(json)).toList();
      // Debug log
      // ignore: avoid_print
      print('[DataService] loadItems: loaded ${items.length} items');
      return items;
    } catch (e) {
      // ignore: avoid_print
      print('[DataService] loadItems: error parsing items: $e');
      return [];
    }
  }

  // Add new item
  Future<void> addItem(GroceryItem item) async {
    final items = await loadItems();
    items.add(item);
    await saveItems(items);
    // Debug log
    // ignore: avoid_print
    print('[DataService] addItem: item added id=${item.id} name=${item.name} total=${items.length}');
  }

  // Delete item
  Future<void> deleteItem(String itemId) async {
    final items = await loadItems();
    items.removeWhere((item) => item.id == itemId);
    await saveItems(items);
  }

  // Delete multiple items
  Future<void> deleteSelectedItems(List<String> itemIds) async {
    final items = await loadItems();
    items.removeWhere((item) => itemIds.contains(item.id));
    await saveItems(items);
  }

  // Update item
  Future<void> updateItem(GroceryItem updatedItem) async {
    final items = await loadItems();
    final index = items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      items[index] = updatedItem;
      await saveItems(items);
    }
  }

  // Get expired items
  Future<List<GroceryItem>> getExpiredItems() async {
    final items = await loadItems();
    return items.where((item) => item.isExpired).toList();
  }

  // Get items sorted by expiry date (closest first)
  Future<List<GroceryItem>> getSortedItems() async {
    final items = await loadItems();
    items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return items;
  }

  // Get items filtered by category
  Future<List<GroceryItem>> getItemsByCategory(String category) async {
    final items = await loadItems();
    if (category == 'All') return items;
    return items.where((item) => item.category == category).toList();
  }

  // Get items filtered by category and sorted by expiry date
  Future<List<GroceryItem>> getSortedItemsByCategory(String category) async {
    final items = await getItemsByCategory(category);
    items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
    return items;
  }

  // Clear all items
  Future<void> clearAllItems() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_itemsKey);
  }
}
