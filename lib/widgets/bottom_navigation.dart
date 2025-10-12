import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final AnimationController sliderController;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.sliderController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF8B5CF6), // Purple
            Color(0xFFF3E8FF), // Light purple
          ],
        ),
      ),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30), // Pill shape
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildNavButton(
                  icon: Icons.home_rounded,
                  label: '',
                  index: 0,
                  isActive: currentIndex == 0,
                ),
              ),
              Expanded(
                child: _buildNavButton(
                  icon: Icons.warning_rounded,
                  label: '',
                  index: 1,
                  isActive: currentIndex == 1,
                ),
              ),
              Expanded(
                child: _buildNavButton(
                  icon: Icons.add_rounded,
                  label: '',
                  index: 2,
                  isActive: currentIndex == 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    Color iconColor;
    if (index == 0) {
      iconColor = ThemeService.instance.isDarkMode 
          ? Colors.white 
          : const Color(0xFF8B5CF6); // Purple for home
    } else if (index == 1) {
      iconColor = ThemeService.instance.isDarkMode 
          ? Colors.white.withOpacity(0.8)
          : const Color(0xFF8B5CF6); // Purple for warning
    } else {
      iconColor = ThemeService.instance.isDarkMode 
          ? Colors.white.withOpacity(0.6)
          : const Color(0xFF8B5CF6); // Purple for add
    }

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 60,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFE2E8F0) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
