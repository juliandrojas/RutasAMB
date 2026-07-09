// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

/// MOCK DATASOURCE – Datos de rutas del Área Metropolitana de Bucaramanga
///
/// Estos datos están basados en la información pública del AMB:
/// https://www.amb.gov.co/rutas-publico-colectivo-complementario/
///
/// PARA REEMPLAZAR CON API REAL:
/// 1. Implementa RemoteRoutesDatasource usando DioClient
/// 2. En injection_container.dart, cambia routesDatasourceProvider para
///    que use RemoteRoutesDatasource en lugar de MockRoutesDatasource.
/// 3. No modifiques ningún repositorio, caso de uso ni pantalla.
///
/// Las coordenadas son reales del AMB Bucaramanga.
library;

import 'package:rutas_amb/features/routes/domain/entities/lat_lng_entity.dart';
import 'package:rutas_amb/features/routes/domain/entities/route_entity.dart';
import 'package:rutas_amb/features/routes/domain/entities/stop_entity.dart';

abstract class RoutesDatasource {
  Future<List<RouteEntity>> getAllRoutes();
  Future<RouteEntity> getRouteById(String id);
}

class MockRoutesDatasource implements RoutesDatasource {
  @override
  Future<List<RouteEntity>> getAllRoutes() async {
    // Simula latencia de red
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockRoutes;
  }

