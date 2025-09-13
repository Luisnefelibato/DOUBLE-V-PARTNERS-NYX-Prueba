import 'package:flutter/material.dart';

/// Paleta de colores cyberpunk inspirada en el logo de Double V Partners NYX
class CyberpunkColors {
  // Colores primarios del logo
  static const Color primaryPurple = Color(0xFF8B5FBF);    // Púrpura principal
  static const Color primaryMagenta = Color(0xFFE91E63);   // Magenta vibrante
  static const Color darkBackground = Color(0xFF0D1117);   // Negro de fondo
  static const Color darkSurface = Color(0xFF161B22);      // Superficie oscura

  // Gradientes cyberpunk
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryMagenta],
    stops: [0.0, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
    stops: [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Colores de estado
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Colores de texto
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3);
  static const Color textMuted = Color(0xFF6B7280);

  // Colores de borde y elementos UI
  static const Color border = Color(0xFF30363D);
  static const Color borderActive = primaryMagenta;
  static const Color shadow = Color(0x40000000);

  // Efectos de glow/neón
  static const Color glowPurple = Color(0xFF8B5FBF);
  static const Color glowMagenta = Color(0xFFE91E63);
  static const Color glowCyan = Color(0xFF06B6D4);
}

/// Tema oscuro cyberpunk personalizado
class CyberpunkTheme {

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: CyberpunkColors.primaryPurple,
        secondary: CyberpunkColors.primaryMagenta,
        surface: CyberpunkColors.darkSurface,
        background: CyberpunkColors.darkBackground,
        error: CyberpunkColors.error,
        onPrimary: CyberpunkColors.textPrimary,
        onSecondary: CyberpunkColors.textPrimary,
        onSurface: CyberpunkColors.textPrimary,
        onBackground: CyberpunkColors.textPrimary,
        onError: CyberpunkColors.textPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: CyberpunkColors.darkBackground,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: CyberpunkColors.darkSurface,
        foregroundColor: CyberpunkColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
      ),

      // Cards
      cardTheme: CardTheme(
        color: CyberpunkColors.darkSurface,
        elevation: 8,
        shadowColor: CyberpunkColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: CyberpunkColors.border,
            width: 1,
          ),
        ),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: CyberpunkColors.textPrimary,
          backgroundColor: CyberpunkColors.primaryPurple,
          elevation: 8,
          shadowColor: CyberpunkColors.glowPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
          ),
        ),
      ),

      // Outlined buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CyberpunkColors.primaryMagenta,
          side: const BorderSide(
            color: CyberpunkColors.primaryMagenta,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Orbitron',
          ),
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: CyberpunkColors.primaryMagenta,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Orbitron',
          ),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CyberpunkColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CyberpunkColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CyberpunkColors.primaryMagenta,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CyberpunkColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: CyberpunkColors.error,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: CyberpunkColors.textSecondary,
          fontSize: 16,
          fontFamily: 'Orbitron',
        ),
        hintStyle: const TextStyle(
          color: CyberpunkColors.textMuted,
          fontSize: 14,
          fontFamily: 'Orbitron',
        ),
        errorStyle: const TextStyle(
          color: CyberpunkColors.error,
          fontSize: 12,
          fontFamily: 'Orbitron',
        ),
      ),

      // Typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
        displayMedium: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 28,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
        displaySmall: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
        headlineLarge: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          fontFamily: 'Orbitron',
        ),
        headlineMedium: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Orbitron',
        ),
        headlineSmall: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Orbitron',
        ),
        titleLarge: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Orbitron',
        ),
        titleMedium: TextStyle(
          color: CyberpunkColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Orbitron',
        ),
        titleSmall: TextStyle(
          color: CyberpunkColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Orbitron',
        ),
        bodyLarge: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: CyberpunkColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: CyberpunkColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),

      // Icons
      iconTheme: const IconThemeData(
        color: CyberpunkColors.textPrimary,
        size: 24,
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarTheme(
        backgroundColor: CyberpunkColors.darkSurface,
        selectedItemColor: CyberpunkColors.primaryMagenta,
        unselectedItemColor: CyberpunkColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: CyberpunkColors.primaryMagenta,
        foregroundColor: CyberpunkColors.textPrimary,
        elevation: 8,
        focusElevation: 12,
        hoverElevation: 10,
        highlightElevation: 16,
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: CyberpunkColors.border,
        thickness: 1,
      ),

      // Checkboxes
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CyberpunkColors.primaryMagenta;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(CyberpunkColors.textPrimary),
        side: const BorderSide(
          color: CyberpunkColors.border,
          width: 2,
        ),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CyberpunkColors.primaryMagenta;
          }
          return CyberpunkColors.textMuted;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return CyberpunkColors.primaryMagenta.withOpacity(0.3);
          }
          return CyberpunkColors.border;
        }),
      ),

      // Progress indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CyberpunkColors.primaryMagenta,
        linearTrackColor: CyberpunkColors.border,
        circularTrackColor: CyberpunkColors.border,
      ),

      // Dialogs
      dialogTheme: DialogTheme(
        backgroundColor: CyberpunkColors.darkSurface,
        elevation: 16,
        shadowColor: CyberpunkColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: CyberpunkColors.border,
          ),
        ),
        titleTextStyle: const TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Orbitron',
        ),
        contentTextStyle: const TextStyle(
          color: CyberpunkColors.textSecondary,
          fontSize: 16,
        ),
      ),

      // SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: CyberpunkColors.darkSurface,
        contentTextStyle: TextStyle(
          color: CyberpunkColors.textPrimary,
          fontSize: 14,
        ),
        actionTextColor: CyberpunkColors.primaryMagenta,
        elevation: 8,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  /// Tema claro (opcional, manteniendo los colores cyberpunk)
  static ThemeData get lightTheme {
    return darkTheme.copyWith(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: darkTheme.colorScheme.copyWith(
        brightness: Brightness.light,
        surface: Colors.white,
        background: const Color(0xFFF8FAFC),
        onSurface: const Color(0xFF1F2937),
        onBackground: const Color(0xFF1F2937),
      ),
    );
  }
}

/// Extensiones para efectos visuales
extension CyberpunkEffects on Widget {

  /// Añade un efecto de glow/neón al widget
  Widget withGlow({
    Color glowColor = CyberpunkColors.glowPurple,
    double blurRadius = 20.0,
    double spreadRadius = 2.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.5),
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: this,
    );
  }

  /// Añade un borde con gradiente
  Widget withGradientBorder({
    Gradient gradient = CyberpunkColors.primaryGradient,
    double width = 2.0,
    double radius = 8.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(width),
      child: Container(
        decoration: BoxDecoration(
          color: CyberpunkColors.darkSurface,
          borderRadius: BorderRadius.circular(radius - width),
        ),
        child: this,
      ),
    );
  }

  /// Añade un fondo con gradiente
  Widget withGradientBackground({
    Gradient gradient = CyberpunkColors.primaryGradient,
    double radius = 8.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: this,
    );
  }
}
