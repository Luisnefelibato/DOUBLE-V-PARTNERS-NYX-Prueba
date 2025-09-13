/// Enumeración de tipos de errores de la aplicación
enum ErrorType {
  validation,
  network,
  storage,
  unknown,
}

/// Modelo para manejar errores de manera consistente
class AppError {
  final ErrorType type;
  final String message;
  final String? details;
  final DateTime timestamp;

  const AppError({
    required this.type,
    required this.message,
    this.details,
    required this.timestamp,
  });

  factory AppError.validation(String message, {String? details}) {
    return AppError(
      type: ErrorType.validation,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  factory AppError.network(String message, {String? details}) {
    return AppError(
      type: ErrorType.network,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  factory AppError.storage(String message, {String? details}) {
    return AppError(
      type: ErrorType.storage,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  factory AppError.unknown(String message, {String? details}) {
    return AppError(
      type: ErrorType.unknown,
      message: message,
      details: details,
      timestamp: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'AppError{type: $type, message: $message, details: $details}';
  }
}

/// Estado de resultado que puede contener datos o error
class Result<T> {
  final T? data;
  final AppError? error;
  final bool isLoading;

  const Result._({
    this.data,
    this.error,
    this.isLoading = false,
  });

  /// Constructor para estado de éxito
  const Result.success(T data) : this._(data: data);

  /// Constructor para estado de error
  const Result.error(AppError error) : this._(error: error);

  /// Constructor para estado de carga
  const Result.loading() : this._(isLoading: true);

  /// Verifica si el resultado es exitoso
  bool get isSuccess => data != null && error == null && !isLoading;

  /// Verifica si hay un error
  bool get isError => error != null;

  /// Ejecuta una función si el resultado es exitoso
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess) {
      try {
        return Result.success(transform(data!));
      } catch (e) {
        return Result.error(AppError.unknown(e.toString()));
      }
    } else if (isError) {
      return Result.error(error!);
    } else {
      return const Result.loading();
    }
  }

  /// Ejecuta una función asíncrona si el resultado es exitoso
  Future<Result<R>> mapAsync<R>(Future<R> Function(T data) transform) async {
    if (isSuccess) {
      try {
        final result = await transform(data!);
        return Result.success(result);
      } catch (e) {
        return Result.error(AppError.unknown(e.toString()));
      }
    } else if (isError) {
      return Result.error(error!);
    } else {
      return const Result.loading();
    }
  }

  @override
  String toString() {
    if (isLoading) return 'Result.loading()';
    if (isError) return 'Result.error($error)';
    return 'Result.success($data)';
  }
}
