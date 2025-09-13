# Double V Partners NYX - User Management App

## 🚀 Prueba Técnica Flutter - Luis Gomez

Una aplicación Flutter profesional para gestión de usuarios con diseño cyberpunk, desarrollada como prueba técnica para **Double V Partners NYX**.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Provider](https://img.shields.io/badge/Provider-FF6B35?style=for-the-badge&logo=flutter&logoColor=white)

## ✨ Características Principales

### 📱 Funcionalidades Core
- ✅ **Gestión de Usuarios**: Crear, editar, eliminar y listar usuarios
- ✅ **Sistema de Direcciones**: Múltiples direcciones por usuario con datos geográficos
- ✅ **Validaciones Robustas**: Control de errores y validación de datos en tiempo real
- ✅ **Persistencia Local**: Almacenamiento con SharedPreferences
- ✅ **Navegación Completa**: 5+ pantallas interconectadas

### 🎨 Diseño y UX
- 🎯 **Tema Cyberpunk**: Colores púrpura/magenta con efectos visuales
- ⚡ **Animaciones Fluidas**: Transiciones y efectos con flutter_animate
- 🌊 **Responsive Design**: Adaptable a diferentes tamaños de pantalla
- 🎨 **Widgets Personalizados**: Componentes reutilizables con diseño consistente

### 🏗️ Arquitectura Técnica
- 🔧 **Patrón Provider**: Manejo de estado reactivo
- 📦 **Principios SOLID**: Código mantenible y escalable
- 🧪 **Testing Completo**: 25+ tests unitarios con cobertura amplia
- 🛡️ **Manejo de Errores**: Sistema robusto de control de errores
- 🌍 **Datos Geográficos**: Servicio completo para Colombia, US y México

## 📱 Pantallas Implementadas

### 1. 🌟 Splash Screen
- Animación de logo con efectos cyberpunk
- Partículas flotantes y gradientes
- Transición automática al home

### 2. 🏠 Home Screen  
- Dashboard principal con navegación
- Estadísticas de usuarios en tiempo real
- Grid de menús animados
- Acciones rápidas

### 3. 👥 User List Screen
- Lista completa de usuarios con búsqueda
- Avatares personalizados y información clave
- Acciones de editar/eliminar con confirmación
- Pull-to-refresh y estados vacíos

### 4. 👤 User Form Screen
- Formulario completo para crear/editar usuarios
- Validación de nombres y fecha de nacimiento
- Selector de fecha personalizado
- Estados de carga y error

### 5. 📍 Address Management Screen
- Gestión de múltiples direcciones por usuario
- Dropdowns geográficos (País → Estado → Ciudad)
- Datos reales de Colombia, Estados Unidos y México
- Validaciones y confirmaciones

### 6. 👤 User Profile Screen
- Vista detallada con SliverAppBar animado
- Información personal y estadísticas
- Lista expandible de direcciones
- Navegación directa a edición

## 🛠️ Tecnologías Utilizadas

### Framework y Lenguaje
- **Flutter 3.24+**: Framework multiplataforma
- **Dart 3.5+**: Lenguaje de programación

### Dependencias Principales
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2              # Manejo de estado
  shared_preferences: ^2.2.3    # Persistencia local
  flutter_animate: ^4.5.0       # Animaciones avanzadas

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

### Arquitectura y Patrones
- **Provider Pattern**: Manejo de estado reactivo
- **Repository Pattern**: Abstracción de datos
- **SOLID Principles**: Diseño orientado a objetos
- **Clean Architecture**: Separación de responsabilidades

## 🚀 Instalación y Configuración

### Prerrequisitos
- Flutter SDK 3.24.0 o superior
- Dart SDK 3.5.0 o superior
- Android Studio / VS Code
- Git

### Pasos de Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/Luisnefelibato/DOUBLE-V-PARTNERS-NYX-Prueba.git
cd DOUBLE V PARTNERS NYX Prueba
```

2. **Instalar dependencias**
```bash
flutter pub get
```

3. **Verificar configuración**
```bash
flutter doctor
```

4. **Ejecutar la aplicación**
```bash
# En modo debug
flutter run

# En modo release
flutter run --release
```

### Ejecutar Tests
```bash
# Todos los tests
flutter test

# Tests específicos
flutter test test/app_test.dart

# Con cobertura
flutter test --coverage
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                     # Punto de entrada de la app
├── models/                       # Modelos de datos
│   ├── user_model.dart          # Usuario y Dirección
│   └── error_model.dart         # Manejo de errores
├── providers/                    # Manejo de estado
│   └── app_provider.dart        # Providers principales
├── services/                     # Servicios de datos
│   ├── storage_service.dart     # Persistencia local
│   └── geographic_service.dart  # Datos geográficos
├── theme/                        # Configuración de UI
│   └── cyberpunk_theme.dart     # Tema personalizado
├── widgets/                      # Componentes reutilizables
│   └── cyberpunk_widgets.dart   # Widgets personalizados
└── screens/                      # Pantallas de la app
    ├── splash_screen.dart       # Pantalla de carga
    ├── home_screen.dart         # Dashboard principal
    ├── user_list_screen.dart    # Lista de usuarios
    ├── user_form_screen.dart    # Formulario de usuario
    ├── address_management_screen.dart # Gestión de direcciones
    └── user_profile_screen.dart # Perfil detallado

test/
└── app_test.dart                # Tests unitarios completos
```

## 🎨 Diseño Cyberpunk

### Paleta de Colores
- **Primario**: `#8B5FBF` (Púrpura)
- **Secundario**: `#E91E63` (Magenta)
- **Fondo**: `#0D1117` (Negro profundo)
- **Superficie**: `#1C1C1E` (Gris oscuro)

### Efectos Visuales
- Gradientes dinámicos
- Efectos de brillo (glow)
- Partículas animadas
- Bordes luminosos
- Animaciones secuenciales

### Tipografía
- **Orbitron**: Fuente futurista para títulos
- **System Fonts**: Fuentes del sistema para contenido

## 🧪 Testing y Calidad

### Cobertura de Tests
- **User Model**: Validación, JSON, métodos utilitarios
- **Address Model**: Formato, validación, serialización
- **Error Handling**: Tipos de error y manejo
- **Geographic Service**: Datos geográficos y búsqueda
- **Storage Service**: CRUD completo y persistencia
- **Edge Cases**: Casos límite y manejo de errores

### Métricas de Calidad
- ✅ 25+ casos de prueba implementados
- ✅ Cobertura de modelos y servicios principales
- ✅ Validación de casos edge y errores
- ✅ Tests de integración para servicios

## 📋 Funcionalidades Implementadas

### ✅ Requerimientos Cumplidos
- [x] Formulario de usuario (Nombre, Apellido, Fecha de Nacimiento)
- [x] Sistema de direcciones (País, Departamento, Municipio)
- [x] Múltiples direcciones por usuario
- [x] Mínimo 3 pantallas (implementadas 6)
- [x] Control de errores y estados
- [x] Visualización de datos del usuario
- [x] Buenas prácticas de desarrollo
- [x] Principios SOLID aplicados
- [x] Tests unitarios implementados

### 🚀 Funcionalidades Adicionales
- [x] Diseño cyberpunk personalizado
- [x] Animaciones y efectos visuales
- [x] Búsqueda y filtrado de usuarios
- [x] Navegación completa entre pantallas
- [x] Estados de carga y vacío
- [x] Validaciones en tiempo real
- [x] Datos geográficos reales
- [x] Manejo robusto de errores

## 🔧 Configuraciones Adicionales

### Android (android/app/build.gradle)
```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### iOS (ios/Runner/Info.plist)
```xml
<key>CFBundleDisplayName</key>
<string>Double V Partners NYX</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
```

## 📱 Capturas de Pantalla

> **Nota**: Las capturas de pantalla muestran el diseño cyberpunk implementado con los colores púrpura y magenta especificados.

1. **Splash Screen**: Logo animado con efectos de partículas
2. **Home Screen**: Dashboard con navegación y estadísticas  
3. **User List**: Lista completa con búsqueda y acciones
4. **User Form**: Formulario validado con selector de fecha
5. **Address Management**: Gestión de direcciones con dropdowns
6. **User Profile**: Vista detallada con información completa

## 🚀 Próximos Pasos

### Mejoras Potenciales
- [ ] Integración con APIs externas
- [ ] Sincronización en la nube
- [ ] Notificaciones push
- [ ] Modo offline robusto
- [ ] Métricas y analytics
- [ ] Internacionalización (i18n)

### Escalabilidad
- [ ] Arquitectura modular por features
- [ ] Inyección de dependencias
- [ ] Cache inteligente
- [ ] Performance optimization
- [ ] CI/CD pipeline

## 👨‍💻 Desarrollador

**Luis Gomez**  
Desarrollador Flutter Full Stack

---

## 📄 Licencia

Este proyecto fue desarrollado como prueba técnica para Double V Partners NYX.

---

## 🙏 Agradecimientos

Gracias a **Double V Partners NYX** por la oportunidad de demostrar mis habilidades técnicas y creatividad en este desafío. El diseño cyberpunk fue inspirado en el logo proporcionado, creando una experiencia visual única y profesional.

---

*Desarrollado con ❤️ usando Flutter para Double V Partners NYX*
