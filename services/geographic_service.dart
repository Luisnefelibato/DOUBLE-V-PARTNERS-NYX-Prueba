import '../models/error_model.dart';

/// Modelo para países
class Country {
  final String code;
  final String name;
  final List<State> states;

  const Country({
    required this.code,
    required this.name,
    required this.states,
  });

  @override
  String toString() => name;
}

/// Modelo para departamentos/estados
class State {
  final String code;
  final String name;
  final String countryCode;
  final List<City> cities;

  const State({
    required this.code,
    required this.name,
    required this.countryCode,
    required this.cities,
  });

  @override
  String toString() => name;
}

/// Modelo para municipios/ciudades
class City {
  final String code;
  final String name;
  final String stateCode;

  const City({
    required this.code,
    required this.name,
    required this.stateCode,
  });

  @override
  String toString() => name;
}

/// Servicio para manejo de datos geográficos
/// Proporciona datos estáticos de países, departamentos y municipios
class GeographicService {

  static final GeographicService _instance = GeographicService._internal();
  factory GeographicService() => _instance;
  GeographicService._internal();

  late final List<Country> _countries;
  bool _initialized = false;

  /// Inicializa el servicio con datos geográficos
  Future<void> init() async {
    if (_initialized) return;

    _countries = [
      Country(
        code: 'CO',
        name: 'Colombia',
        states: [
          State(
            code: 'ANT',
            name: 'Antioquia',
            countryCode: 'CO',
            cities: [
              const City(code: 'MED', name: 'Medellín', stateCode: 'ANT'),
              const City(code: 'BEL', name: 'Bello', stateCode: 'ANT'),
              const City(code: 'ITA', name: 'Itagüí', stateCode: 'ANT'),
              const City(code: 'ENV', name: 'Envigado', stateCode: 'ANT'),
              const City(code: 'SAB', name: 'Sabaneta', stateCode: 'ANT'),
              const City(code: 'CAL', name: 'Caldas', stateCode: 'ANT'),
              const City(code: 'COP', name: 'Copacabana', stateCode: 'ANT'),
              const City(code: 'GIR', name: 'Girardota', stateCode: 'ANT'),
              const City(code: 'BAR', name: 'Barbosa', stateCode: 'ANT'),
              const City(code: 'RIO', name: 'Rionegro', stateCode: 'ANT'),
            ],
          ),
          State(
            code: 'CUN',
            name: 'Cundinamarca',
            countryCode: 'CO',
            cities: [
              const City(code: 'BOG', name: 'Bogotá', stateCode: 'CUN'),
              const City(code: 'SOA', name: 'Soacha', stateCode: 'CUN'),
              const City(code: 'CHI', name: 'Chía', stateCode: 'CUN'),
              const City(code: 'ZIP', name: 'Zipaquirá', stateCode: 'CUN'),
              const City(code: 'FUS', name: 'Fusagasugá', stateCode: 'CUN'),
              const City(code: 'FAC', name: 'Facatativá', stateCode: 'CUN'),
              const City(code: 'GIR_CUN', name: 'Girardot', stateCode: 'CUN'),
              const City(code: 'UBA', name: 'Ubaté', stateCode: 'CUN'),
              const City(code: 'VIL', name: 'Villeta', stateCode: 'CUN'),
              const City(code: 'CAJ', name: 'Cajicá', stateCode: 'CUN'),
            ],
          ),
          State(
            code: 'VAL',
            name: 'Valle del Cauca',
            countryCode: 'CO',
            cities: [
              const City(code: 'CAL_VAL', name: 'Cali', stateCode: 'VAL'),
              const City(code: 'PAL', name: 'Palmira', stateCode: 'VAL'),
              const City(code: 'BUE', name: 'Buenaventura', stateCode: 'VAL'),
              const City(code: 'TUL', name: 'Tuluá', stateCode: 'VAL'),
              const City(code: 'CAR', name: 'Cartago', stateCode: 'VAL'),
              const City(code: 'BUG', name: 'Buga', stateCode: 'VAL'),
              const City(code: 'YUM', name: 'Yumbo', stateCode: 'VAL'),
              const City(code: 'JAM', name: 'Jamundí', stateCode: 'VAL'),
            ],
          ),
          State(
            code: 'ATL',
            name: 'Atlántico',
            countryCode: 'CO',
            cities: [
              const City(code: 'BAQ', name: 'Barranquilla', stateCode: 'ATL'),
              const City(code: 'SOL', name: 'Soledad', stateCode: 'ATL'),
              const City(code: 'MAL', name: 'Malambo', stateCode: 'ATL'),
              const City(code: 'SAB_ATL', name: 'Sabanalarga', stateCode: 'ATL'),
              const City(code: 'POL', name: 'Polonuevo', stateCode: 'ATL'),
            ],
          ),
          State(
            code: 'BOL',
            name: 'Bolívar',
            countryCode: 'CO',
            cities: [
              const City(code: 'CTG', name: 'Cartagena', stateCode: 'BOL'),
              const City(code: 'MAG', name: 'Magangué', stateCode: 'BOL'),
              const City(code: 'TUR', name: 'Turbaco', stateCode: 'BOL'),
              const City(code: 'ARM', name: 'Arjona', stateCode: 'BOL'),
            ],
          ),
          State(
            code: 'SAN',
            name: 'Santander',
            countryCode: 'CO',
            cities: [
              const City(code: 'BUC', name: 'Bucaramanga', stateCode: 'SAN'),
              const City(code: 'FLO', name: 'Floridablanca', stateCode: 'SAN'),
              const City(code: 'GIR_SAN', name: 'Girón', stateCode: 'SAN'),
              const City(code: 'PIE', name: 'Piedecuesta', stateCode: 'SAN'),
              const City(code: 'BAR_SAN', name: 'Barrancabermeja', stateCode: 'SAN'),
            ],
          ),
        ],
      ),
      Country(
        code: 'US',
        name: 'Estados Unidos',
        states: [
          State(
            code: 'CA',
            name: 'California',
            countryCode: 'US',
            cities: [
              const City(code: 'LA', name: 'Los Angeles', stateCode: 'CA'),
              const City(code: 'SF', name: 'San Francisco', stateCode: 'CA'),
              const City(code: 'SD', name: 'San Diego', stateCode: 'CA'),
              const City(code: 'SAC', name: 'Sacramento', stateCode: 'CA'),
            ],
          ),
          State(
            code: 'NY',
            name: 'Nueva York',
            countryCode: 'US',
            cities: [
              const City(code: 'NYC', name: 'New York', stateCode: 'NY'),
              const City(code: 'BUF', name: 'Buffalo', stateCode: 'NY'),
              const City(code: 'ROC', name: 'Rochester', stateCode: 'NY'),
            ],
          ),
          State(
            code: 'FL',
            name: 'Florida',
            countryCode: 'US',
            cities: [
              const City(code: 'MIA', name: 'Miami', stateCode: 'FL'),
              const City(code: 'TAM', name: 'Tampa', stateCode: 'FL'),
              const City(code: 'ORL', name: 'Orlando', stateCode: 'FL'),
              const City(code: 'JAX', name: 'Jacksonville', stateCode: 'FL'),
            ],
          ),
        ],
      ),
      Country(
        code: 'MX',
        name: 'México',
        states: [
          State(
            code: 'CDMX',
            name: 'Ciudad de México',
            countryCode: 'MX',
            cities: [
              const City(code: 'MEX', name: 'Ciudad de México', stateCode: 'CDMX'),
              const City(code: 'ECT', name: 'Ecatepec', stateCode: 'CDMX'),
              const City(code: 'NEZ', name: 'Nezahualcóyotl', stateCode: 'CDMX'),
            ],
          ),
          State(
            code: 'JAL',
            name: 'Jalisco',
            countryCode: 'MX',
            cities: [
              const City(code: 'GDL', name: 'Guadalajara', stateCode: 'JAL'),
              const City(code: 'ZAP', name: 'Zapopan', stateCode: 'JAL'),
              const City(code: 'TLA', name: 'Tlaquepaque', stateCode: 'JAL'),
            ],
          ),
        ],
      ),
    ];

    _initialized = true;
  }

