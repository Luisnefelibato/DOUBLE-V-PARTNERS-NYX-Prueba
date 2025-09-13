import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final List<Address> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calcula la edad del usuario
  int get age {
    final now = DateTime.now();
    final birthYear = birthDate.year;
    final currentYear = now.year;
    int age = currentYear - birthYear;

    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Obtiene el nombre completo
  String get fullName => '$firstName $lastName';

  /// Obtiene la dirección principal (primera en la lista)
  Address? get primaryAddress => addresses.isNotEmpty ? addresses.first : null;

  /// Valida si el usuario tiene todos los datos requeridos
  bool get isValid {
    return firstName.isNotEmpty &&
           lastName.isNotEmpty &&
           birthDate.isBefore(DateTime.now()) &&
           addresses.isNotEmpty;
  }

  /// Crea una copia del usuario con nuevos valores
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DateTime? birthDate,
    List<Address>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Añade una nueva dirección
  User addAddress(Address address) {
    final updatedAddresses = List<Address>.from(addresses)..add(address);
    return copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );
  }

  /// Actualiza una dirección existente
  User updateAddress(String addressId, Address updatedAddress) {
    final addressIndex = addresses.indexWhere((a) => a.id == addressId);
    if (addressIndex == -1) return this;

    final updatedAddresses = List<Address>.from(addresses);
    updatedAddresses[addressIndex] = updatedAddress;

    return copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );
  }

  /// Elimina una dirección
  User removeAddress(String addressId) {
    final updatedAddresses = addresses.where((a) => a.id != addressId).toList();
    return copyWith(
      addresses: updatedAddresses,
      updatedAt: DateTime.now(),
    );
  }

  // JSON serialization
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          birthDate == other.birthDate;

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      birthDate.hashCode;

  @override
  String toString() {
    return 'User{id: $id, fullName: $fullName, age: $age, addresses: ${addresses.length}}';
  }
}

@JsonSerializable()
class Address {
  final String id;
  final String country;
  final String state; // Departamento
  final String city; // Municipio
  final String streetAddress;
  final String? zipCode;
  final bool isPrimary;
  final DateTime createdAt;

  const Address({
    required this.id,
    required this.country,
    required this.state,
    required this.city,
    required this.streetAddress,
    this.zipCode,
    this.isPrimary = false,
    required this.createdAt,
  });

  /// Obtiene la dirección completa formateada
  String get fullAddress {
    final parts = <String>[
      streetAddress,
      city,
      state,
      country,
    ];

    if (zipCode != null && zipCode!.isNotEmpty) {
      parts.insert(parts.length - 1, zipCode!);
    }

    return parts.join(', ');
  }

  /// Valida si la dirección tiene todos los campos requeridos
  bool get isValid {
    return country.isNotEmpty &&
           state.isNotEmpty &&
           city.isNotEmpty &&
           streetAddress.isNotEmpty;
  }

  /// Crea una copia de la dirección con nuevos valores
  Address copyWith({
    String? id,
    String? country,
    String? state,
    String? city,
    String? streetAddress,
    String? zipCode,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return Address(
      id: id ?? this.id,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
      zipCode: zipCode ?? this.zipCode,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // JSON serialization
  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          country == other.country &&
          state == other.state &&
          city == other.city &&
          streetAddress == other.streetAddress;

  @override
  int get hashCode =>
      id.hashCode ^
      country.hashCode ^
      state.hashCode ^
      city.hashCode ^
      streetAddress.hashCode;

  @override
  String toString() {
    return 'Address{id: $id, fullAddress: $fullAddress, isPrimary: $isPrimary}';
  }
}
