import 'package:flutter/material.dart';
import '../services/theme_service.dart';

class ThemeToggleSlider extends StatefulWidget {
  const ThemeToggleSlider({super.key});

  @override
  State<ThemeToggleSlider> createState() => _ThemeToggleSliderState();
}

class _ThemeToggleSliderState extends State<ThemeToggleSlider>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Set initial position based on current theme
    if (ThemeService.instance.isDarkMode) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleTheme() async {
    if (_animationController.isCompleted) {
      await _animationController.reverse();
      await ThemeService.instance.setDarkMode(false);
    } else {
      await _animationController.forward();
      await ThemeService.instance.setDarkMode(true);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    
    return GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark 
                ? [const Color(0xFF1A1A1A), const Color(0xFF2A2A2A)]
                : [const Color(0xFFF8FAFC), const Color(0xFFE5E7EB)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark 
                ? Colors.white.withOpacity(0.2)
                : const Color(0xFF8B5CF6).withOpacity(0.3),
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
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                // Background icons
                Positioned(
                  left: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.light_mode,
                      color: isDark 
                          ? Colors.white.withOpacity(0.5)
                          : const Color(0xFF8B5CF6).withOpacity(0.7),
                      size: 18,
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Icon(
                      Icons.dark_mode,
                      color: isDark 
                          ? Colors.white.withOpacity(0.5)
                          : const Color(0xFF8B5CF6).withOpacity(0.7),
                      size: 18,
                    ),
                  ),
                ),
                
                // Sliding button
                Positioned(
                  left: 2 + (_animation.value * 36),
                  top: 2,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]
                            : [Colors.white, const Color(0xFFF8FAFC)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _animation.value > 0.5 ? Icons.dark_mode : Icons.light_mode,
                          key: ValueKey(_animation.value > 0.5),
                          color: isDark ? Colors.white : const Color(0xFF8B5CF6),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

