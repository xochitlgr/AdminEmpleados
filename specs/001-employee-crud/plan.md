# Implementation Plan: Gestión de Empleados (CRUD)

**Branch**: `001-employee-crud` | **Date**: 2026-09-10 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-employee-crud/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Aplicación Flutter con Clean Architecture feature-first para registrar y
administrar empleados. Tres pantallas: lista con Switch de estado, formulario de
registro validado y pantalla de confirmación. Datos en un data source mock en
memoria con 5 empleados precargados (sin API ni BD); dominio en Dart puro;
estado con Cubit (flutter_bloc) + equatable; DI manual con get_it; fechas con
intl en formato `dd/MM/yyyy`. Enfoque técnico documentado en `research.md`.

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x (Flutter 3.47.3 verificado durante
el bootstrapping del proyecto)

**Primary Dependencies**: `flutter_bloc` (Cubit), `equatable`, `get_it`, `intl`;
dev: `flutter_test` — ninguno con generación de código

**Storage**: N/A — persistence en un data source mock en memoria
(`List<EmployeeModel>`); repositorio in-memory; sin SQLite/Hive/Isar/HTTP

**Testing**: `flutter_test` (tests unitarios del data layer obligatorios y en
verde; se valoran también domain/usecases y estado)

**Target Platform**: Android, iOS, Web (plataformas creadas en `flutter create`)

**Project Type**: mobile-app (Flutter multiplataforma)

**Performance Goals**: No crítico — lista local con decenas de empleados, UI
60fps por defecto, actualización instantánea de filas

**Constraints**: `domain` sin imports de Flutter; dependencias hacia adentro
(`presentation → domain ← data`); datos mock en memoria; DI manual (get_it) sin
código generado (prohibido build_runner); Material 3, etiquetas en español,
fechas solo con `showDatePicker`

**Scale/Scope**: 1 feature (`employees`), 3 pantallas, 3 use cases, 3 cubits
(lista, formulario, navegación de éxito), 5 empleados precargados

> Sin `NEEDS CLARIFICATION`: el input del usuario resuelve todas las decisiones
> técnicas (stack, arquitectura, estado, DI, formato de fecha, datos).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate (Constitución) | Estado | Nota |
|---------------------|--------|------|
| I. Clean Architecture estricta | PASA | 3 capas por feature: presentation/domain/data; dependencias hacia adentro |
| II. Cubit únicamente (flutter_bloc) | PASA | Solo Cubit + equatable; sin setState para estado de negocio |
| III. Datos mock en memoria | PASA | Data source in-memory + repositorio in-memory; sin API/BD |
| IV. Dominio en Dart puro | PASA | Entidad/use cases/puertos sin imports Flutter |
| V. Validación de formularios | PASA | Form + validators en todos los campos requeridos; nada se persiste sin validar |
| VI. UX (Material 3, español, DatePicker) | PASA | `useMaterial3: true`, etiquetas y mensajes en español, fechas vía `showDatePicker` |
| VII. Calidad | PASA | `flutter analyze` sin issues + tests unitarios del data layer en verde |
| VIII. Producto terminado por fases | PASA | Un commit por fase; cada fase deja la app compilable y funcional |

**GATE: PASS** — ninguna violación. Re-evaluado tras Phase 1: PASS (mismo estado).

## Project Structure

### Documentation (this feature)

```text
specs/001-employee-crud/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
│   ├── domain.md        # Contrato del puerto de repositorio + use cases
│   └── ui.md            # Contrato de navegación y comportamiento de pantallas
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
lib/
├── main.dart                # Punto de entrada: init get_it, runApp
├── app/
│   ├── app.dart             # MaterialApp (tema compartido, rutas)
│   ├── routes.dart          # Navegación (lista / /form / /success)
│   └── di/
│       └── injector.dart    # get_it manual: data source, repositorio, use cases, cubits
├── core/
│   └── theme/
│       └── app_theme.dart   # ThemeData(useMaterial3: true) compartido
└── features/
    └── employees/
        ├── data/
        │   ├── datasources/
        │   │   └── mock_employee_data_source.dart   # 5 empleados seed, CRUD en memoria
        │   ├── models/
        │   │   └── employee_model.dart              # extends Employee; copyWith
        │   └── repositories/
        │       └── employee_repository_impl.dart    # implementa el puerto de domain
        ├── domain/
        │   ├── entities/
        │   │   └── employee.dart                    # Dart puro; enums Area/Genero
        │   ├── repositories/
        │   │   └── employee_repository.dart         # puerto abstracto
        │   └── usecases/
        │       ├── get_employees.dart
        │       ├── register_employee.dart
        │       └── toggle_employee_status.dart
        └── presentation/
            ├── cubits/
            │   ├── employee_list/
            │   │   ├── employee_list_cubit.dart
            │   │   └── employee_list_state.dart
            │   └── employee_form/
            │       ├── employee_form_cubit.dart
            │       └── employee_form_state.dart
            ├── pages/
            │   ├── employee_list_page.dart
            │   ├── employee_form_page.dart
            │   └── employee_success_page.dart
            └── widgets/
                └── employee_card.dart               # fila con Switch + visual inactivo

test/
└── features/
    └── employees/
        └── data/
            ├── mock_employee_data_source_test.dart
            └── employee_repository_impl_test.dart
```

**Structure Decision**: feature-first Clean Architecture, tal como exige la
Constitución (`lib/app`, `lib/core`, `lib/features/employees/{presentation,
domain,data}`) y el input del usuario. Capa `domain` sin conocimiento de
`data`/`presentation`; `data` implementa el puerto definido en `domain` y mapea
`EmployeeModel` ↔ `Employee`; `presentation` consume únicamente use cases y
entidades de `domain`.

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

Sin violaciones de la Constitución: la arquitectura feature-first, Cubit, get_it
manual y el mock en memoria son exactamente lo que exige cada principio del
documento, sin capas extra ni dependencias añadidas. No hay complejidad que
justificar.