
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../widgets/cyberpunk_widgets.dart';
import '../theme/cyberpunk_theme.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  List<User> _users = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadUsers();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await StorageService.instance.getAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
      _animationController.forward();
    } catch (e) {
      setState(() {
        _users = [];
        _isLoading = false;
      });
    }
  }

  List<User> get _filteredUsers {
    if (_searchQuery.isEmpty) {
      return _users;
    }
    return _users
        .where((user) =>
            user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.firstName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.lastName.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> _deleteUser(User user) async {
    final confirmed = await _showDeleteConfirmationDialog(user);
    if (confirmed == true) {
      try {
        await StorageService.instance.deleteUser(user.id);
        await _loadUsers();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Usuario ${user.fullName} eliminado'),
              backgroundColor: CyberpunkColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al eliminar usuario: $e'),
              backgroundColor: CyberpunkColors.error,
            ),
          );
        }
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(User user) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CyberpunkColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: CyberpunkColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Eliminar Usuario',
          style: TextStyle(
            color: CyberpunkColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${user.fullName}?\nEsta acción no se puede deshacer.',
          style: TextStyle(
            color: CyberpunkColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: CyberpunkColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Eliminar',
              style: TextStyle(color: CyberpunkColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CyberpunkColors.background,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: CyberpunkColors.backgroundGradient,
        ),
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildUserList(),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
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
        'Usuarios (${_filteredUsers.length})',
        style: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _loadUsers,
          icon: const Icon(
            Icons.refresh,
            color: CyberpunkColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: CyberpunkTextField(
        controller: _searchController,
        hintText: 'Buscar usuarios...',
        prefixIcon: Icons.search,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                icon: const Icon(Icons.clear),
              )
            : null,
      ),
    ).animate()
        .slideX(delay: 200.ms, duration: 600.ms)
        .fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CyberpunkLoadingIndicator(),
          const SizedBox(height: 16),
          Text(
            'Cargando usuarios...',
            style: TextStyle(
              color: CyberpunkColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (_filteredUsers.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      color: CyberpunkColors.primary,
      backgroundColor: CyberpunkColors.surface,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          return _buildUserCard(user, index);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: CyberpunkColors.primaryGradient,
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.people_outline,
              color: Colors.white,
              size: 60,
            ),
          ).animate()
              .scale(delay: 300.ms, duration: 600.ms)
              .shimmer(delay: 900.ms, duration: 1000.ms),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isEmpty ? 'No hay usuarios registrados' : 'No se encontraron usuarios',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CyberpunkColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ).animate()
              .slideY(delay: 500.ms, duration: 600.ms)
              .fadeIn(delay: 500.ms, duration: 600.ms),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty 
                ? 'Crea tu primer usuario para comenzar' 
                : 'Intenta con otro término de búsqueda',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CyberpunkColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ).animate()
              .slideY(delay: 700.ms, duration: 600.ms)
              .fadeIn(delay: 700.ms, duration: 600.ms),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 32),
            CyberpunkButton(
              text: 'Crear Usuario',
              onPressed: () {
                Navigator.pushNamed(context, '/user-form');
              },
              icon: Icons.add,
            ).animate()
                .slideY(delay: 900.ms, duration: 600.ms)
                .fadeIn(delay: 900.ms, duration: 600.ms),
          ],
        ],
      ),
    );
  }

  Widget _buildUserCard(User user, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: CyberpunkCard(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/profile',
            arguments: user,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _buildUserAvatar(user),
              const SizedBox(width: 16),
              Expanded(
                child: _buildUserInfo(user),
              ),
              _buildUserActions(user),
            ],
          ),
        ),
      ),
    ).animate()
        .slideX(
          delay: Duration(milliseconds: 300 + (index * 100)),
          duration: 600.ms,
        )
        .fadeIn(
          delay: Duration(milliseconds: 300 + (index * 100)),
          duration: 600.ms,
        );
  }

  Widget _buildUserAvatar(User user) {
    return CyberpunkAvatar(
      radius: 30,
      child: Text(
        user.initials,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.fullName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: CyberpunkColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${user.age} años',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: CyberpunkColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              Icons.location_on,
              size: 16,
              color: CyberpunkColors.accent,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                user.addresses.isNotEmpty
                    ? '${user.addresses.length} dirección${user.addresses.length > 1 ? 'es' : ''}'
                    : 'Sin direcciones',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: CyberpunkColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserActions(User user) {
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/user-form',
              arguments: user,
            );
          },
          icon: Icon(
            Icons.edit,
            color: CyberpunkColors.primary,
            size: 20,
          ),
        ),
        IconButton(
          onPressed: () => _deleteUser(user),
          icon: Icon(
            Icons.delete,
            color: CyberpunkColors.error,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pushNamed(context, '/user-form');
      },
      backgroundColor: CyberpunkColors.primary,
      child: const Icon(
        Icons.add,
        color: Colors.white,
      ),
    ).animate()
        .scale(delay: 1000.ms, duration: 600.ms)
        .shimmer(delay: 1500.ms, duration: 1000.ms);
  }
}
