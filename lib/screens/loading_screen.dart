import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/theme_service.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate loading time
    await Future.delayed(const Duration(seconds: 3));
    
    // Load theme
    await ThemeService.instance.loadTheme();
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeService.instance.isDarkMode;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: ThemeService.instance.gradientColors,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Freshly Text with Gradient
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: isDark
                      ? [Colors.white, Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.6)]
                      : [const Color(0xFF8B5CF6), const Color(0xFF7C3AED), const Color(0xFF6D28D9)],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds),
                child: const Text(
                  'Freshly',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 1000.ms)
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.0, 1.0))
                  .then(delay: 500.ms)
                  .custom(
                    builder: (context, value, child) => Transform.scale(
                      scale: 1 + _pulseController.value * 0.05,
                      child: child,
                    ),
                  ),

              const SizedBox(height: 20),

              // Loading dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isDark 
                          ? Colors.white.withOpacity(0.7)
                          : const Color(0xFF8B5CF6).withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: 1500 + index * 200))
                      .then()
                      .custom(
                        builder: (context, value, child) => Transform.scale(
                          scale: 1 + _pulseController.value * 0.3,
                          child: child,
                        ),
                      );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

