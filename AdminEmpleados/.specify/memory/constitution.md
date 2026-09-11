# AdminEmpleados Constitution

## Core Principles

### I. Clean Architecture Estricta
Separación total entre presentación, dominio y datos. Las dependencias apuntan
siempre hacia el interior: `presentation` → `domain` ← `data`. El dominio nunca
depende de la presentación ni de los datos; los repositorios se declaran como
puertos en `domain` y se implementan en `data`.

### II. State Management con Cubit (flutter_bloc)
Único patrón de gestión de estado permitido: Cubit de `flutter_bloc`. Prohibido
Provider, Riverpod, GetX o `setState` para estado de negocio. El estado se
expone con `BlocProvider` y se escucha con `BlocBuilder`.

### III. Datos Mock Locales en Memoria
Todos los repositorios usan datos mock en memoria (listas/mapas locales).
Prohibido consumir APIs HTTP o usar una base de datos real (SQLite, Hive, Isar,
servicios en la nube) para la persistencia de esta aplicación.

### IV. Dominio en Dart Puro (sin Flutter)
La capa `domain` NO importa Flutter ni ningún paquete que dependa de él (sin
`dart:ui`, `package:flutter/*`). Solo Dart puro: entidades, casos de uso,
puertos y validadores.

### V. Validación de Formularios Obligatoria
Todo campo requerido debe validarse (Form + validators). Ningún input se
persiste sin pasar su validación.

### VI. UX Consistente (Material 3, Español, DatePicker)
Interfaz con Material 3 (`ThemeData(useMaterial3: true)`). Las fechas se capturan
siempre con DatePicker (`showDatePicker`), nunca como texto libre. Todas las
etiquetas y mensajes en español.

### VII. Calidad
`flutter analyze` sin issues antes de cerrar cada fase. Tests unitarios del data
layer obligatorios y en verde; se valoran también los del dominio y casos de uso.

### VIII. Producto Terminado por Fases
Trabajo por fases, un commit por fase. Cada fase deja la app compilable y
funcional. Objetivo: producto terminado y usable, no un ejercicio académico.

## Arquitectura de Carpetas

La raíz de `lib/` se organiza por features (Clean Architecture):

```
lib/
  app/            # bootstrap: tema Material 3, rutas, dependencias
  core/           # utilidades compartidas (al mínimo)
  features/
    employees/
      presentation/  # screens, widgets, cubit/estado
      domain/        # entidad, puerto de repositorio, casos de uso, validadores (Dart puro)
      data/          # implementaciones de repositorio, modelos, mocks en memoria
```

## Flujo de Trabajo y Criterios de Terminado (DoD)

- Cada fase termina en un commit descriptivo (`feat: domain`, `feat: data layer`,
  `feat: UI`, ...).
- "Fase terminada" = `flutter analyze` sin issues + tests del data layer en verde
  + la app compila y corre.
- No se cierra código sin su prueba ni con TODOs de funcionalidad pendientes.

## Governance

- Esta constitución prevalece sobre cualquier otra práctica del repositorio.
- Enmiendas: documentar el cambio, justificar el bump semver y actualizar
  `Last Amended`. MAJOR: rompe/redefine principios; MINOR: añade principios o
  secciones; PATCH: aclaraciones de redacción.
- Cumplimiento: cada fase se revisa (vía `/speckit.analyze`) contra estos
  principios antes de cerrarse.

**Version**: 1.0.0 | **Ratified**: 2026-09-10 | **Last Amended**: 2026-09-10