  /// Obtiene todos los países disponibles
  Future<Result<List<Country>>> getCountries() async {
    try {
      await init();
      return Result.success(_countries);
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error al cargar países',
        details: e.toString(),
      ));
    }
  }

  /// Obtiene los departamentos de un país
  Future<Result<List<State>>> getStatesByCountry(String countryCode) async {
    try {
      await init();

      final country = _countries
          .where((c) => c.code == countryCode)
          .firstOrNull;

      if (country == null) {
        return Result.error(AppError.validation('País no encontrado'));
      }

      return Result.success(country.states);
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error al cargar departamentos',
        details: e.toString(),
      ));
    }
  }

  /// Obtiene las ciudades de un departamento
  Future<Result<List<City>>> getCitiesByState(String stateCode) async {
    try {
      await init();

      for (final country in _countries) {
        final state = country.states
            .where((s) => s.code == stateCode)
            .firstOrNull;

        if (state != null) {
          return Result.success(state.cities);
        }
      }

      return Result.error(AppError.validation('Departamento no encontrado'));
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error al cargar ciudades',
        details: e.toString(),
      ));
    }
  }

  /// Busca países por nombre
  Future<Result<List<Country>>> searchCountries(String query) async {
    try {
      await init();

      if (query.trim().isEmpty) {
        return Result.success(_countries);
      }

      final lowercaseQuery = query.toLowerCase();
      final filteredCountries = _countries
          .where((country) => 
              country.name.toLowerCase().contains(lowercaseQuery) ||
              country.code.toLowerCase().contains(lowercaseQuery))
          .toList();

      return Result.success(filteredCountries);
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error en búsqueda de países',
        details: e.toString(),
      ));
    }
  }

  /// Busca departamentos por nombre
  Future<Result<List<State>>> searchStates(String query, {String? countryCode}) async {
    try {
      await init();

      List<State> allStates = [];

      if (countryCode != null) {
        final countryResult = await getStatesByCountry(countryCode);
        if (countryResult.isSuccess) {
          allStates = countryResult.data!;
        }
      } else {
        for (final country in _countries) {
          allStates.addAll(country.states);
        }
      }

      if (query.trim().isEmpty) {
        return Result.success(allStates);
      }

      final lowercaseQuery = query.toLowerCase();
      final filteredStates = allStates
          .where((state) => 
              state.name.toLowerCase().contains(lowercaseQuery) ||
              state.code.toLowerCase().contains(lowercaseQuery))
          .toList();

      return Result.success(filteredStates);
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error en búsqueda de departamentos',
        details: e.toString(),
      ));
    }
  }

  /// Busca ciudades por nombre
  Future<Result<List<City>>> searchCities(String query, {String? stateCode}) async {
    try {
      await init();

      List<City> allCities = [];

      if (stateCode != null) {
        final citiesResult = await getCitiesByState(stateCode);
        if (citiesResult.isSuccess) {
          allCities = citiesResult.data!;
        }
      } else {
        for (final country in _countries) {
          for (final state in country.states) {
            allCities.addAll(state.cities);
          }
        }
      }

      if (query.trim().isEmpty) {
        return Result.success(allCities);
      }

      final lowercaseQuery = query.toLowerCase();
      final filteredCities = allCities
          .where((city) => 
              city.name.toLowerCase().contains(lowercaseQuery) ||
              city.code.toLowerCase().contains(lowercaseQuery))
          .toList();

      return Result.success(filteredCities);
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error en búsqueda de ciudades',
        details: e.toString(),
      ));
    }
  }

  /// Obtiene información completa de ubicación por códigos
  Future<Result<Map<String, String>>> getLocationInfo({
    required String countryCode,
    required String stateCode,
    required String cityCode,
  }) async {
    try {
      await init();

      final country = _countries
          .where((c) => c.code == countryCode)
          .firstOrNull;

      if (country == null) {
        return Result.error(AppError.validation('País no encontrado'));
      }

      final state = country.states
          .where((s) => s.code == stateCode)
          .firstOrNull;

      if (state == null) {
        return Result.error(AppError.validation('Departamento no encontrado'));
      }

      final city = state.cities
          .where((c) => c.code == cityCode)
          .firstOrNull;

      if (city == null) {
        return Result.error(AppError.validation('Ciudad no encontrada'));
      }

      return Result.success({
        'country': country.name,
        'state': state.name,
        'city': city.name,
        'countryCode': country.code,
        'stateCode': state.code,
        'cityCode': city.code,
      });
    } catch (e) {
      return Result.error(AppError.unknown(
        'Error al obtener información de ubicación',
        details: e.toString(),
      ));
    }
  }
}

/// Extensión para obtener el primer elemento o null
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    return isEmpty ? null : first;
  }
}
