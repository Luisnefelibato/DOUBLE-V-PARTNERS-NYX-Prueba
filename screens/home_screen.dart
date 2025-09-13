
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';
import '../widgets/cyberpunk_widgets.dart';
import '../theme/cyberpunk_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _particleController;
  int _selectedIndex = 0;
  int _totalUsers = 0;

  final List<_MenuItem> _menuItems = [
    _MenuItem(
      icon: Icons.person_add,
      title: 'Crear Usuario',
      subtitle: 'Agregar nuevo usuario',
      route: '/user-form',
      color: CyberpunkColors.primary,
    ),
    _MenuItem(
      icon: Icons.people,
      title: 'Ver Usuarios',
      subtitle: 'Lista de usuarios registrados',
      route: '/user-list',
      color: CyberpunkColors.secondary,
    ),
    _MenuItem(
      icon: Icons.location_on,
      title: 'Direcciones',
      subtitle: 'Gestionar direcciones',
      route: '/address-management',
      color: CyberpunkColors.accent,
    ),
    _MenuItem(
      icon: Icons.account_circle,
      title: 'Perfil',
      subtitle: 'Ver perfil de usuario',
      route: '/profile',
      color: CyberpunkColors.secondary,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animationController.forward();
    _particleController.repeat();
    _loadUserCount();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCount() async {
    try {
      final users = await StorageService.instance.getAllUsers();
      setState(() {
        _totalUsers = users.length;
      });
    } catch (e) {
      setState(() {
        _totalUsers = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: CyberpunkColors.backgroundGradient,
        ),
        child: Stack(
          children: [
            _buildParticleBackground(),
            _buildMainContent(),
            _buildFloatingActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ParticlePainter(_particleController),
      ),
    );
  }

  Widget _buildMainContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildStatsCard(),
            const SizedBox(height: 32),
            _buildMenuGrid(),
            const SizedBox(height: 32),
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: CyberpunkColors.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: CyberpunkColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch,
                color: Colors.white,
                size: 24,
              ),
            ).animate()
                .scale(delay: 300.ms, duration: 600.ms)
                .shimmer(delay: 900.ms, duration: 1000.ms),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Double V Partners',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = CyberpunkColors.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 200, 50),
                        ),
                    ),
                  ).animate()
                      .slideX(delay: 200.ms, duration: 800.ms)
                      .fadeIn(delay: 200.ms, duration: 800.ms),
                  Text(
                    'NYX User Management',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CyberpunkColors.textSecondary,
                    ),
                  ).animate()
                      .slideX(delay: 400.ms, duration: 800.ms)
                      .fadeIn(delay: 400.ms, duration: 800.ms),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                // Settings action
              },
              icon: const Icon(
                Icons.settings,
                color: CyberpunkColors.textSecondary,
              ),
            ).animate()
                .scale(delay: 600.ms, duration: 600.ms),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Usuarios Registrados',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: CyberpunkColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _totalUsers.toString(),
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = CyberpunkColors.primaryGradient.createShader(
                          const Rect.fromLTWH(0, 0, 100, 50),
                        ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: CyberpunkColors.secondaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.people,
                color: Colors.white,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    ).animate()
        .slideY(delay: 500.ms, duration: 800.ms)
        .fadeIn(delay: 500.ms, duration: 800.ms);
  }

  Widget _buildMenuGrid() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.0,
        ),
        itemCount: _menuItems.length,
        itemBuilder: (context, index) {
          final item = _menuItems[index];
          return _buildMenuItem(item, index);
        },
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item, int index) {
    return CyberpunkCard(
      onTap: () {
        Navigator.pushNamed(context, item.route);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: item.color.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                item.icon,
                color: item.color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: CyberpunkColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              item.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CyberpunkColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate()
        .slideY(delay: Duration(milliseconds: 700 + (index * 100)), duration: 600.ms)
        .fadeIn(delay: Duration(milliseconds: 700 + (index * 100)), duration: 600.ms);
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: CyberpunkButton(
            text: 'Crear Usuario Rápido',
            onPressed: () {
              Navigator.pushNamed(context, '/user-form');
            },
            icon: Icons.add,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CyberpunkButton(
            text: 'Ver Todos',
            onPressed: () {
              Navigator.pushNamed(context, '/user-list');
            },
            variant: CyberpunkButtonVariant.outline,
            icon: Icons.list,
          ),
        ),
      ],
    ).animate()
        .slideY(delay: 1200.ms, duration: 600.ms)
        .fadeIn(delay: 1200.ms, duration: 600.ms);
  }

  Widget _buildFloatingActionButton() {
    return Positioned(
      bottom: 24,
      right: 24,
      child: FloatingActionButton(
        onPressed: () {
          _loadUserCount();
        },
        backgroundColor: CyberpunkColors.primary,
        child: const Icon(
          Icons.refresh,
          color: Colors.white,
        ),
      ).animate()
          .scale(delay: 1500.ms, duration: 600.ms)
          .shimmer(delay: 2000.ms, duration: 1000.ms),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
}

class _ParticlePainter extends CustomPainter {
  final AnimationController controller;

  _ParticlePainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberpunkColors.primary.withOpacity(0.1)
      ..strokeWidth = 1;

    for (int i = 0; i < 20; i++) {
      final x = (i * 50 + controller.value * 100) % size.width;
      final y = (i * 30 + controller.value * 50) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
