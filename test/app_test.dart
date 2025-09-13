
import 'package:flutter_test/flutter_test.dart';
import 'package:double_v_partners_nyx_app/models/user_model.dart';
import 'package:double_v_partners_nyx_app/models/error_model.dart';
import 'package:double_v_partners_nyx_app/services/storage_service.dart';
import 'package:double_v_partners_nyx_app/services/geographic_service.dart';

void main() {
  group('User Model Tests', () {
    test('should create a user with valid data', () {
      final user = User(
        id: '1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      expect(user.id, '1');
      expect(user.firstName, 'Luis');
      expect(user.lastName, 'Gomez');
      expect(user.fullName, 'Luis Gomez');
      expect(user.initials, 'LG');
      expect(user.addresses, isEmpty);
    });

    test('should calculate age correctly', () {
      final birthDate = DateTime(1990, 5, 15);
      final user = User(
        id: '1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: birthDate,
        addresses: [],
      );

      final expectedAge = DateTime.now().year - birthDate.year;
      final actualAge = user.age;

      // Age should be within 1 year range due to birth month/day
      expect(actualAge, anyOf(equals(expectedAge), equals(expectedAge - 1)));
    });

    test('should validate user data correctly', () {
      final validUser = User(
        id: '1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      expect(validUser.isValid, isTrue);

      final invalidUser = User(
        id: '',
        firstName: '',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      expect(invalidUser.isValid, isFalse);
    });

    test('should convert to and from JSON correctly', () {
      final user = User(
        id: '1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [
          Address(
            id: 'addr1',
            street: 'Calle 123',
            city: 'Bogotá',
            state: 'Cundinamarca',
            country: 'Colombia',
          ),
        ],
      );

      final json = user.toJson();
      final userFromJson = User.fromJson(json);

      expect(userFromJson.id, user.id);
      expect(userFromJson.firstName, user.firstName);
      expect(userFromJson.lastName, user.lastName);
      expect(userFromJson.birthDate, user.birthDate);
      expect(userFromJson.addresses.length, user.addresses.length);
    });

    test('should add and remove addresses correctly', () {
      final user = User(
        id: '1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      final address = Address(
        id: 'addr1',
        street: 'Calle 123',
        city: 'Bogotá',
        state: 'Cundinamarca',
        country: 'Colombia',
      );

      final userWithAddress = user.addAddress(address);
      expect(userWithAddress.addresses.length, 1);
      expect(userWithAddress.addresses.first.id, 'addr1');

      final userWithoutAddress = userWithAddress.removeAddress('addr1');
      expect(userWithoutAddress.addresses.length, 0);
    });
  });

  group('Address Model Tests', () {
    test('should create an address with valid data', () {
      final address = Address(
        id: 'addr1',
        street: 'Calle 123 #45-67',
        city: 'Bogotá',
        state: 'Cundinamarca',
        country: 'Colombia',
      );

      expect(address.id, 'addr1');
      expect(address.street, 'Calle 123 #45-67');
      expect(address.city, 'Bogotá');
      expect(address.state, 'Cundinamarca');
      expect(address.country, 'Colombia');
    });

    test('should format address correctly', () {
      final address = Address(
        id: 'addr1',
        street: 'Calle 123 #45-67',
        city: 'Bogotá',
        state: 'Cundinamarca',
        country: 'Colombia',
      );

      expect(address.formattedAddress, 'Calle 123 #45-67');
      expect(address.fullAddress, 'Calle 123 #45-67, Bogotá, Cundinamarca, Colombia');
    });

    test('should validate address data correctly', () {
      final validAddress = Address(
        id: 'addr1',
        street: 'Calle 123 #45-67',
        city: 'Bogotá',
        state: 'Cundinamarca',
        country: 'Colombia',
      );

      expect(validAddress.isValid, isTrue);

      final invalidAddress = Address(
        id: '',
        street: '',
        city: 'Bogotá',
        state: 'Cundinamarca',
        country: 'Colombia',
      );

      expect(invalidAddress.isValid, isFalse);
    });

    test('should convert to and from JSON correctly', () {
      final address = Address(
        id: 'addr1',
        street: 'Calle 123 #45-67',
        city: 'Bogotá',
        state: 'Cundinamarca',
        country: 'Colombia',
      );

      final json = address.toJson();
      final addressFromJson = Address.fromJson(json);

      expect(addressFromJson.id, address.id);
      expect(addressFromJson.street, address.street);
      expect(addressFromJson.city, address.city);
      expect(addressFromJson.state, address.state);
      expect(addressFromJson.country, address.country);
    });
  });

  group('Error Model Tests', () {
    test('should create validation error correctly', () {
      final error = AppError.validation('Este campo es obligatorio');

      expect(error.type, ErrorType.validation);
      expect(error.message, 'Este campo es obligatorio');
      expect(error.timestamp, isA<DateTime>());
    });

    test('should create network error correctly', () {
      final error = AppError.network('Sin conexión a internet');

      expect(error.type, ErrorType.network);
      expect(error.message, 'Sin conexión a internet');
    });

    test('should create storage error correctly', () {
      final error = AppError.storage('Error al guardar datos');

      expect(error.type, ErrorType.storage);
      expect(error.message, 'Error al guardar datos');
    });

    test('should create unknown error correctly', () {
      final error = AppError.unknown('Error desconocido');

      expect(error.type, ErrorType.unknown);
      expect(error.message, 'Error desconocido');
    });
  });

  group('Result Model Tests', () {
    test('should create success result correctly', () {
      final result = Result.success('Test data');

      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect(result.isLoading, isFalse);
      expect(result.data, 'Test data');
      expect(result.error, isNull);
    });

    test('should create error result correctly', () {
      final error = AppError.validation('Validation error');
      final result = Result<String>.error(error);

      expect(result.isSuccess, isFalse);
      expect(result.isError, isTrue);
      expect(result.isLoading, isFalse);
      expect(result.data, isNull);
      expect(result.error, equals(error));
    });

    test('should create loading result correctly', () {
      final result = Result<String>.loading();

      expect(result.isSuccess, isFalse);
      expect(result.isError, isFalse);
      expect(result.isLoading, isTrue);
      expect(result.data, isNull);
      expect(result.error, isNull);
    });

    test('should map result correctly', () {
      final result = Result.success(5);
      final mappedResult = result.map((data) => data * 2);

      expect(mappedResult.isSuccess, isTrue);
      expect(mappedResult.data, 10);
    });

    test('should not map error result', () {
      final error = AppError.validation('Error');
      final result = Result<int>.error(error);
      final mappedResult = result.map((data) => data * 2);

      expect(mappedResult.isError, isTrue);
      expect(mappedResult.error, equals(error));
    });
  });

  group('Geographic Service Tests', () {
    test('should return all countries', () {
      final countries = GeographicService.instance.countries;

      expect(countries, isNotEmpty);
      expect(countries.any((c) => c.name == 'Colombia'), isTrue);
      expect(countries.any((c) => c.name == 'Estados Unidos'), isTrue);
      expect(countries.any((c) => c.name == 'México'), isTrue);
    });

    test('should return states for Colombia', () {
      final states = GeographicService.instance.getStatesForCountry('CO');

      expect(states, isNotEmpty);
      expect(states.any((s) => s.name == 'Cundinamarca'), isTrue);
      expect(states.any((s) => s.name == 'Antioquia'), isTrue);
      expect(states.any((s) => s.name == 'Valle del Cauca'), isTrue);
    });

    test('should return cities for Cundinamarca', () {
      final cities = GeographicService.instance.getCitiesForState('CO', 'CO-CUN');

      expect(cities, isNotEmpty);
      expect(cities.any((c) => c.name == 'Bogotá D.C.'), isTrue);
      expect(cities.any((c) => c.name == 'Soacha'), isTrue);
      expect(cities.any((c) => c.name == 'Zipaquirá'), isTrue);
    });

    test('should find country by id', () {
      final country = GeographicService.instance.getCountryById('CO');

      expect(country, isNotNull);
      expect(country!.name, 'Colombia');
      expect(country.id, 'CO');
    });

    test('should find state by id', () {
      final state = GeographicService.instance.getStateById('CO', 'CO-CUN');

      expect(state, isNotNull);
      expect(state!.name, 'Cundinamarca');
      expect(state.id, 'CO-CUN');
    });

    test('should find city by id', () {
      final city = GeographicService.instance.getCityById('CO', 'CO-CUN', 'BOG');

      expect(city, isNotNull);
      expect(city!.name, 'Bogotá D.C.');
      expect(city.id, 'BOG');
    });

    test('should return empty list for invalid country', () {
      final states = GeographicService.instance.getStatesForCountry('INVALID');

      expect(states, isEmpty);
    });

    test('should return null for invalid ids', () {
      final country = GeographicService.instance.getCountryById('INVALID');
      final state = GeographicService.instance.getStateById('INVALID', 'INVALID');
      final city = GeographicService.instance.getCityById('INVALID', 'INVALID', 'INVALID');

      expect(country, isNull);
      expect(state, isNull);
      expect(city, isNull);
    });
  });

  group('Storage Service Tests', () {
    setUp(() async {
      // Initialize storage service for each test
      await StorageService.instance.init();
      await StorageService.instance.clearAllUsers();
    });

    test('should save and retrieve user correctly', () async {
      final user = User(
        id: 'test1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      await StorageService.instance.saveUser(user);
      final retrievedUser = await StorageService.instance.getUserById('test1');

      expect(retrievedUser, isNotNull);
      expect(retrievedUser!.id, user.id);
      expect(retrievedUser.firstName, user.firstName);
      expect(retrievedUser.lastName, user.lastName);
    });

    test('should update user correctly', () async {
      final user = User(
        id: 'test1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      await StorageService.instance.saveUser(user);

      final updatedUser = user.copyWith(firstName: 'Carlos');
      await StorageService.instance.updateUser(updatedUser);

      final retrievedUser = await StorageService.instance.getUserById('test1');
      expect(retrievedUser!.firstName, 'Carlos');
    });

    test('should delete user correctly', () async {
      final user = User(
        id: 'test1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      await StorageService.instance.saveUser(user);
      await StorageService.instance.deleteUser('test1');

      final retrievedUser = await StorageService.instance.getUserById('test1');
      expect(retrievedUser, isNull);
    });

    test('should retrieve all users correctly', () async {
      final user1 = User(
        id: 'test1',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      final user2 = User(
        id: 'test2',
        firstName: 'Ana',
        lastName: 'Rodriguez',
        birthDate: DateTime(1985, 3, 20),
        addresses: [],
      );

      await StorageService.instance.saveUser(user1);
      await StorageService.instance.saveUser(user2);

      final users = await StorageService.instance.getAllUsers();
      expect(users.length, 2);
      expect(users.any((u) => u.id == 'test1'), isTrue);
      expect(users.any((u) => u.id == 'test2'), isTrue);
    });

    test('should handle user not found gracefully', () async {
      final retrievedUser = await StorageService.instance.getUserById('nonexistent');
      expect(retrievedUser, isNull);
    });

    test('should prevent duplicate user IDs', () async {
      final user1 = User(
        id: 'duplicate',
        firstName: 'Luis',
        lastName: 'Gomez',
        birthDate: DateTime(1990, 5, 15),
        addresses: [],
      );

      final user2 = User(
        id: 'duplicate',
        firstName: 'Ana',
        lastName: 'Rodriguez',
        birthDate: DateTime(1985, 3, 20),
        addresses: [],
      );

      await StorageService.instance.saveUser(user1);

      // This should throw an exception or handle the duplicate gracefully
      expect(
        () => StorageService.instance.saveUser(user2),
        throwsA(isA<Exception>()),
      );
    });
  });
}
