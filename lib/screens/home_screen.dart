import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/grocery_item.dart';
import '../services/data_service.dart';
import '../services/notification_service.dart';
import '../widgets/grocery_item_card.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/sort_options_modal.dart';
import '../widgets/category_filter_modal.dart';
import '../widgets/theme_toggle_slider.dart';
import '../services/theme_service.dart';
import 'add_item_screen.dart';
import 'expired_items_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<GroceryItem> _items = [];
  List<GroceryItem> _selectedItems = [];
  bool _isLoading = true;
  bool _isSelectionMode = false;
  late AnimationController _sliderController;
  int _currentPageIndex = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _sliderController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadItems();
  }

  @override
  void dispose() {
    _sliderController.dispose();
    super.dispose();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final items = await DataService.instance.getSortedItemsByCategory(_selectedCategory);
    // Debug
    // ignore: avoid_print
    print('[HomeScreen] _loadItems: selectedCategory=$_selectedCategory loaded=${items.length}');
    setState(() {
      _items = items;
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
    
    // Cancel notifications for deleted items
    for (final item in _selectedItems) {
      await NotificationService.cancelNotification(item.id);
    }
    
    _selectedItems.clear();
    _toggleSelectionMode();
    _loadItems();
  }

  void _navigateToPage(int index) {
    // Handle add button (index 2) - always allow clicking
    if (index == 2) {
      _navigateToAddItem();
      return;
    }
    
    if (index == _currentPageIndex) return;
    
    setState(() {
      _currentPageIndex = index;
    });
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return _buildHomePage();
      case 1:
        return const ExpiredItemsScreen();
      case 2:
        return _buildHomePage(); // Add button should stay on home page
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Remove stops or set correct length for both gradients
            colors: ThemeService.instance.gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
            // Header with title and controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Column(
                children: [
                  // Top row with title and theme toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Freshly',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: ThemeService.instance.isDarkMode 
                              ? Colors.white 
                              : const Color(0xFF1F2937),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const ThemeToggleSlider(),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bottom row with controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Delete button (only when items are selected)
                      if (_isSelectionMode && _selectedItems.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.4),
                              width: 1,
                            ),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: _deleteSelectedItems,
                          ),
                        )
                      else
                        const SizedBox(width: 48), // Placeholder for alignment
                      
                      // Filter and Sort buttons
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Filter button
                          GestureDetector(
                            onTap: _filterByCategory,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.filter_list,
                                    size: 20,
                                    color: ThemeService.instance.isDarkMode 
                                        ? Colors.white 
                                        : const Color(0xFF8B5CF6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _selectedCategory == 'All' ? 'Filter' : _selectedCategory,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeService.instance.isDarkMode 
                                          ? Colors.white 
                                          : const Color(0xFF8B5CF6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Sort button
                          GestureDetector(
                            onTap: _sortItems,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.25),
                                    Colors.white.withOpacity(0.15),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.sort_rounded,
                                    color: ThemeService.instance.isDarkMode 
                                        ? Colors.white 
                                        : const Color(0xFF8B5CF6),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Sort',
                                    style: TextStyle(
                                      color: ThemeService.instance.isDarkMode 
                                          ? Colors.white 
                                          : const Color(0xFF8B5CF6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                      : _items.isEmpty
                          ? _buildEmptyState()
                          : _buildItemsList(),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            ],
          ),
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
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No grocery items yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the + button to add your first item',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
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

  void _sortItems() {
    showDialog(
      context: context,
      builder: (context) => SortOptionsModal(
        onSortSelected: (sortType) {
          setState(() {
            switch (sortType) {
              case 'expiry':
                _items.sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
                break;
              case 'name':
                _items.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
                break;
              case 'date_added':
                _items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                break;
            }
          });
        },
      ),
    );
  }

  void _filterByCategory() {
    showDialog<String>(
      context: context,
      builder: (context) => CategoryFilterModal(
        selectedCategory: _selectedCategory,
        onCategorySelected: (category) {
          Navigator.pop(context, category);
        },
      ),
    ).then((selected) {
      if (selected != null && selected is String) {
        setState(() {
          _selectedCategory = selected;
        });
        _loadItems();
      }
    });
  }


  void _navigateToAddItem() async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AddItemScreen(),
    );
    
    // Debug
    // ignore: avoid_print
    print('[HomeScreen] _navigateToAddItem: dialog result=$result');

    if (result == true) {
      _loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ThemeService.instance.gradientColors,
          ),
        ),
        child: _buildPage(_currentPageIndex),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _currentPageIndex,
        onTap: _navigateToPage,
        sliderController: _sliderController,
      ),
    );
  }
}
