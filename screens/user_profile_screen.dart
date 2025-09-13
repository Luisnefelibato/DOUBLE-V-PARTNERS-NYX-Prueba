
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../widgets/cyberpunk_widgets.dart';
import '../theme/cyberpunk_theme.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _profileController;
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _profileController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ModalRoute.of(context)?.settings.arguments as User?;
      if (user != null) {
        setState(() {
          _user = user;
        });
        _animationController.forward();
        _profileController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _profileController.dispose();
    super.dispose();
  }

  Future<void> _refreshUser() async {
    if (_user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final users = await StorageService.instance.getAllUsers();
      final updatedUser = users.firstWhere(
        (u) => u.id == _user!.id,
        orElse: () => _user!,
      );

      setState(() {
        _user = updatedUser;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _editUser() {
    Navigator.pushNamed(
      context,
      '/user-form',
      arguments: _user,
    ).then((result) {
      if (result is User) {
        setState(() {
          _user = result;
        });
      }
    });
  }

  void _manageAddresses() {
    Navigator.pushNamed(context, '/address-management').then((_) {
      _refreshUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return _buildErrorState();
    }

    return Scaffold(
      backgroundColor: CyberpunkColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: CyberpunkColors.backgroundGradient,
        ),
        child: Stack(
          children: [
            _buildParticleBackground(),
            _buildContent(),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Scaffold(
      backgroundColor: CyberpunkColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: CyberpunkColors.textPrimary,
          ),
        ),
        title: Text(
          'Error',
          style: TextStyle(
            color: CyberpunkColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: CyberpunkColors.error,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Usuario no encontrado',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: CyberpunkColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            CyberpunkButton(
              text: 'Volver',
              onPressed: () => Navigator.of(context).pop(),
              icon: Icons.arrow_back,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticleBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _ProfileParticlePainter(_profileController),
      ),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildPersonalInfoCard(),
                const SizedBox(height: 20),
                _buildStatsCards(),
                const SizedBox(height: 20),
                _buildAddressesCard(),
                const SizedBox(height: 20),
                _buildActionButtons(),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.arrow_back,
          color: CyberpunkColors.textPrimary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _editUser,
          icon: const Icon(
            Icons.edit,
            color: CyberpunkColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: _refreshUser,
          icon: const Icon(
            Icons.refresh,
            color: CyberpunkColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CyberpunkColors.primary.withOpacity(0.3),
                Colors.transparent,
              ],
            ),
          ),
          child: _buildProfileHeader(),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          _buildProfileAvatar(),
          const SizedBox(height: 16),
          _buildUserInfo(),
        ],
      ),
    ).animate()
        .slideY(delay: 200.ms, duration: 800.ms)
        .fadeIn(delay: 200.ms, duration: 800.ms);
  }

  Widget _buildProfileAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        gradient: CyberpunkColors.primaryGradient,
        borderRadius: BorderRadius.circular(60),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primary.withOpacity(0.5),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          _user!.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ).animate()
        .scale(delay: 400.ms, duration: 600.ms)
        .shimmer(delay: 1000.ms, duration: 1500.ms);
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          _user!.fullName,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CyberpunkColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ).animate()
            .slideY(delay: 600.ms, duration: 600.ms)
            .fadeIn(delay: 600.ms, duration: 600.ms),
        const SizedBox(height: 8),
        Text(
          '${_user!.age} años',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: CyberpunkColors.textSecondary,
          ),
        ).animate()
            .slideY(delay: 700.ms, duration: 600.ms)
            .fadeIn(delay: 700.ms, duration: 600.ms),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: CyberpunkColors.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CyberpunkColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Fecha de nacimiento: ${_formatDate(_user!.birthDate)}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CyberpunkColors.textSecondary,
            ),
          ),
        ).animate()
            .slideY(delay: 800.ms, duration: 600.ms)
            .fadeIn(delay: 800.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildPersonalInfoCard() {
    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: CyberpunkColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Información Personal',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CyberpunkColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInfoRow('Nombre Completo', _user!.fullName),
            _buildInfoRow('Edad', '${_user!.age} años'),
            _buildInfoRow('Fecha de Nacimiento', _formatDate(_user!.birthDate)),
            _buildInfoRow('ID de Usuario', _user!.id),
          ],
        ),
      ),
    ).animate()
        .slideX(delay: 500.ms, duration: 600.ms)
        .fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CyberpunkColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: CyberpunkColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Direcciones',
            _user!.addresses.length.toString(),
            Icons.location_on,
            CyberpunkColors.secondary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Países',
            _getUniqueCountries().toString(),
            Icons.public,
            CyberpunkColors.accent,
          ),
        ),
      ],
    ).animate()
        .slideY(delay: 700.ms, duration: 600.ms)
        .fadeIn(delay: 700.ms, duration: 600.ms);
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: color.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CyberpunkColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesCard() {
    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_city,
                  color: CyberpunkColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Direcciones (${_user!.addresses.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CyberpunkColors.textPrimary,
                    ),
                  ),
                ),
                CyberpunkBadge(
                  text: _user!.addresses.length.toString(),
                  color: CyberpunkColors.primary,
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_user!.addresses.isEmpty)
              _buildEmptyAddresses()
            else
              ..._user!.addresses.asMap().entries.map((entry) {
                final index = entry.key;
                final address = entry.value;
                return _buildAddressItem(address, index);
              }).toList(),
          ],
        ),
      ),
    ).animate()
        .slideX(delay: 900.ms, duration: 600.ms)
        .fadeIn(delay: 900.ms, duration: 600.ms);
  }

  Widget _buildEmptyAddresses() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CyberpunkColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CyberpunkColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            color: CyberpunkColors.textSecondary,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Sin direcciones registradas',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CyberpunkColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          CyberpunkButton(
            text: 'Agregar Dirección',
            onPressed: _manageAddresses,
            icon: Icons.add_location,
            variant: CyberpunkButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(Address address, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: index < _user!.addresses.length - 1 ? 16 : 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberpunkColors.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CyberpunkColors.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: CyberpunkColors.secondaryGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.formattedAddress,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CyberpunkColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${address.city}, ${address.state}, ${address.country}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CyberpunkColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: CyberpunkColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    ).animate()
        .slideX(
          delay: Duration(milliseconds: 1000 + (index * 100)),
          duration: 500.ms,
        )
        .fadeIn(
          delay: Duration(milliseconds: 1000 + (index * 100)),
          duration: 500.ms,
        );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CyberpunkButton(
                text: 'Editar Usuario',
                onPressed: _editUser,
                icon: Icons.edit,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CyberpunkButton(
                text: 'Gestionar Direcciones',
                onPressed: _manageAddresses,
                variant: CyberpunkButtonVariant.outline,
                icon: Icons.location_on,
              ),
            ),
          ],
        ).animate()
            .slideY(delay: 1200.ms, duration: 600.ms)
            .fadeIn(delay: 1200.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: Center(
        child: CyberpunkCard(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CyberpunkLoadingIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Actualizando información...',
                  style: TextStyle(
                    color: CyberpunkColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  int _getUniqueCountries() {
    final countries = <String>{};
    for (final address in _user!.addresses) {
      countries.add(address.country);
    }
    return countries.length;
  }
}

class _ProfileParticlePainter extends CustomPainter {
  final AnimationController controller;

  _ProfileParticlePainter(this.controller) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CyberpunkColors.primary.withOpacity(0.05)
      ..strokeWidth = 2;

    for (int i = 0; i < 15; i++) {
      final x = (i * 80 + controller.value * 120) % size.width;
      final y = (i * 60 + controller.value * 80) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        3,
        paint,
      );

      // Draw connections
      if (i < 14) {
        final nextX = ((i + 1) * 80 + controller.value * 120) % size.width;
        final nextY = ((i + 1) * 60 + controller.value * 80) % size.height;

        canvas.drawLine(
          Offset(x, y),
          Offset(nextX, nextY),
          Paint()
            ..color = CyberpunkColors.primary.withOpacity(0.02)
            ..strokeWidth = 1,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
