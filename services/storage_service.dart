import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/error_model.dart';

/// Servicio para manejo de persistencia local usando SharedPreferences
/// Implementa el patrón Repository para acceso a datos
class StorageService {
  static const String _usersKey = 'users_data';
  static const String _settingsKey = 'app_settings';

  SharedPreferences? _prefs;

  /// Inicializa el servicio de almacenamiento
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Obtiene todos los usuarios almacenados
  Future<List<User>> getUsers() async {
    await init();

    try {
      final String? usersJson = _prefs?.getString(_usersKey);
      if (usersJson == null || usersJson.isEmpty) {
        return [];
      }

      final List<dynamic> usersList = json.decode(usersJson);
      return usersList.map((userJson) => User.fromJson(userJson)).toList();
    } catch (e) {
      throw AppError.storage(
        'Error al cargar usuarios del almacenamiento',
        details: e.toString(),
      );
    }
  }

  /// Guarda la lista de usuarios
  Future<void> saveUsers(List<User> users) async {
    await init();

    try {
      final List<Map<String, dynamic>> usersJson = 
          users.map((user) => user.toJson()).toList();

      final String jsonString = json.encode(usersJson);
      await _prefs?.setString(_usersKey, jsonString);
    } catch (e) {
      throw AppError.storage(
        'Error al guardar usuarios',
        details: e.toString(),
      );
    }
  }

  /// Obtiene un usuario específico por ID
  Future<User?> getUserById(String userId) async {
    final users = await getUsers();
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Guarda un usuario individual
  Future<void> saveUser(User user) async {
    final users = await getUsers();
    final existingIndex = users.indexWhere((u) => u.id == user.id);

    if (existingIndex >= 0) {
      users[existingIndex] = user;
    } else {
      users.add(user);
    }

    await saveUsers(users);
  }

  /// Elimina un usuario por ID
  Future<bool> deleteUser(String userId) async {
    final users = await getUsers();
    final initialLength = users.length;
    users.removeWhere((user) => user.id == userId);

    if (users.length < initialLength) {
      await saveUsers(users);
      return true;
    }

    return false;
  }

  /// Obtiene configuraciones de la aplicación
  Future<Map<String, dynamic>> getAppSettings() async {
    await init();

    try {
      final String? settingsJson = _prefs?.getString(_settingsKey);
      if (settingsJson == null || settingsJson.isEmpty) {
        return _getDefaultSettings();
      }

      return json.decode(settingsJson);
    } catch (e) {
      return _getDefaultSettings();
    }
  }

  /// Guarda configuraciones de la aplicación
  Future<void> saveAppSettings(Map<String, dynamic> settings) async {
    await init();

    try {
      final String jsonString = json.encode(settings);
      await _prefs?.setString(_settingsKey, jsonString);
    } catch (e) {
      throw AppError.storage(
        'Error al guardar configuraciones',
        details: e.toString(),
      );
    }
  }

  /// Obtiene una configuración específica
  Future<T?> getSetting<T>(String key, {T? defaultValue}) async {
    final settings = await getAppSettings();
    return settings[key] as T? ?? defaultValue;
  }

  /// Guarda una configuración específica
  Future<void> saveSetting<T>(String key, T value) async {
    final settings = await getAppSettings();
    settings[key] = value;
    await saveAppSettings(settings);
  }

  /// Limpia todos los datos almacenados
  Future<void> clearAllData() async {
    await init();

    try {
      await _prefs?.remove(_usersKey);
      await _prefs?.remove(_settingsKey);
    } catch (e) {
      throw AppError.storage(
        'Error al limpiar datos',
        details: e.toString(),
      );
    }
  }

  /// Limpia solo los usuarios
  Future<void> clearUsers() async {
    await init();

    try {
      await _prefs?.remove(_usersKey);
    } catch (e) {
      throw AppError.storage(
        'Error al limpiar usuarios',
        details: e.toString(),
      );
    }
  }

  /// Obtiene estadísticas de uso
  Future<Map<String, dynamic>> getUsageStats() async {
    final users = await getUsers();
    final settings = await getAppSettings();

    return {
      'totalUsers': users.length,
      'totalAddresses': users.fold<int>(0, (sum, user) => sum + user.addresses.length),
      'averageAddressesPerUser': users.isEmpty 
          ? 0.0 
          : users.fold<int>(0, (sum, user) => sum + user.addresses.length) / users.length,
      'oldestUser': users.isEmpty 
          ? null 
          : users.reduce((a, b) => a.createdAt.isBefore(b.createdAt) ? a : b).id,
      'newestUser': users.isEmpty 
          ? null 
          : users.reduce((a, b) => a.createdAt.isAfter(b.createdAt) ? a : b).id,
      'appVersion': settings['appVersion'] ?? '1.0.0',
      'lastUsed': DateTime.now().toIso8601String(),
    };
  }

  /// Exporta todos los datos como JSON
  Future<String> exportData() async {
    final users = await getUsers();
    final settings = await getAppSettings();
    final stats = await getUsageStats();

    return json.encode({
      'version': '1.0.0',
      'exportDate': DateTime.now().toIso8601String(),
      'users': users.map((user) => user.toJson()).toList(),
      'settings': settings,
      'stats': stats,
    });
  }

  /// Importa datos desde JSON
  Future<void> importData(String jsonData) async {
    try {
      final Map<String, dynamic> data = json.decode(jsonData);

      // Validar estructura
      if (!data.containsKey('users') || !data.containsKey('version')) {
        throw AppError.validation('Formato de datos inválido');
      }

      // Importar usuarios
      final List<dynamic> usersData = data['users'];
      final users = usersData.map((userData) => User.fromJson(userData)).toList();
      await saveUsers(users);

      // Importar configuraciones si existen
      if (data.containsKey('settings')) {
        await saveAppSettings(data['settings']);
      }
    } catch (e) {
      throw AppError.storage(
        'Error al importar datos',
        details: e.toString(),
      );
    }
  }

  /// Configuraciones por defecto
  Map<String, dynamic> _getDefaultSettings() {
    return {
      'theme': 'dark',
      'showAnimations': true,
      'animationSpeed': 1.0,
      'appVersion': '1.0.0',
      'firstLaunch': true,
      'language': 'es',
    };
  }

  /// Verifica si es el primer lanzamiento
  Future<bool> isFirstLaunch() async {
    return await getSetting<bool>('firstLaunch', defaultValue: true) ?? true;
  }

  /// Marca que ya no es el primer lanzamiento
  Future<void> setFirstLaunchCompleted() async {
    await saveSetting<bool>('firstLaunch', false);
  }
}
