import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class SortOptionsModal extends StatelessWidget {
  final Function(String) onSortSelected;

  const SortOptionsModal({
    super.key,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      const Color(0xFF6D28D9).withOpacity(0.9),
                      const Color(0xFF5B21B6).withOpacity(0.8),
                      const Color(0xFF4C1D95).withOpacity(0.7),
                    ]
                  : [
                      const Color(0xFF8B5CF6).withOpacity(0.9),
                      const Color(0xFF7C3AED).withOpacity(0.8),
                      const Color(0xFF6D28D9).withOpacity(0.7),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 25,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                
                _buildSortOption(
                  context,
                  'Expiry Date',
                  'Sort by expiry date (closest first)',
                  Icons.schedule_rounded,
                  'expiry',
                ),
                const SizedBox(height: 12),
                
                _buildSortOption(
                  context,
                  'Name',
                  'Sort alphabetically by name',
                  Icons.sort_by_alpha_rounded,
                  'name',
                ),
                const SizedBox(height: 12),
                
                _buildSortOption(
                  context,
                  'Date Added',
                  'Sort by when item was added',
                  Icons.add_circle_outline_rounded,
                  'date_added',
                ),
                const SizedBox(height: 20),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      size: 24,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9),
                      foregroundColor: isDark ? Colors.white70 : const Color(0xFF64748B),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    String sortType,
  ) {
    return GestureDetector(
      onTap: () {
        onSortSelected(sortType);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF3B82F6),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF94A3B8),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
