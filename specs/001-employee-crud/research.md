# Research: Gestión de Empleados (CRUD)

**Feature**: `001-employee-crud` | **Branch**: `001-employee-crud`

**Input**: Plan `/specs/001-employee-crud/plan.md` + constitución v1.0.0.

No quedó ningún `NEEDS CLARIFICATION` en el Technical Context: el input del
usuario decidió explícitamente stack, arquitectura, state management, DI,
formato de fechas y origen de datos. Las tareas de investigación se resuelven
documentando la decisión, su racionalidad y las alternativas evaluadas.

## Stack y versiones

- **Decision**: Dart 3.x / Flutter 3.x (3.47.3 instalado y verificado).
- **Rationale**: Entorno ya bootstrappeado (`flutter create`) con `pub get` OK.
  Dart 3 aporta null safety, records y pattern matching sin coste.
- **Alternatives considered**: Otros frameworks (React Native, Kotlin
  multiplatform) — descartados por decisión de producto; no aplican
  restricciones del proyecto.

## Arquitectura

- **Decision**: Clean Architecture feature-first
  (`lib/features/employees/{presentation,domain,data}` + `lib/app` + `lib/core`).
- **Rationale**: Constitución I + IV; el domino queda 100% Dart puro y
  reutilizable; fronteras claras entre UI, reglas de negocio y datos.
- **Alternatives considered**: Arquitectura por capas global (models + services
  + screens) — rechazada: acoplaba screens de features distintas y dificultaba
  el aislamiento del dominio.

## State management

- **Decision**: `flutter_bloc` (Cubit) con estados `equatable`.
- **Rationale**: Constitución II (único patrón permitido); Cubit es la variante
  más ligera de bloc y suficiente para CRUD sin eventos complejos; `equatable`
  evita rebuilds innecesarios comparando estados por valor.
- **Alternatives considered**: Provider, Riverpod, GetX, `setState` para estado
  de negocio — **prohibidos** por Constitución II.

## Inyección de dependencias

- **Decision**: `get_it` manual, sin generación de código.
- **Rationale**: Solo hay una pequeña gráfica (data source → repositorio →
  use cases → cubits); el registro manual en `injector.dart` es legible y evita
  build_runner.
- **Alternatives considered**: `get_it` + `injectable` (generación de código) y
  Provider — descartados: violan la regla de "sin código generado" y añaden
  dependencias innecesarias.

## Formato de fechas

- **Decision**: `intl` con `DateFormat('dd/MM/yyyy')`.
- **Rationale**: Formato legible en español, requerido por la UX (Constitución
  VI); la captura siempre ocurre vía `showDatePicker` (lo cual devuelve un
  `DateTime` nativo, sin edición manual).
- **Alternatives considered**: Formateador propio — descartado (reinventar la
  rueda, riesgo de edge cases de calendario); `package:timeago` — innecesario.

## Origen de datos

- **Decision**: Data source mock en memoria (`List<EmployeeModel>`) + repositorio
  in-memory, seed con 5 empleados precargados; persistencia por sesión.
- **Rationale**: Constitución III prohíbe API/BD; mock en memoria es el patrón
  mínimo que satisface el DoD del feature y permite tests unitarios del data
  layer sin infraestructura.
- **Alternatives considered**: SQLite/Hive/Isar/API HTTP — **prohibidos** por
  Constitución III.

## Identidad de la entidad

- **Decision**: `id` numérico (`int`) autoincremental generado por el data
  source en memoria.
- **Rationale**: Suficiente para listas locales por sesión; no requiere UUID ni
  persistencia entre ejecuciones (datos mock).
- **Alternatives considered**: `String` UUID — sobre-ingeniería para MVP en
  memoria, descartado.

## Estado del empleado

- **Decision**: `bool isActive` en la entidad; el display (chip "Activo"/"Inactivo")
  vive en `presentation`.
- **Rationale**: La señal de negocio es binaria y el use case
  `ToggleEmployeeStatus` la aleja; un enum agregaría conversiones sin valor real
  en domain.
- **Alternatives considered**: Enum `EstadoEmpleado { activo, inactivo }` —
  descartado por simplicidad; el mapeo a etiquetas es responsabilidad de la UI.

## Flujo de datos (sync vs async)

- **Decision**: Repositorio y use cases con API `async` extensible al futuro.
- **Rationale**: Mantener el contrato asíncrono ahora es trivial (el mock responde
  inmediatamente) y evita repros si mañana el origen dejara de ser en memoria.
- **Alternatives considered**: Síncrono puro — descartado: endurecería el contrato
  del puerto y restaría portabilidad.

## Validación de formularios

- **Decision**: La validación se implementa en la capa de `presentation`
  mediante `Form` + validators de Flutter (reglas de `data-model.md` citadas
  verbatim en la tarea T016).
- **Rationale**: Constitución V sanciona explícitamente "Form + validators". Las
  reglas de datos son de entrada de UI (campos del formulario), no reglas de
  negocio; mantener el dominio Dart puro sin lógica atada a widgets evita
  duplicación. El use case `RegisterEmployee` no re-valida por construcción:
  el formulario solo emite `Employee` completo.
- **Alternatives considered**: Validador de dominio puro (`domain/validators`)
  — descartado: duplicaría lógica usada únicamente por el formulario; se
  reconsiderará si aparecen reglas de negocio compartidas fuera de la UI.

## Testeo

- **Decision**: `flutter_test` — tests unitarios obligatorios del data layer
  (data source + repository impl); se añaden de domain/usecases como valor.
- **Rationale**: Constitución VII; el mock en memoria es 100% testeable sin
  mocking de frameworks externos.
- **Alternatives considered**: mockito/mocktail — innecesarios: el data source es
  un objeto real simple inyectable.