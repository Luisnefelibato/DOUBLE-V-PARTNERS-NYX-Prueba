
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/app_provider.dart';
import '../services/storage_service.dart';
import '../widgets/cyberpunk_widgets.dart';
import '../theme/cyberpunk_theme.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({Key? key}) : super(key: key);

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _birthDateController = TextEditingController();

  User? _editingUser;
  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ModalRoute.of(context)?.settings.arguments as User?;
      if (user != null) {
        _initializeForEditing(user);
      }
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _initializeForEditing(User user) {
    setState(() {
      _editingUser = user;
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _selectedDate = user.birthDate;
      _birthDateController.text = _formatDate(user.birthDate);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: CyberpunkColors.surface,
            colorScheme: ColorScheme.dark(
              primary: CyberpunkColors.primary,
              onPrimary: Colors.white,
              surface: CyberpunkColors.surface,
              onSurface: CyberpunkColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null) {
      _showErrorDialog('Por favor selecciona una fecha de nacimiento');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = User(
        id: _editingUser?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        birthDate: _selectedDate!,
        addresses: _editingUser?.addresses ?? [],
      );

      if (_editingUser != null) {
        await StorageService.instance.updateUser(user);
      } else {
        await StorageService.instance.saveUser(user);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _editingUser != null 
                ? 'Usuario actualizado exitosamente' 
                : 'Usuario creado exitosamente',
            ),
            backgroundColor: CyberpunkColors.success,
          ),
        );

        Navigator.of(context).pop(user);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Error al guardar usuario: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.trim().length < 2) {
      return 'Debe tener al menos 2 caracteres';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value.trim())) {
      return 'Solo se permiten letras';
    }
    return null;
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
        child: Stack(
          children: [
            _buildForm(),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
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
        _editingUser != null ? 'Editar Usuario' : 'Nuevo Usuario',
        style: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _isLoading ? null : _saveUser,
          icon: Icon(
            Icons.save,
            color: _isLoading ? CyberpunkColors.textSecondary : CyberpunkColors.primary,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildForm() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              _buildPersonalInfoCard(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: CyberpunkColors.primaryGradient,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: CyberpunkColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            _editingUser != null ? Icons.edit : Icons.person_add,
            color: Colors.white,
            size: 30,
          ),
        ).animate()
            .scale(delay: 200.ms, duration: 600.ms)
            .shimmer(delay: 800.ms, duration: 1000.ms),
        const SizedBox(height: 16),
        Text(
          _editingUser != null ? 'Actualizar Información' : 'Información Personal',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: CyberpunkColors.textPrimary,
          ),
        ).animate()
            .slideX(delay: 300.ms, duration: 600.ms)
            .fadeIn(delay: 300.ms, duration: 600.ms),
        const SizedBox(height: 8),
        Text(
          _editingUser != null 
              ? 'Modifica los datos del usuario'
              : 'Ingresa los datos del nuevo usuario',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: CyberpunkColors.textSecondary,
          ),
        ).animate()
            .slideX(delay: 400.ms, duration: 600.ms)
            .fadeIn(delay: 400.ms, duration: 600.ms),
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
            Text(
              'Datos Personales',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: CyberpunkColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildFirstNameField(),
            const SizedBox(height: 20),
            _buildLastNameField(),
            const SizedBox(height: 20),
            _buildBirthDateField(),
          ],
        ),
      ),
    ).animate()
        .slideY(delay: 500.ms, duration: 600.ms)
        .fadeIn(delay: 500.ms, duration: 600.ms);
  }

  Widget _buildFirstNameField() {
    return CyberpunkTextField(
      controller: _firstNameController,
      label: 'Nombre',
      hintText: 'Ingresa tu nombre',
      prefixIcon: Icons.person,
      validator: _validateName,
      enabled: !_isLoading,
    ).animate()
        .slideX(delay: 600.ms, duration: 500.ms)
        .fadeIn(delay: 600.ms, duration: 500.ms);
  }

  Widget _buildLastNameField() {
    return CyberpunkTextField(
      controller: _lastNameController,
      label: 'Apellido',
      hintText: 'Ingresa tu apellido',
      prefixIcon: Icons.person_outline,
      validator: _validateName,
      enabled: !_isLoading,
    ).animate()
        .slideX(delay: 700.ms, duration: 500.ms)
        .fadeIn(delay: 700.ms, duration: 500.ms);
  }

  Widget _buildBirthDateField() {
    return GestureDetector(
      onTap: _isLoading ? null : _selectDate,
      child: AbsorbPointer(
        child: CyberpunkTextField(
          controller: _birthDateController,
          label: 'Fecha de Nacimiento',
          hintText: 'Selecciona tu fecha de nacimiento',
          prefixIcon: Icons.calendar_today,
          suffixIcon: Icons.arrow_drop_down,
          validator: (value) {
            if (_selectedDate == null) {
              return 'Selecciona una fecha de nacimiento';
            }
            return null;
          },
          enabled: !_isLoading,
        ),
      ),
    ).animate()
        .slideX(delay: 800.ms, duration: 500.ms)
        .fadeIn(delay: 800.ms, duration: 500.ms);
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CyberpunkButton(
                text: _editingUser != null ? 'Actualizar Usuario' : 'Crear Usuario',
                onPressed: _isLoading ? null : _saveUser,
                icon: _editingUser != null ? Icons.update : Icons.save,
                isLoading: _isLoading,
              ),
            ),
          ],
        ).animate()
            .slideY(delay: 900.ms, duration: 600.ms)
            .fadeIn(delay: 900.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CyberpunkButton(
                text: 'Cancelar',
                onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                variant: CyberpunkButtonVariant.outline,
                icon: Icons.cancel,
              ),
            ),
          ],
        ).animate()
            .slideY(delay: 1000.ms, duration: 600.ms)
            .fadeIn(delay: 1000.ms, duration: 600.ms),
        if (_editingUser != null) ...[
          const SizedBox(height: 24),
          Text(
            'Después de actualizar el usuario, podrás gestionar sus direcciones',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CyberpunkColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ).animate()
              .slideY(delay: 1100.ms, duration: 600.ms)
              .fadeIn(delay: 1100.ms, duration: 600.ms),
        ],
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
                  _editingUser != null ? 'Actualizando usuario...' : 'Creando usuario...',
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
}