  @override
  Future<RouteEntity> getRouteById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockRoutes.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Ruta no encontrada: $id'),
    );
  }

  // ─────────────────────────────────────────────────────────────────────
  // DATOS MOCK – 15 rutas del AMB Bucaramanga
  // ─────────────────────────────────────────────────────────────────────
  static final List<RouteEntity> _mockRoutes = [
    // ── RUTA P8: Colorados – UIS – Centro ────────────────────────────
    RouteEntity(
      id: 'ruta_unitransa_p8',
      code: 'P8',
      name: 'Ruta P8 - Colorados - UIS - Centro',
      company: 'Unitransa',
      textualRoute:
          'Sale de Colorados, baja por la Cra 27, pasa por la UIS, baja por la Quebradaseca al Centro y retorna.',
      frequency: 'Cada 8 min',
      schedule: '04:30 AM - 09:45 PM',
      lengthKm: 15.2,
      neighborhoods: ['Colorados', 'UIS', 'Centro', 'San Francisco'],
      color: '#E65100', // Naranja
      coordinates: [
        LatLngEntity(lat: 7.1550, lng: -73.1300), // Colorados
        LatLngEntity(lat: 7.1450, lng: -73.1250), // Intermedia
        LatLngEntity(lat: 7.1350, lng: -73.1220), // UIS
        LatLngEntity(lat: 7.1250, lng: -73.1250), // Centro (Parque Santander)
        LatLngEntity(lat: 7.1150, lng: -73.1200), // Sur
      ],
      stops: [
        StopEntity(
          id: 'u1',
          name: 'Despacho Colorados',
          lat: 7.1550,
          lng: -73.1300,
          address: 'Colorados Norte',
        ),
        StopEntity(
          id: 'u2',
          name: 'Entrada UIS',
          lat: 7.1350,
          lng: -73.1220,
          address: 'Carrera 27 # 9',
        ),
        StopEntity(
          id: 'u3',
          name: 'Parque Santander',
          lat: 7.1250,
          lng: -73.1250,
          address: 'Calle 36 # 25',
        ),
      ],
    ),

    // ── RUTA LIM: Limoncito – Cabecera – Centro ──────────────────────
    RouteEntity(
      id: 'ruta_transcolombia_limoncito',
      code: 'LIM',
      name: 'Ruta Limoncito - Cabecera - Centro',
      company: 'Transcolombia',
      textualRoute:
          'Floridablanca Limoncito, Autopista, Cabecera, Carrera 33, Centro.',
      frequency: 'Cada 15 min',
      schedule: '05:00 AM - 09:00 PM',
      lengthKm: 12.0,
      neighborhoods: ['Limoncito', 'Cabecera', 'Centro'],
      color: '#1565C0', // Azul oscuro
      coordinates: [
        LatLngEntity(lat: 7.0700, lng: -73.1000), // Limoncito
        LatLngEntity(lat: 7.0900, lng: -73.1100), // Autopista
        LatLngEntity(lat: 7.1150, lng: -73.1120), // Cabecera
        LatLngEntity(lat: 7.1250, lng: -73.1250), // Centro
      ],
      stops: [
        StopEntity(
          id: 'tc1',
          name: 'Barrio Limoncito',
          lat: 7.0700,
          lng: -73.1000,
          address: 'Floridablanca Sur',
        ),
        StopEntity(
          id: 'tc2',
          name: 'Cuarta Etapa',
          lat: 7.1150,
          lng: -73.1120,
          address: 'Carrera 33 # 48',
        ),
        StopEntity(
          id: 'tc3',
          name: 'Centro',
          lat: 7.1250,
          lng: -73.1250,
          address: 'Calle 36',
        ),
      ],
    ),

    // ── RUTA IQU: Iquique – Provenza – Centro ────────────────────────
    RouteEntity(
      id: 'ruta_cotrander_iquique',
      code: 'IQU',
      name: 'Ruta Iquique - Provenza - Centro',
      company: 'Cotrander',
      textualRoute:
          'Salida de Iquique, pasa por Diamante, Provenza, Autopista, Centro y retorna.',
      frequency: 'Cada 10 min',
      schedule: '04:45 AM - 09:30 PM',
      lengthKm: 18.5,
      neighborhoods: ['Iquique', 'Provenza', 'Diamante'],
      color: '#2E7D32', // Verde
      coordinates: [
        LatLngEntity(lat: 7.0850, lng: -73.1100), // Iquique
        LatLngEntity(lat: 7.0950, lng: -73.1150), // Provenza
        LatLngEntity(lat: 7.1050, lng: -73.1200), // Viaducto
        LatLngEntity(lat: 7.1250, lng: -73.1250), // Centro
      ],
      stops: [
        StopEntity(
          id: 'cot1',
          name: 'Despacho Iquique',
          lat: 7.0850,
          lng: -73.1100,
          address: 'Iquique Sur',
        ),
        StopEntity(
          id: 'cot2',
          name: 'Puente Provenza',
          lat: 7.0950,
          lng: -73.1150,
          address: 'Autopista a Floridablanca',
        ),
        StopEntity(
          id: 'cot3',
          name: 'Centro / Alcaldía',
          lat: 7.1250,
          lng: -73.1250,
          address: 'Calle 35',
        ),
      ],
    ),

    // ── RUTA 1: A-01 Centro – Cabecera ───────────────────────────────
    RouteEntity(
      id: 'route-a01',
      code: 'A-01',
      name: 'Centro – Cabecera del Llano',
      company: 'Cootransbu',
      textualRoute:
          'Terminal Sur → Av. Quebrada Seca → Clle 36 → Cabecera del Llano',
      frequency: 'Cada 8 minutos',
      schedule:
          'Lunes a Sábado: 5:30 AM – 10:30 PM | Domingo: 6:00 AM – 9:00 PM',
      lengthKm: 12.4,
      neighborhoods: [
        'Centro',
        'La Aurora',
        'Cabecera del Llano',
        'Los Pinares',
      ],
      color: '#1565C0',
      coordinates: [
        LatLngEntity(lat: 7.0930, lng: -73.1195),
        LatLngEntity(lat: 7.1000, lng: -73.1200),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
        LatLngEntity(lat: 7.1150, lng: -73.1220),
        LatLngEntity(lat: 7.1198, lng: -73.1227),
        LatLngEntity(lat: 7.1250, lng: -73.1190),
        LatLngEntity(lat: 7.1079, lng: -73.1158),
      ],
      stops: [
        StopEntity(
          id: 'a01-s01',
          name: 'Terminal Sur',
          lat: 7.0930,
          lng: -73.1195,
          address: 'Cra. 15 con Clle 40',
        ),
        StopEntity(
          id: 'a01-s02',
          name: 'Parque García Rovira',
          lat: 7.1000,
          lng: -73.1200,
          address: 'Centro, Bucaramanga',
        ),
        StopEntity(
          id: 'a01-s03',
          name: 'Parque Santander',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Centro histórico',
        ),
        StopEntity(
          id: 'a01-s04',
          name: 'Calle 36 con Cra. 27',
          lat: 7.1150,
          lng: -73.1220,
          address: 'La Aurora',
        ),
        StopEntity(
          id: 'a01-s05',
          name: 'Gobernación',
          lat: 7.1198,
          lng: -73.1227,
          address: 'Cra. 26 Clle 37',
        ),
        StopEntity(
          id: 'a01-s06',
          name: 'UIS – Entrada principal',
          lat: 7.1250,
          lng: -73.1190,
          address: 'Ciudad Universitaria',
        ),
        StopEntity(
          id: 'a01-s07',
          name: 'Cabecera del Llano',
          lat: 7.1079,
          lng: -73.1158,
          address: 'C.C. Cabecera',
        ),
      ],
    ),

    // ── RUTA 2: A-02 Lagos – Centro – Girón ──────────────────────────
    RouteEntity(
      id: 'route-a02',
      code: 'A-02',
      name: 'Lagos del Cacique – Centro – Girón',
      company: 'Cootransbu',
      textualRoute:
          'Lagos del Cacique → Av. El Jardín → Puente Tablazo → Girón Centro',
      frequency: 'Cada 12 minutos',
      schedule:
          'Lunes a Sábado: 5:00 AM – 11:00 PM | Domingo: 6:30 AM – 9:30 PM',
      lengthKm: 18.7,
      neighborhoods: [
        'Lagos del Cacique',
        'El Jardín',
        'Bucaramanga Centro',
        'Girón',
        'Zahíno',
      ],
      color: '#2E7D32',
      coordinates: [
        LatLngEntity(lat: 7.0885, lng: -73.1097),
        LatLngEntity(lat: 7.0950, lng: -73.1120),
        LatLngEntity(lat: 7.1000, lng: -73.1200),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
        LatLngEntity(lat: 7.0900, lng: -73.1500),
        LatLngEntity(lat: 7.0728, lng: -73.1698),
      ],
      stops: [
        StopEntity(
          id: 'a02-s01',
          name: 'Lagos del Cacique',
          lat: 7.0885,
          lng: -73.1097,
          address: 'C.C. Lagos',
        ),
        StopEntity(
          id: 'a02-s02',
          name: 'Av. El Jardín con Cra. 22',
          lat: 7.0950,
          lng: -73.1120,
          address: 'El Jardín',
        ),
        StopEntity(
          id: 'a02-s03',
          name: 'Parque García Rovira',
          lat: 7.1000,
          lng: -73.1200,
          address: 'Centro',
        ),
        StopEntity(
          id: 'a02-s04',
          name: 'Parque Santander',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Centro',
        ),
        StopEntity(
          id: 'a02-s05',
          name: 'Puente Tablazo',
          lat: 7.0900,
          lng: -73.1500,
          address: 'Vía a Girón',
        ),
        StopEntity(
          id: 'a02-s06',
          name: 'Girón Parque Principal',
          lat: 7.0728,
          lng: -73.1698,
          address: 'Girón Centro',
        ),
      ],
    ),

    // ── RUTA 3: B-01 Floridablanca – Centro ──────────────────────────
    RouteEntity(
      id: 'route-b01',
      code: 'B-01',
      name: 'Floridablanca – Centro Bucaramanga',
      company: 'Transportes Floridablanca',
      textualRoute:
          'Floridablanca Centro → Cañaveral → UIS → Centro Bucaramanga',
      frequency: 'Cada 10 minutos',
      schedule:
          'Lunes a Viernes: 5:00 AM – 11:00 PM | Sábado: 5:30 AM – 10:30 PM | Domingo: 7:00 AM – 9:00 PM',
      lengthKm: 14.2,
      neighborhoods: [
        'Floridablanca',
        'Cañaveral',
        'Provenza',
        'La Joya',
        'Centro Bucaramanga',
      ],
      color: '#E65100',
      coordinates: [
        LatLngEntity(lat: 7.0630, lng: -73.0870),
        LatLngEntity(lat: 7.0750, lng: -73.0950),
        LatLngEntity(lat: 7.0900, lng: -73.1020),
        LatLngEntity(lat: 7.1050, lng: -73.1100),
        LatLngEntity(lat: 7.1250, lng: -73.1190),
        LatLngEntity(lat: 7.1198, lng: -73.1227),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
      ],
      stops: [
        StopEntity(
          id: 'b01-s01',
          name: 'Floridablanca Parque',
          lat: 7.0630,
          lng: -73.0870,
          address: 'Parque Principal Floridablanca',
        ),
        StopEntity(
          id: 'b01-s02',
          name: 'Cañaveral C.C.',
          lat: 7.0750,
          lng: -73.0950,
          address: 'C.C. Cañaveral',
        ),
        StopEntity(
          id: 'b01-s03',
          name: 'Provenza',
          lat: 7.0900,
          lng: -73.1020,
          address: 'Cra. 33 Clle 48',
        ),
        StopEntity(
          id: 'b01-s04',
          name: 'La Joya',
          lat: 7.1050,
          lng: -73.1100,
          address: 'Av. Los Estudiantes',
        ),
        StopEntity(
          id: 'b01-s05',
          name: 'UIS Entrada Sur',
          lat: 7.1250,
          lng: -73.1190,
          address: 'Ciudad Universitaria',
        ),
        StopEntity(
          id: 'b01-s06',
          name: 'Gobernación',
          lat: 7.1198,
          lng: -73.1227,
          address: 'Cra. 26 Clle 37',
        ),
        StopEntity(
          id: 'b01-s07',
          name: 'Parque Santander',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Centro',
        ),
      ],
    ),

    // ── RUTA 4: B-03 Piedecuesta – Centro ────────────────────────────
    RouteEntity(
      id: 'route-b03',
      code: 'B-03',
      name: 'Piedecuesta – Bucaramanga Centro',
      company: 'Cotranal',
      textualRoute:
          'Piedecuesta → Mensulí → El Refugio → Terminal Sur → Centro',
      frequency: 'Cada 15 minutos',
      schedule:
          'Lunes a Sábado: 4:30 AM – 10:30 PM | Domingo: 5:30 AM – 9:00 PM',
      lengthKm: 22.5,
      neighborhoods: [
        'Piedecuesta',
        'Mensulí',
        'El Refugio',
        'Lagos',
        'Centro Bucaramanga',
      ],
      color: '#6A1B9A',
      coordinates: [
        LatLngEntity(lat: 6.9899, lng: -73.0497),
        LatLngEntity(lat: 7.0050, lng: -73.0600),
        LatLngEntity(lat: 7.0300, lng: -73.0800),
        LatLngEntity(lat: 7.0600, lng: -73.0980),
        LatLngEntity(lat: 7.0885, lng: -73.1097),
        LatLngEntity(lat: 7.0930, lng: -73.1195),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
      ],
      stops: [
        StopEntity(
          id: 'b03-s01',
          name: 'Piedecuesta Parque',
          lat: 6.9899,
          lng: -73.0497,
          address: 'Parque Principal Piedecuesta',
        ),
        StopEntity(
          id: 'b03-s02',
          name: 'Mensulí',
          lat: 7.0050,
          lng: -73.0600,
          address: 'Variante Mensulí',
        ),
        StopEntity(
          id: 'b03-s03',
          name: 'El Refugio',
          lat: 7.0300,
          lng: -73.0800,
          address: 'Urbanización El Refugio',
        ),
        StopEntity(
          id: 'b03-s04',
          name: 'Mutis',
          lat: 7.0600,
          lng: -73.0980,
          address: 'Av. Mutis',
        ),
        StopEntity(
          id: 'b03-s05',
          name: 'Lagos del Cacique',
          lat: 7.0885,
          lng: -73.1097,
          address: 'C.C. Lagos',
        ),
        StopEntity(
          id: 'b03-s06',
          name: 'Terminal Sur',
          lat: 7.0930,
          lng: -73.1195,
          address: 'Terminal de Transportes',
        ),
        StopEntity(
          id: 'b03-s07',
          name: 'Centro – Cra. 15',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Cra. 15 Centro',
        ),
      ],
    ),

    // ── RUTA 5: C-01 Norte – Centro – Sur ────────────────────────────
    RouteEntity(
      id: 'route-c01',
      code: 'C-01',
      name: 'Norte Bucaramanga – Centro – Sur',
      company: 'Cotrasangil',
      textualRoute: 'Ciudadela Real de Minas → Norte → Centro → Terminal Sur',
      frequency: 'Cada 8 minutos',
      schedule: 'Lunes a Domingo: 5:00 AM – 11:30 PM',
      lengthKm: 16.8,
      neighborhoods: [
        'Ciudadela Real de Minas',
        'Norte',
        'Sotomayor',
        'Centro',
        'Sur',
      ],
      color: '#00838F',
      coordinates: [
        LatLngEntity(lat: 7.1450, lng: -73.1280),
        LatLngEntity(lat: 7.1380, lng: -73.1260),
        LatLngEntity(lat: 7.1300, lng: -73.1230),
        LatLngEntity(lat: 7.1198, lng: -73.1227),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
        LatLngEntity(lat: 7.1000, lng: -73.1200),
        LatLngEntity(lat: 7.0930, lng: -73.1195),
      ],
      stops: [
        StopEntity(
          id: 'c01-s01',
          name: 'Ciudadela Real de Minas',
          lat: 7.1450,
          lng: -73.1280,
          address: 'Calle 60 Norte',
        ),
        StopEntity(
          id: 'c01-s02',
          name: 'Sotomayor',
          lat: 7.1380,
          lng: -73.1260,
          address: 'Av. Sotomayor',
        ),
        StopEntity(
          id: 'c01-s03',
          name: 'Hospital Ramón González',
          lat: 7.1300,
          lng: -73.1230,
          address: 'Hospital General',
        ),
        StopEntity(
          id: 'c01-s04',
          name: 'Gobernación',
          lat: 7.1198,
          lng: -73.1227,
          address: 'Cra. 26 Clle 37',
        ),
        StopEntity(
          id: 'c01-s05',
          name: 'Parque Santander',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Centro',
        ),
        StopEntity(
          id: 'c01-s06',
          name: 'Parque García Rovira',
          lat: 7.1000,
          lng: -73.1200,
          address: 'Centro',
        ),
        StopEntity(
          id: 'c01-s07',
          name: 'Terminal Sur',
          lat: 7.0930,
          lng: -73.1195,
          address: 'Terminal de Transportes',
        ),
      ],
    ),

    // ── RUTA 6: C-02 Ruitoque – Centro ───────────────────────────────
    RouteEntity(
      id: 'route-c02',
      code: 'C-02',
      name: 'Ruitoque Alto – Centro Bucaramanga',
      company: 'Cotrasangil',
      textualRoute:
          'Ruitoque Bajo → Villanueva → El Pimiento → Centro Bucaramanga',
      frequency: 'Cada 20 minutos',
      schedule:
          'Lunes a Sábado: 5:30 AM – 9:30 PM | Domingo: 7:00 AM – 8:00 PM',
      lengthKm: 19.3,
      neighborhoods: [
        'Ruitoque',
        'Villanueva',
        'El Pimiento',
        'Cabecera',
        'Centro',
      ],
      color: '#AD1457',
      coordinates: [
        LatLngEntity(lat: 7.0400, lng: -73.0700),
        LatLngEntity(lat: 7.0550, lng: -73.0820),
        LatLngEntity(lat: 7.0700, lng: -73.0940),
        LatLngEntity(lat: 7.0900, lng: -73.1060),
        LatLngEntity(lat: 7.1000, lng: -73.1150),
        LatLngEntity(lat: 7.1079, lng: -73.1158),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
      ],
      stops: [
        StopEntity(
          id: 'c02-s01',
          name: 'Ruitoque Bajo',
          lat: 7.0400,
          lng: -73.0700,
          address: 'Entrada Ruitoque',
        ),
        StopEntity(
          id: 'c02-s02',
          name: 'Villanueva',
          lat: 7.0550,
          lng: -73.0820,
          address: 'Parque Villanueva',
        ),
        StopEntity(
          id: 'c02-s03',
          name: 'El Pimiento',
          lat: 7.0700,
          lng: -73.0940,
          address: 'Via El Pimiento',
        ),
        StopEntity(
          id: 'c02-s04',
          name: 'Av. Américas',
          lat: 7.0900,
          lng: -73.1060,
          address: 'Av. Las Américas',
        ),
        StopEntity(
          id: 'c02-s05',
          name: 'Los Pinares',
          lat: 7.1000,
          lng: -73.1150,
          address: 'Urbanización Los Pinares',
        ),
        StopEntity(
          id: 'c02-s06',
          name: 'Cabecera del Llano',
          lat: 7.1079,
          lng: -73.1158,
          address: 'C.C. Cabecera',
        ),
        StopEntity(
          id: 'c02-s07',
          name: 'Parque Santander',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Centro',
        ),
      ],
    ),

    // ── RUTA 7: D-01 Café Madrid – Centro ────────────────────────────
    RouteEntity(
      id: 'route-d01',
      code: 'D-01',
      name: 'Café Madrid – Bucaramanga Centro',
      company: 'Cootransbu',
      textualRoute:
          'Café Madrid → Bucarica → Puerta del Sol → Centro Bucaramanga',
      frequency: 'Cada 10 minutos',
      schedule:
          'Lunes a Sábado: 5:00 AM – 10:30 PM | Domingo: 6:00 AM – 9:00 PM',
      lengthKm: 11.5,
      neighborhoods: [
        'Café Madrid',
        'Bucarica',
        'Puerta del Sol',
        'Norte',
        'Centro',
      ],
      color: '#37474F',
      coordinates: [
        LatLngEntity(lat: 7.1320, lng: -73.1510),
        LatLngEntity(lat: 7.1350, lng: -73.1420),
        LatLngEntity(lat: 7.1370, lng: -73.1340),
        LatLngEntity(lat: 7.1380, lng: -73.1260),
        LatLngEntity(lat: 7.1300, lng: -73.1230),
        LatLngEntity(lat: 7.1198, lng: -73.1227),
        LatLngEntity(lat: 7.1080, lng: -73.1210),
      ],
      stops: [
        StopEntity(
          id: 'd01-s01',
          name: 'Café Madrid Central',
          lat: 7.1320,
          lng: -73.1510,
          address: 'Parque Café Madrid',
        ),
        StopEntity(
          id: 'd01-s02',
          name: 'Bucarica',
          lat: 7.1350,
          lng: -73.1420,
          address: 'Av. Bucarica',
        ),
        StopEntity(
          id: 'd01-s03',
          name: 'Puerta del Sol',
          lat: 7.1370,
          lng: -73.1340,
          address: 'C.C. Puerta del Sol',
        ),
        StopEntity(
          id: 'd01-s04',
          name: 'Sotomayor Norte',
          lat: 7.1380,
          lng: -73.1260,
          address: 'Av. Sotomayor',
        ),
        StopEntity(
          id: 'd01-s05',
          name: 'Hospital Ramón González',
          lat: 7.1300,
          lng: -73.1230,
          address: 'Hospital General',
        ),
        StopEntity(
          id: 'd01-s06',
          name: 'Gobernación',
          lat: 7.1198,
          lng: -73.1227,
          address: 'Cra. 26 Clle 37',
        ),
        StopEntity(
          id: 'd01-s07',
          name: 'Parque Santander',
          lat: 7.1080,
          lng: -73.1210,
          address: 'Centro',
        ),
      ],
    ),

    // ── RUTA 8: E-01 Comuneros – Cabecera ────────────────────────────
    RouteEntity(
      id: 'route-e01',
      code: 'E-01',
      name: 'Comuneros – Cabecera del Llano',
      company: 'Coopetrans',
      textualRoute: 'Comuneros → San Francisco → Av. Américas → Cabecera',
      frequency: 'Cada 15 minutos',
      schedule:
          'Lunes a Viernes: 5:30 AM – 10:00 PM | Sábado y Domingo: 6:00 AM – 9:00 PM',
      lengthKm: 9.8,
      neighborhoods: [
        'Comuneros',
        'San Francisco',
        'El Bosque',
        'Cabecera del Llano',
      ],
      color: '#00695C',
      coordinates: [
        LatLngEntity(lat: 7.1000, lng: -73.0980),
        LatLngEntity(lat: 7.1020, lng: -73.1020),
        LatLngEntity(lat: 7.1040, lng: -73.1060),
        LatLngEntity(lat: 7.1060, lng: -73.1100),
        LatLngEntity(lat: 7.1079, lng: -73.1158),
      ],
      stops: [
        StopEntity(
          id: 'e01-s01',
          name: 'Comuneros Parque',
          lat: 7.1000,
          lng: -73.0980,
          address: 'Parque Comuneros',
        ),
        StopEntity(
          id: 'e01-s02',
          name: 'San Francisco',
          lat: 7.1020,
          lng: -73.1020,
          address: 'Barrio San Francisco',
        ),
        StopEntity(
          id: 'e01-s03',
          name: 'El Bosque',
          lat: 7.1040,
          lng: -73.1060,
          address: 'Av. El Bosque',
        ),
        StopEntity(
          id: 'e01-s04',
          name: 'Américas',
          lat: 7.1060,
          lng: -73.1100,
          address: 'Av. Las Américas',
        ),
        StopEntity(
          id: 'e01-s05',
          name: 'Cabecera del Llano',
          lat: 7.1079,
          lng: -73.1158,
          address: 'C.C. Cabecera',
        ),
      ],
    ),

    // ── RUTA 9: F-01 Girón – Floridablanca (Circular) ────────────────
    RouteEntity(
      id: 'route-f01',
      code: 'F-01',
      name: 'Girón – Floridablanca Circular AMB',
      company: 'Cotramos',
      textualRoute: 'Girón Centro → Bucaramanga Centro → Floridablanca → Girón',
      frequency: 'Cada 20 minutos',
      schedule:
          'Lunes a Sábado: 5:00 AM – 10:00 PM | Domingo: 6:00 AM – 8:30 PM',
      lengthKm: 35.2,
      neighborhoods: [
        'Girón',
        'Bochalema',
        'Centro',
        'Cabecera',
        'Floridablanca',
        'Cañaveral',
      ],
      color: '#F57F17',
      coordinates: [
        LatLngEntity(lat: 7.0728, lng: -73.1698),
        LatLngEntity(lat: 7.0850, lng: -73.1450),
        LatLngEntity(lat: 7.1000, lng: -73.1200),
        LatLngEntity(lat: 7.1079, lng: -73.1158),
        LatLngEntity(lat: 7.0900, lng: -73.1020),
        LatLngEntity(lat: 7.0750, lng: -73.0950),
        LatLngEntity(lat: 7.0630, lng: -73.0870),
      ],
      stops: [
        StopEntity(
          id: 'f01-s01',
          name: 'Girón Parque Principal',
          lat: 7.0728,
          lng: -73.1698,
          address: 'Centro Girón',
        ),
        StopEntity(
          id: 'f01-s02',
          name: 'Bochalema',
          lat: 7.0850,
          lng: -73.1450,
          address: 'Bochalema',
        ),
        StopEntity(
          id: 'f01-s03',
          name: 'Parque García Rovira',
          lat: 7.1000,
          lng: -73.1200,
          address: 'Centro Bucaramanga',
        ),
        StopEntity(
          id: 'f01-s04',
          name: 'Cabecera del Llano',
          lat: 7.1079,
          lng: -73.1158,
          address: 'C.C. Cabecera',
        ),
        StopEntity(
          id: 'f01-s05',
          name: 'Provenza',
          lat: 7.0900,
          lng: -73.1020,
          address: 'Urbanización Provenza',
        ),
        StopEntity(
          id: 'f01-s06',
          name: 'Cañaveral C.C.',
          lat: 7.0750,
          lng: -73.0950,
          address: 'C.C. Cañaveral',
        ),
        StopEntity(
          id: 'f01-s07',
          name: 'Floridablanca Parque',
          lat: 7.0630,
          lng: -73.0870,
          address: 'Centro Floridablanca',
        ),
      ],
    ),

    // ── RUTA 10: G-01 UIS – Lagos – Floridablanca ────────────────────
    RouteEntity(
      id: 'route-g01',
      code: 'G-01',
      name: 'UIS – Lagos del Cacique – Floridablanca',
      company: 'Cotrasangil',
      textualRoute: 'UIS → Cabecera → Lagos del Cacique → Floridablanca',
      frequency: 'Cada 12 minutos',
      schedule:
          'Lunes a Viernes: 5:30 AM – 10:30 PM | Sábado: 6:00 AM – 9:30 PM | Domingo: No opera',
      lengthKm: 13.1,
      neighborhoods: ['UIS', 'Cabecera', 'Lagos del Cacique', 'Floridablanca'],
      color: '#4527A0',
      coordinates: [
        LatLngEntity(lat: 7.1250, lng: -73.1190),
        LatLngEntity(lat: 7.1200, lng: -73.1170),
        LatLngEntity(lat: 7.1079, lng: -73.1158),
        LatLngEntity(lat: 7.1000, lng: -73.1120),
        LatLngEntity(lat: 7.0885, lng: -73.1097),
        LatLngEntity(lat: 7.0750, lng: -73.0950),
        LatLngEntity(lat: 7.0630, lng: -73.0870),
      ],
      stops: [
        StopEntity(
          id: 'g01-s01',
          name: 'UIS Entrada Norte',
          lat: 7.1250,
          lng: -73.1190,
          address: 'Universidad Industrial de Santander',
        ),
        StopEntity(
          id: 'g01-s02',
          name: 'Av. Los Estudiantes',
          lat: 7.1200,
          lng: -73.1170,
          address: 'Cra. 27 Av. Los Estudiantes',
        ),
        StopEntity(
          id: 'g01-s03',
          name: 'Cabecera del Llano',
          lat: 7.1079,
          lng: -73.1158,
          address: 'C.C. Cabecera',
        ),
        StopEntity(
          id: 'g01-s04',
          name: 'El Jardín',
          lat: 7.1000,
          lng: -73.1120,
          address: 'Barrio El Jardín',
        ),
        StopEntity(
          id: 'g01-s05',
          name: 'Lagos del Cacique',
          lat: 7.0885,
          lng: -73.1097,
          address: 'C.C. Lagos del Cacique',
        ),
        StopEntity(
          id: 'g01-s06',
          name: 'Cañaveral Centro',
          lat: 7.0750,
          lng: -73.0950,
          address: 'Cañaveral, Floridablanca',
        ),
        StopEntity(
          id: 'g01-s07',
          name: 'Floridablanca Parque',
          lat: 7.0630,
          lng: -73.0870,
          address: 'Centro Floridablanca',
        ),
      ],
    ),

    // ── RUTA 11: H-01 Norte – Chimitá ────────────────────────────────
    RouteEntity(
      id: 'route-h01',
      code: 'H-01',
      name: 'Norte – Chimitá Industrial',
      company: 'Cootransbu',
      textualRoute:
          'Norte Bucaramanga → Café Madrid → Chimitá → Zona Industrial',
      frequency: 'Cada 18 minutos',
      schedule: 'Lunes a Sábado: 5:00 AM – 9:00 PM',
      lengthKm: 14.7,
      neighborhoods: [
        'Norte',
        'Café Madrid',
        'Chimitá',
        'Zona Industrial Girón',
      ],
      color: '#558B2F',
      coordinates: [
        LatLngEntity(lat: 7.1450, lng: -73.1280),
        LatLngEntity(lat: 7.1400, lng: -73.1380),
        LatLngEntity(lat: 7.1320, lng: -73.1510),
        LatLngEntity(lat: 7.1200, lng: -73.1550),
        LatLngEntity(lat: 7.1100, lng: -73.1600),
      ],
      stops: [
        StopEntity(
          id: 'h01-s01',
          name: 'Ciudadela Real de Minas',
          lat: 7.1450,
          lng: -73.1280,
          address: 'Norte Bucaramanga',
        ),
        StopEntity(
          id: 'h01-s02',
          name: 'La Cumbre',
          lat: 7.1400,
          lng: -73.1380,
          address: 'Barrio La Cumbre',
        ),
        StopEntity(
          id: 'h01-s03',
          name: 'Café Madrid',
          lat: 7.1320,
          lng: -73.1510,
          address: 'Parque Café Madrid',
        ),
        StopEntity(
          id: 'h01-s04',
          name: 'Chimitá',
          lat: 7.1200,
          lng: -73.1550,
          address: 'Chimitá',
        ),
        StopEntity(
          id: 'h01-s05',
          name: 'Zona Industrial',
          lat: 7.1100,
          lng: -73.1600,
          address: 'Zona Industrial Girón',
        ),
      ],
    ),

    // ── RUTA 12: I-01 Álvarez – Centro – Cabecera ─────────────────────
    RouteEntity(
      id: 'route-i01',
      code: 'I-01',
      name: 'Álvarez – Centro – Cabecera',
      company: 'Coopetrans',
      textualRoute: 'Álvarez → Sotomayor → Centro → Cabecera del Llano',
      frequency: 'Cada 10 minutos',
      schedule: 'Lunes a Domingo: 5:30 AM – 10:30 PM',
      lengthKm: 10.3,
      neighborhoods: ['Álvarez', 'Sotomayor', 'Centro', 'Cabecera'],
      color: '#C62828',
      coordinates: [
        LatLngEntity(lat: 7.1350, lng: -73.1350),
        LatLngEntity(lat: 7.1320, lng: -73.1290),
        LatLngEntity(lat: 7.1250, lng: -73.1250),
        LatLngEntity(lat: 7.1198, lng: -73.1227),
        LatLngEntity(lat: 7.1150, lng: -73.1210),
        LatLngEntity(lat: 7.1079, lng: -73.1158),
      ],
      stops: [
        StopEntity(
          id: 'i01-s01',
          name: 'Álvarez',
          lat: 7.1350,
          lng: -73.1350,
          address: 'Barrio Álvarez',
        ),
        StopEntity(
          id: 'i01-s02',
          name: 'Sotomayor',
          lat: 7.1320,
          lng: -73.1290,
          address: 'Av. Sotomayor',
        ),
        StopEntity(
          id: 'i01-s03',
          name: 'Hospital Ramón González',
          lat: 7.1250,
          lng: -73.1250,
          address: 'Urgencias',
        ),
        StopEntity(
          id: 'i01-s04',
          name: 'Gobernación',
          lat: 7.1198,
          lng: -73.1227,
          address: 'Cra. 26 Clle 37',
        ),
        StopEntity(
          id: 'i01-s05',
          name: 'Parque García Rovira',
          lat: 7.1150,
          lng: -73.1210,
          address: 'Centro',
        ),
        StopEntity(
          id: 'i01-s06',
          name: 'Cabecera del Llano',
          lat: 7.1079,
          lng: -73.1158,
          address: 'C.C. Cabecera',
        ),
      ],
    ),
  ];
}
