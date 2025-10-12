import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/grocery_item.dart';
import '../services/data_service.dart';
import '../widgets/grocery_item_card.dart';
import '../widgets/sort_options_modal.dart';

class ExpiredItemsScreen extends StatefulWidget {
  const ExpiredItemsScreen({super.key});

  @override
  State<ExpiredItemsScreen> createState() => _ExpiredItemsScreenState();
}

class _ExpiredItemsScreenState extends State<ExpiredItemsScreen> {
  List<GroceryItem> _expiredItems = [];
  List<GroceryItem> _selectedItems = [];
  bool _isLoading = true;
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadExpiredItems();
  }

  Future<void> _loadExpiredItems() async {
    setState(() => _isLoading = true);
    final items = await DataService.instance.getExpiredItems();
    setState(() {
      _expiredItems = items;
      _isLoading = false;
    });
  }

  void _toggleSelection(GroceryItem item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
      }
    });
  }

  Future<void> _deleteSelectedItems() async {
    if (_selectedItems.isEmpty) return;

    final itemIds = _selectedItems.map((item) => item.id).toList();
    await DataService.instance.deleteSelectedItems(itemIds);
    
    _selectedItems.clear();
    _toggleSelectionMode();
    _loadExpiredItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
          // Header with title and sort button
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expired Items',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A), // Dark slate
                    letterSpacing: -0.5,
                  ),
                ),
                if (_expiredItems.isNotEmpty) ...[
                  if (_isSelectionMode && _selectedItems.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: _deleteSelectedItems,
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => SortOptionsModal(
                          onSortSelected: (sortType) {
                            setState(() {
                              switch (sortType) {
                                case 'expiry':
                                  _expiredItems.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
                                  break;
                                case 'name':
                                  _expiredItems.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                                  break;
                                case 'date_added':
                                  _expiredItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                                  break;
                              }
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.sort_rounded,
                            color: Color(0xFF475569),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Sort',
                            style: TextStyle(
                              color: Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Main content area
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _expiredItems.isEmpty
                        ? _buildEmptyState()
                        : _buildExpiredItemsList(),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 100,
            color: Colors.green[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No expired items',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'All your items are still fresh!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpiredItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _expiredItems.length,
      itemBuilder: (context, index) {
        final item = _expiredItems[index];
        return GroceryItemCard(
          item: item,
          isSelected: _selectedItems.contains(item),
          isSelectionMode: _isSelectionMode,
          onTap: () => _isSelectionMode ? _toggleSelection(item) : null,
          onLongPress: () {
            if (!_isSelectionMode) {
              _toggleSelectionMode();
              _toggleSelection(item);
            }
          },
        ).animate().fadeIn(delay: Duration(milliseconds: index * 100));
      },
    );
  }
}
