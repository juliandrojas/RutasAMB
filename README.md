# Rutas AMB 🚌

Tu guía definitiva de transporte en el Área Metropolitana de Bucaramanga. Esta aplicación móvil te permite trazar rutas óptimas entre cualquier punto de la ciudad, ofreciendo opciones directas y con transbordos usando datos oficiales.

## ✨ Características

- 📍 **Algoritmo de Rutas Inteligente:** Calcula la ruta óptima de transporte público utilizando distancia de caminata y detección de transbordos.
- 🗺️ **Integración con Google Maps:** Visualización fluida de los trazados de las rutas (polylines) y paradas exactas.
- 🌙 **Material 3 (Claro/Oscuro):** Diseño moderno, vibrante y premium con Micro-Animaciones.
- 🏛️ **Clean Architecture:** Proyecto completamente desacoplado (Domain, Data, Presentation) listo para escalar.
- ⚡ **Riverpod & GoRouter:** Gestión de estado reactiva y enrutamiento seguro y moderno.
- ⭐ **Favoritos e Historial:** Guarda tus rutas diarias y busca rápidamente sin conexión gracias a SharedPreferences/Hive.

## 📱 Pantallas Principales

1. **Splash Screen:** Pantalla de carga animada de entrada.
2. **Home Screen:** Mapa inicial interactivo con la ubicación actual del usuario.
3. **Buscador (Google-Style):** Autocompletado inteligente de ubicaciones clave en Bucaramanga.
4. **Resultados:** Sugerencias filtrables (Directas, 1 transbordo) con métricas de tiempo de caminata.
5. **Detalle de Ruta:** Bottom Sheet deslizable con horario, recorrido textual y paradas visualizadas en el mapa.
6. **Favoritos & Configuración:** Interfaz para cambiar de tema y administrar rutas guardadas con "Swipe-to-delete".

## 🚀 Instalación y Uso

### 1. Prerrequisitos
Asegúrate de tener instalado:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (versión 3.3.0 o superior)
- Dart SDK
- Android Studio o VS Code con plugins de Flutter

### 2. Configurar la API Key de Google Maps
Para que el mapa se renderice correctamente, necesitas una API Key de Google Maps habilitada para Android.

1. Ve a [Google Cloud Console](https://console.cloud.google.com/).
2. Crea un proyecto y habilita el "Maps SDK for Android".
3. Genera una API Key.
4. En este proyecto, abre `android/app/src/main/AndroidManifest.xml`.
5. Busca el siguiente bloque y reemplaza `YOUR_GOOGLE_MAPS_API_KEY` por tu clave real:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AQUI_VA_TU_CLAVE"/>
```

### 3. Compilar el proyecto

Abre una terminal en la raíz del proyecto y ejecuta:

```bash
# Descargar todas las dependencias
flutter pub get

# Generar iconos de la aplicación (si has cambiado assets/icon.png)
dart run flutter_launcher_icons

# Compilar y correr en tu dispositivo / emulador
flutter run
```

## 🏗️ Arquitectura e Integración con Backend

El proyecto está diseñado pensando en que en un futuro muy cercano, los datos provengan de un backend en `Node.js + PostgreSQL` en lugar de archivos fijos.

Para integrar tu API REST:
1. Crea una clase `RemoteRoutesDatasourceImpl` que implemente la interfaz `RoutesDatasource` usando el cliente `DioClient` (ubicado en `core/network/dio_client.dart`).
2. Ve al archivo `lib/core/di/injection_container.dart`.
3. Cambia el provider para que retorne tu nueva clase remota en lugar de la local:
```dart
final routesDatasourceProvider = Provider<RoutesDatasource>((ref) {
  return RemoteRoutesDatasourceImpl(dio: ref.read(dioClientProvider)); 
  // En lugar de MockRoutesDatasource()
});
```
**¡Y listo!** La interfaz de usuario, los casos de uso y la lógica de negocio no necesitan ser modificados en absoluto.

## 📦 Dependencias Destacadas

*   [flutter_riverpod](https://pub.dev/packages/flutter_riverpod): ^2.4.9
*   [go_router](https://pub.dev/packages/go_router): ^13.1.0
*   [dio](https://pub.dev/packages/dio): ^5.4.0
*   [google_maps_flutter](https://pub.dev/packages/google_maps_flutter): ^2.5.3
*   [geolocator](https://pub.dev/packages/geolocator): ^10.1.0

## 📄 Licencia

Este proyecto es para uso de movilidad en el Área Metropolitana de Bucaramanga.
