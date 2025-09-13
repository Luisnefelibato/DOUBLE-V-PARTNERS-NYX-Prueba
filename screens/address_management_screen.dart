
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/user_model.dart';
import '../services/storage_service.dart';
import '../services/geographic_service.dart';
import '../widgets/cyberpunk_widgets.dart';
import '../theme/cyberpunk_theme.dart';

class AddressManagementScreen extends StatefulWidget {
  const AddressManagementScreen({Key? key}) : super(key: key);

  @override
  State<AddressManagementScreen> createState() => _AddressManagementScreenState();
}

class _AddressManagementScreenState extends State<AddressManagementScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  User? _selectedUser;
  List<User> _users = [];
  bool _isLoading = true;
  bool _isAddingAddress = false;

  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  String? _selectedCountryId;
  String? _selectedStateId;
  String? _selectedCityId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadUsers();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _streetController.dispose();
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

  void _clearAddressForm() {
    _streetController.clear();
    _selectedCountryId = null;
    _selectedStateId = null;
    _selectedCityId = null;
  }

  Future<void> _addAddress() async {
    if (_selectedUser == null) {
      _showErrorDialog('Selecciona un usuario primero');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCountryId == null || _selectedStateId == null || _selectedCityId == null) {
      _showErrorDialog('Completa todos los campos de ubicación');
      return;
    }

    setState(() {
      _isAddingAddress = true;
    });

    try {
      final country = GeographicService.instance.getCountryById(_selectedCountryId!);
      final state = GeographicService.instance.getStateById(_selectedCountryId!, _selectedStateId!);
      final city = GeographicService.instance.getCityById(_selectedCountryId!, _selectedStateId!, _selectedCityId!);

      final newAddress = Address(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        street: _streetController.text.trim(),
        city: city?.name ?? '',
        state: state?.name ?? '',
        country: country?.name ?? '',
      );

      final updatedUser = _selectedUser!.copyWith(
        addresses: [..._selectedUser!.addresses, newAddress],
      );

      await StorageService.instance.updateUser(updatedUser);

      setState(() {
        _selectedUser = updatedUser;
        final index = _users.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) {
          _users[index] = updatedUser;
        }
      });

      _clearAddressForm();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dirección agregada exitosamente'),
            backgroundColor: CyberpunkColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error al agregar dirección: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingAddress = false;
        });
      }
    }
  }

  Future<void> _deleteAddress(Address address) async {
    if (_selectedUser == null) return;

    final confirmed = await _showDeleteConfirmationDialog(address);
    if (confirmed != true) return;

    try {
      final updatedUser = _selectedUser!.copyWith(
        addresses: _selectedUser!.addresses.where((a) => a.id != address.id).toList(),
      );

      await StorageService.instance.updateUser(updatedUser);

      setState(() {
        _selectedUser = updatedUser;
        final index = _users.indexWhere((u) => u.id == updatedUser.id);
        if (index != -1) {
          _users[index] = updatedUser;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Dirección eliminada'),
            backgroundColor: CyberpunkColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error al eliminar dirección: $e');
      }
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(Address address) {
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
          'Eliminar Dirección',
          style: TextStyle(
            color: CyberpunkColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar esta dirección?\n${address.formattedAddress}',
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CyberpunkColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: CyberpunkColors.error.withOpacity(0.3),
            width: 1,
          ),
        ),
        title: Text(
          'Error',
          style: TextStyle(
            color: CyberpunkColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: CyberpunkColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: CyberpunkColors.primary),
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
        child: _isLoading ? _buildLoadingState() : _buildContent(),
      ),
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
        'Gestionar Direcciones',
        style: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
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

  Widget _buildContent() {
    if (_users.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserSelector(),
          if (_selectedUser != null) ...[
            const SizedBox(height: 24),
            _buildAddressForm(),
            const SizedBox(height: 24),
            _buildAddressList(),
          ],
        ],
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
              Icons.location_off,
              color: Colors.white,
              size: 60,
            ),
          ).animate()
              .scale(delay: 300.ms, duration: 600.ms)
              .shimmer(delay: 900.ms, duration: 1000.ms),
          const SizedBox(height: 24),
          Text(
            'No hay usuarios registrados',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: CyberpunkColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Crea usuarios primero para gestionar sus direcciones',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: CyberpunkColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          CyberpunkButton(
            text: 'Crear Usuario',
            onPressed: () {
              Navigator.pushNamed(context, '/user-form');
            },
            icon: Icons.person_add,
          ),
        ],
      ),
    );
  }

  Widget _buildUserSelector() {
    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seleccionar Usuario',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: CyberpunkColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            CyberpunkDropdown<String>(
              value: _selectedUser?.id,
              hint: 'Elige un usuario',
              items: _users
                  .map((user) => DropdownMenuItem<String>(
                        value: user.id,
                        child: Text('${user.fullName} (${user.addresses.length} direcciones)'),
                      ))
                  .toList(),
              onChanged: (userId) {
                setState(() {
                  _selectedUser = _users.firstWhere((u) => u.id == userId);
                  _clearAddressForm();
                });
              },
            ),
          ],
        ),
      ),
    ).animate()
        .slideY(delay: 300.ms, duration: 600.ms)
        .fadeIn(delay: 300.ms, duration: 600.ms);
  }

  Widget _buildAddressForm() {
    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar Nueva Dirección',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: CyberpunkColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _buildCountryDropdown(),
              const SizedBox(height: 16),
              _buildStateDropdown(),
              const SizedBox(height: 16),
              _buildCityDropdown(),
              const SizedBox(height: 16),
              _buildStreetField(),
              const SizedBox(height: 24),
              _buildAddButton(),
            ],
          ),
        ),
      ),
    ).animate()
        .slideY(delay: 500.ms, duration: 600.ms)
        .fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildCountryDropdown() {
    return CyberpunkDropdown<String>(
      value: _selectedCountryId,
      hint: 'Seleccionar país',
      items: GeographicService.instance.countries
          .map((country) => DropdownMenuItem<String>(
                value: country.id,
                child: Text(country.name),
              ))
          .toList(),
      onChanged: (countryId) {
        setState(() {
          _selectedCountryId = countryId;
          _selectedStateId = null;
          _selectedCityId = null;
        });
      },
    );
  }

  Widget _buildStateDropdown() {
    final states = _selectedCountryId != null
        ? GeographicService.instance.getStatesForCountry(_selectedCountryId!)
        : <State>[];

    return CyberpunkDropdown<String>(
      value: _selectedStateId,
      hint: 'Seleccionar departamento/estado',
      items: states
          .map((state) => DropdownMenuItem<String>(
                value: state.id,
                child: Text(state.name),
              ))
          .toList(),
      onChanged: states.isNotEmpty
          ? (stateId) {
              setState(() {
                _selectedStateId = stateId;
                _selectedCityId = null;
              });
            }
          : null,
    );
  }

  Widget _buildCityDropdown() {
    final cities = _selectedCountryId != null && _selectedStateId != null
        ? GeographicService.instance.getCitiesForState(_selectedCountryId!, _selectedStateId!)
        : <City>[];

    return CyberpunkDropdown<String>(
      value: _selectedCityId,
      hint: 'Seleccionar ciudad/municipio',
      items: cities
          .map((city) => DropdownMenuItem<String>(
                value: city.id,
                child: Text(city.name),
              ))
          .toList(),
      onChanged: cities.isNotEmpty
          ? (cityId) {
              setState(() {
                _selectedCityId = cityId;
              });
            }
          : null,
    );
  }

  Widget _buildStreetField() {
    return CyberpunkTextField(
      controller: _streetController,
      label: 'Dirección',
      hintText: 'Calle, número, sector...',
      prefixIcon: Icons.location_on,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'La dirección es obligatoria';
        }
        if (value.trim().length < 5) {
          return 'La dirección debe tener al menos 5 caracteres';
        }
        return null;
      },
      enabled: !_isAddingAddress,
    );
  }

  Widget _buildAddButton() {
    return Row(
      children: [
        Expanded(
          child: CyberpunkButton(
            text: 'Agregar Dirección',
            onPressed: _isAddingAddress ? null : _addAddress,
            icon: Icons.add_location,
            isLoading: _isAddingAddress,
          ),
        ),
      ],
    );
  }

  Widget _buildAddressList() {
    final addresses = _selectedUser?.addresses ?? [];

    return CyberpunkCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Direcciones (${addresses.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CyberpunkColors.textPrimary,
                    ),
                  ),
                ),
                if (addresses.isNotEmpty)
                  CyberpunkBadge(
                    text: addresses.length.toString(),
                    color: CyberpunkColors.primary,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (addresses.isEmpty)
              _buildEmptyAddressList()
            else
              ...addresses.asMap().entries.map((entry) {
                final index = entry.key;
                final address = entry.value;
                return _buildAddressItem(address, index);
              }).toList(),
          ],
        ),
      ),
    ).animate()
        .slideY(delay: 700.ms, duration: 600.ms)
        .fadeIn(delay: 700.ms, duration: 600.ms);
  }

  Widget _buildEmptyAddressList() {
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
            'Sin direcciones',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CyberpunkColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Agrega la primera dirección',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CyberpunkColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(Address address, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: index < (_selectedUser?.addresses.length ?? 0) - 1 ? 12 : 0),
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
          IconButton(
            onPressed: () => _deleteAddress(address),
            icon: Icon(
              Icons.delete,
              color: CyberpunkColors.error,
              size: 20,
            ),
          ),
        ],
      ),
    ).animate()
        .slideX(
          delay: Duration(milliseconds: 800 + (index * 100)),
          duration: 500.ms,
        )
        .fadeIn(
          delay: Duration(milliseconds: 800 + (index * 100)),
          duration: 500.ms,
        );
  }
}
