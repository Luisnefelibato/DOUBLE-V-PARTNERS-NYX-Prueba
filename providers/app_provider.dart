import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Provider para gestión del estado global de la aplicación
/// Maneja tema, navegación y configuraciones de UI
class AppProvider with ChangeNotifier {

  // Estado del tema
  ThemeMode _themeMode = ThemeMode.dark;

  // Estado de navegación
  int _currentPageIndex = 0;

  // Estado de loading global
  bool _isLoading = false;
  String _loadingMessage = '';

  // Estado de formularios
  bool _isFormDirty = false;

  // Configuraciones de UI
  bool _showAnimations = true;
  double _animationSpeed = 1.0;

  // Getters
  ThemeMode get themeMode => _themeMode;
  int get currentPageIndex => _currentPageIndex;
  bool get isLoading => _isLoading;
  String get loadingMessage => _loadingMessage;
  bool get isFormDirty => _isFormDirty;
  bool get showAnimations => _showAnimations;
  double get animationSpeed => _animationSpeed;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Cambia el modo del tema
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark 
        ? ThemeMode.light 
        : ThemeMode.dark;
    notifyListeners();
  }

  /// Establece el modo del tema específicamente
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Cambia la página actual en navegación
  void setCurrentPageIndex(int index) {
    if (_currentPageIndex != index) {
      _currentPageIndex = index;
      notifyListeners();
    }
  }

  /// Muestra el indicador de carga global
  void showLoading([String message = 'Cargando...']) {
    _isLoading = true;
    _loadingMessage = message;
    notifyListeners();
  }

  /// Oculta el indicador de carga global
  void hideLoading() {
    _isLoading = false;
    _loadingMessage = '';
    notifyListeners();
  }

  /// Marca el formulario como modificado
  void setFormDirty(bool isDirty) {
    if (_isFormDirty != isDirty) {
      _isFormDirty = isDirty;
      notifyListeners();
    }
  }

  /// Establece si mostrar animaciones
  void setShowAnimations(bool show) {
    if (_showAnimations != show) {
      _showAnimations = show;
      notifyListeners();
    }
  }

  /// Establece la velocidad de animaciones
  void setAnimationSpeed(double speed) {
    if (_animationSpeed != speed) {
      _animationSpeed = speed.clamp(0.1, 3.0);
      notifyListeners();
    }
  }

  /// Resetea todos los estados a sus valores por defecto
  void reset() {
    _currentPageIndex = 0;
    _isLoading = false;
    _loadingMessage = '';
    _isFormDirty = false;
    notifyListeners();
  }
}

/// Provider para manejo de validaciones de formularios
class ValidationProvider with ChangeNotifier {

  // Errores de validación por campo
  final Map<String, String?> _fieldErrors = {};

  // Estado de validación general
  bool _isValid = true;

  // Getters
  Map<String, String?> get fieldErrors => Map.unmodifiable(_fieldErrors);
  bool get isValid => _isValid;

  /// Establece un error para un campo específico
  void setFieldError(String fieldName, String? error) {
    if (_fieldErrors[fieldName] != error) {
      if (error == null) {
        _fieldErrors.remove(fieldName);
      } else {
        _fieldErrors[fieldName] = error;
      }
      _updateValidationState();
      notifyListeners();
    }
  }

  /// Obtiene el error de un campo específico
  String? getFieldError(String fieldName) {
    return _fieldErrors[fieldName];
  }

  /// Verifica si un campo tiene error
  bool hasFieldError(String fieldName) {
    return _fieldErrors.containsKey(fieldName) && _fieldErrors[fieldName] != null;
  }

  /// Limpia el error de un campo específico
  void clearFieldError(String fieldName) {
    setFieldError(fieldName, null);
  }

  /// Limpia todos los errores
  void clearAllErrors() {
    _fieldErrors.clear();
    _updateValidationState();
    notifyListeners();
  }

  /// Valida un campo de nombre
  String? validateName(String? value, {String fieldName = 'Nombre'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    if (value.trim().length < 2) {
      return '$fieldName debe tener al menos 2 caracteres';
    }
    if (value.trim().length > 50) {
      return '$fieldName no puede tener más de 50 caracteres';
    }
    if (!RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$').hasMatch(value.trim())) {
      return '$fieldName solo puede contener letras y espacios';
    }
    return null;
  }

  /// Valida fecha de nacimiento
  String? validateBirthDate(DateTime? value) {
    if (value == null) {
      return 'Fecha de nacimiento es requerida';
    }

    final now = DateTime.now();
    if (value.isAfter(now)) {
      return 'La fecha no puede ser en el futuro';
    }

    final age = now.year - value.year;
    if (age > 150) {
      return 'Edad no puede ser mayor a 150 años';
    }

    if (age < 0) {
      return 'Fecha de nacimiento inválida';
    }

    return null;
  }

  /// Valida dirección
  String? validateAddress(String? value, {String fieldName = 'Dirección'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerida';
    }
    if (value.trim().length < 5) {
      return '$fieldName debe tener al menos 5 caracteres';
    }
    if (value.trim().length > 200) {
      return '$fieldName no puede tener más de 200 caracteres';
    }
    return null;
  }

  /// Valida campo requerido genérico
  String? validateRequired(String? value, {String fieldName = 'Campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Actualiza el estado general de validación
  void _updateValidationState() {
    _isValid = _fieldErrors.isEmpty || 
               _fieldErrors.values.every((error) => error == null);
  }

  /// Valida todos los campos de usuario
  Map<String, String?> validateUserForm({
    required String firstName,
    required String lastName,
    required DateTime? birthDate,
  }) {
    final errors = <String, String?>{};

    final firstNameError = validateName(firstName, fieldName: 'Nombre');
    if (firstNameError != null) errors['firstName'] = firstNameError;

    final lastNameError = validateName(lastName, fieldName: 'Apellido');
    if (lastNameError != null) errors['lastName'] = lastNameError;

    final birthDateError = validateBirthDate(birthDate);
    if (birthDateError != null) errors['birthDate'] = birthDateError;

    return errors;
  }

  /// Valida todos los campos de dirección
  Map<String, String?> validateAddressForm({
    required String country,
    required String state,
    required String city,
    required String streetAddress,
  }) {
    final errors = <String, String?>{};

    final countryError = validateRequired(country, fieldName: 'País');
    if (countryError != null) errors['country'] = countryError;

    final stateError = validateRequired(state, fieldName: 'Departamento');
    if (stateError != null) errors['state'] = stateError;

    final cityError = validateRequired(city, fieldName: 'Municipio');
    if (cityError != null) errors['city'] = cityError;

    final streetError = validateAddress(streetAddress, fieldName: 'Dirección');
    if (streetError != null) errors['streetAddress'] = streetError;

    return errors;
  }
}
