import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/cyberpunk_widgets.dart';
import 'home_screen.dart';

/// Pantalla de inicio con animaciones cyberpunk
/// Muestra el logo de Double V Partners NYX con efectos visuales
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _glowController;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _startAnimation();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _startAnimation() async {
    // Iniciar animaciones secuencialmente
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    _glowController.repeat(reverse: true);

    // Navegar a la pantalla principal después de 4 segundos
    await Future.delayed(const Duration(milliseconds: 4000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.darkBackground,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              Color(0xFF1A1B3A), // Azul oscuro en el centro
              CyberpunkColors.darkBackground, // Negro en los bordes
            ],
          ),
        ),
        child: Stack(
          children: [
            // Partículas de fondo animadas
            ...List.generate(20, (index) => _buildFloatingParticle(index)),

            // Contenido principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de Double V Partners NYX
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoController.value,
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: CyberpunkColors.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: CyberpunkColors.glowMagenta.withOpacity(
                                  0.3 + (0.4 * _glowController.value),
                                ),
                                blurRadius: 30 + (20 * _glowController.value),
                                spreadRadius: 5 + (10 * _glowController.value),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Fondo del logo
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: CyberpunkColors.darkBackground,
                                  ),
                                ),
                                // Letra "V" estilizada
                                Text(
                                  'V',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: CyberpunkColors.textPrimary,
                                    fontFamily: 'Orbitron',
                                    shadows: [
                                      Shadow(
                                        color: CyberpunkColors.glowPurple.withOpacity(0.8),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                // Elementos decorativos
                                ...List.generate(4, (index) {
                                  final angle = (index * 90) * (3.14159 / 180);
                                  return Transform.rotate(
                                    angle: angle + (_glowController.value * 2 * 3.14159),
                                    child: Container(
                                      width: 160,
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.transparent,
                                            CyberpunkColors.primaryMagenta.withOpacity(0.8),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Texto del nombre de la empresa
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textController.value,
                        child: Transform.translateY(
                          offset: (1 - _textController.value) * 30,
                          child: Column(
                            children: [
                              Text(
                                'DOUBLE V PARTNERS',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: CyberpunkColors.textPrimary,
                                  fontFamily: 'Orbitron',
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      color: CyberpunkColors.glowPurple.withOpacity(0.6),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ShaderMask(
                                shaderCallback: (bounds) => CyberpunkColors.primaryGradient
                                    .createShader(bounds),
                                child: const Text(
                                  'NYX',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Orbitron',
                                    letterSpacing: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Unconventional People. Disruptive Tech.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CyberpunkColors.textSecondary,
                                  fontFamily: 'Orbitron',
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 60),

                  // Indicador de carga
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textController.value,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  CyberpunkColors.primaryMagenta.withOpacity(0.8),
                                ),
                              ),
                            )
                                .animate(onPlay: (controller) => controller.repeat())
                                .rotate(duration: 2000.ms),
                            const SizedBox(height: 16),
                            const Text(
                              'Inicializando sistema...',
                              style: TextStyle(
                                fontSize: 12,
                                color: CyberpunkColors.textMuted,
                                fontFamily: 'Orbitron',
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Líneas de conexión animadas en las esquinas
            ..._buildCornerLines(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = (index * 1234) % 1000;
    final delay = (random % 3000).toDouble();
    final duration = 3000 + (random % 2000);

    return Positioned(
      left: (random % 300).toDouble(),
      top: ((random * 2) % 600).toDouble(),
      child: Container(
        width: 2 + (random % 4),
        height: 2 + (random % 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: CyberpunkColors.primaryMagenta.withOpacity(0.3),
          boxShadow: [
            BoxShadow(
              color: CyberpunkColors.glowMagenta.withOpacity(0.5),
              blurRadius: 4,
            ),
          ],
        ),
      )
          .animate(onPlay: (controller) => controller.repeat())
          .fadeIn(delay: delay.ms, duration: 1000.ms)
          .fadeOut(delay: (delay + duration).ms, duration: 1000.ms)
          .moveY(
            begin: -10,
            end: 20,
            duration: duration.ms,
            curve: Curves.easeInOut,
          ),
    );
  }

  List<Widget> _buildCornerLines() {
    return [
      // Esquina superior izquierda
      Positioned(
        top: 40,
        left: 40,
        child: _buildCornerLine()
            .animate()
            .fadeIn(delay: 1000.ms, duration: 800.ms)
            .slideX(begin: -0.5, duration: 800.ms),
      ),

      // Esquina superior derecha
      Positioned(
        top: 40,
        right: 40,
        child: Transform.rotate(
          angle: 3.14159 / 2,
          child: _buildCornerLine()
              .animate()
              .fadeIn(delay: 1200.ms, duration: 800.ms)
              .slideY(begin: -0.5, duration: 800.ms),
        ),
      ),

      // Esquina inferior izquierda
      Positioned(
        bottom: 40,
        left: 40,
        child: Transform.rotate(
          angle: -3.14159 / 2,
          child: _buildCornerLine()
              .animate()
              .fadeIn(delay: 1400.ms, duration: 800.ms)
              .slideY(begin: 0.5, duration: 800.ms),
        ),
      ),

      // Esquina inferior derecha
      Positioned(
        bottom: 40,
        right: 40,
        child: Transform.rotate(
          angle: 3.14159,
          child: _buildCornerLine()
              .animate()
              .fadeIn(delay: 1600.ms, duration: 800.ms)
              .slideX(begin: 0.5, duration: 800.ms),
        ),
      ),
    ];
  }

  Widget _buildCornerLine() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CyberpunkColors.primaryMagenta.withOpacity(0.8),
            width: 2,
          ),
          left: BorderSide(
            color: CyberpunkColors.primaryMagenta.withOpacity(0.8),
            width: 2,
          ),
        ),
      ),
    );
  }
}
