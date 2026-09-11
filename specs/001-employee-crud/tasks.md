# Tasks: Gestión de Empleados (CRUD)

**Input**: Design documents from `/specs/001-employee-crud/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: La constitución exige tests unitarios del data layer (obligatorios y
en verde); se incluyen solo esos. Los tests de domain/usecases y UI son opcionales
(no solicitados).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Flutter (single project)**: rutas bajo `lib/` y `test/` en la raíz del repo.
- Stack/arquitectura: ver `plan.md` y `research.md` (Cubit + equatable + get_it manual + intl `dd/MM/yyyy`, Clean Architecture feature-first, dominio Dart puro).

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dependencias y tema base del proyecto

- [ ] T001 Agregar dependencias `flutter_bloc`, `equatable`, `get_it`, `intl` con `flutter pub add flutter_bloc equatable get_it intl` (pubspec.yaml)
- [ ] T002 [P] Crear tema compartido Material 3 (`ThemeData(useMaterial3: true)`) en `lib/core/theme/app_theme.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Capas domain y data completas + DI. **Bloquea todas las user stories.**

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [ ] T003 Crear entidad `Employee` (Dart puro, sin imports Flutter) con enums `Area` (tecnologia, recursosHumanos, finanzas, operaciones, ventas, administracion) y `Genero` (masculino, femenino, otro) y campos `id: int`, `nombreCompleto: String`, `area: Area`, `puesto: String`, `genero: Genero`, `fechaEntrada: DateTime`, `fechaNacimiento: DateTime?`, `isActive: bool` en `lib/features/employees/domain/entities/employee.dart`
- [ ] T004 Crear puerto abstracto `EmployeeRepository` con `Future<List<Employee>> getEmployees()`, `Future<Employee> registerEmployee(Employee employee)`, `Future<Employee> toggleEmployeeStatus(int id)` en `lib/features/employees/domain/repositories/employee_repository.dart`
- [ ] T005 [P] Crear use case `GetEmployees` (delega en el repositorio) en `lib/features/employees/domain/usecases/get_employees.dart`
- [ ] T006 [P] Crear use case `RegisterEmployee` (delega en `registerEmployee`) en `lib/features/employees/domain/usecases/register_employee.dart`
- [ ] T007 [P] Crear use case `ToggleEmployeeStatus` (delega en `toggleEmployeeStatus` por `id`) en `lib/features/employees/domain/usecases/toggle_employee_status.dart`
- [ ] T008 [P] Crear `MockEmployeeDataSource` con lista en memoria precargada de 5 empleados (cobertura de áreas/géneros, al menos 1 inactivo), `id: int` autoincremental, métodos get/register/toggle en `lib/features/employees/data/datasources/mock_employee_data_source.dart`
- [ ] T009 [P] Crear `EmployeeModel extends Employee` con `copyWith` y `==`/`hashCode` por valor en `lib/features/employees/data/models/employee_model.dart`
- [ ] T010 Crear `EmployeeRepositoryImpl` implementando el puerto, mapeando `EmployeeModel` ↔ `Employee` (el domain nunca ve el modelo) y lanzando `StateError('Employee not found: <id>')` si se toggle un `id` inexistente en `lib/features/employees/data/repositories/employee_repository_impl.dart`
- [ ] T011 Registrar en `get_it` (registro manual, sin código generado): `MockEmployeeDataSource` (LazySingleton), `EmployeeRepository`/`EmployeeRepositoryImpl` (Singleton), los 3 use cases (LazySingleton) y preparar el patrón `getIt.registerFactory` para los cubits de presentación en `lib/app/di/injector.dart` (`EmployeeFormCubit` y `EmployeeListCubit` se registran como Factory en T015 y T019, cuando existan sus archivos)
- [ ] T012 [P] Escribir tests del data source (seed de 5, register asigna `id` y `isActive = true`, toggle invierte estado, error ante id inexistente) en `test/features/employees/data/mock_employee_data_source_test.dart`
- [ ] T013 [P] Escribir tests del repositorio (getEmployees devuelve 5, register persiste y devuelve el empleado, toggle persiste en el mock, propaga errores) en `test/features/employees/data/employee_repository_impl_test.dart`

**Checkpoint**: Foundation ready - user story implementation can now begin. `flutter analyze` sin issues y `flutter test` del data layer en verde.

---

## Phase 3: User Story 1 - Registrar un empleado (Priority: P1) 🎯 MVP

**Goal**: Formulario de registro validado que crea un empleado (siempre `isActive = true`) y navega a la pantalla de éxito.

**Independent Test**: tests del data layer en verde (`flutter test`); `flutter analyze` sin issues; el formulario bloquea campos requeridos vacíos sin crear ningún empleado; la pantalla de éxito muestra "Empleado registrado correctamente". (Rutas base `/`, `/form`, `/success` definidas en T016; el runtime completo se verifica en US3.)

### Implementation for User Story 1

- [ ] T014 [P] [US1] Crear `EmployeeFormState` con `equatable` (initial, submitting, success, error con mensaje) en `lib/features/employees/presentation/cubits/employee_form/employee_form_state.dart`
- [ ] T015 [P] [US1] Crear `EmployeeFormCubit` con `submit(Employee employee)` (usa `RegisterEmployee`, expone estados) en `lib/features/employees/presentation/cubits/employee_form/employee_form_cubit.dart` y registrarlo como `Factory` en `lib/app/di/injector.dart`
- [ ] T016 [US1] Crear `EmployeeFormPage` con `Form` + `GlobalKey<FormState>` y validaciones (reglas verbatim de data-model: nombreCompleto "Requerido, no vacío tras trim; error `Ingresa el nombre completo`"; area "Debe seleccionarse un área válida de la lista cerrada"; fechaEntrada "Obligatoria, elegida con DatePicker; no editable manualmente"; puesto "Requerido, no vacío tras trim"; genero "Debe seleccionarse uno de los 3 valores"; fechaNacimiento opcional). Fechas como campos solo-lectura que abren `showDatePicker`; dropdowns `DropdownButtonFormField<Area>` / `<Genero>`; botón "Registrar" que valida y navega a `/success` en `lib/features/employees/presentation/pages/employee_form_page.dart`; además, crear `lib/app/routes.dart` con las rutas base nombradas `/`, `/form` y `/success` (constantes de ruta + builders para `/form` → `EmployeeFormPage` y `/success` → `EmployeeSuccessPage`; el builder de `/` se completa en T021 al existir `EmployeeListPage`)
- [ ] T017 [P] [US1] Crear `EmployeeSuccessPage` con mensaje "Empleado registrado correctamente" y botón "Regresar a empleados" en `lib/features/employees/presentation/pages/employee_success_page.dart`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently.

---

## Phase 4: User Story 2 - Ver la lista y activar/desactivar empleados (Priority: P1)

**Goal**: Lista con los 6 atributos por empleado, Switch persistente por fila y distinción visual de inactivos.

**Independent Test**: tests del data layer en verde; `GetEmployees` devuelve los 5 seeds; el toggle persiste (verificado en T013).

### Implementation for User Story 2

- [ ] T018 [P] [US2] Crear `EmployeeListState` con `equatable` (initial, loading, loaded con lista, error con mensaje) en `lib/features/employees/presentation/cubits/employee_list/employee_list_state.dart`
- [ ] T019 [P] [US2] Crear `EmployeeListCubit` con `load()` (usa `GetEmployees`) y `toggle(int id)` (usa `ToggleEmployeeStatus` y refresca la lista) en `lib/features/employees/presentation/cubits/employee_list/employee_list_cubit.dart` y registrarlo como `Factory` en `lib/app/di/injector.dart`
- [ ] T020 [P] [US2] Crear `EmployeeCard` con nombre completo, puesto, área (etiqueta en español), género, fecha de entrada (`dd/MM/yyyy` con intl), Switch cuyo `value` usa `employee.isActive` (estado guardado; onChanged → `onToggle`) y chip de estado; la fila inactiva se distingue visualmente (fondo grisáceo, opacidad reducida) en `lib/features/employees/presentation/widgets/employee_card.dart`
- [ ] T021 [US2] Crear `EmployeeListPage` con `BlocBuilder` sobre `EmployeeListCubit`, estados (loading/loaded/error) y AppBar "Empleados" en `lib/features/employees/presentation/pages/employee_list_page.dart`, y completar en `lib/app/routes.dart` el builder de la ruta base `/` → `EmployeeListPage` (definida en T016)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently.

---

## Phase 5: User Story 3 - Acceso rápido + Integración (Priority: P2)

**Goal**: La app completa arranca en la lista; el botón flotante abre el registro. Wiring de rutas y bootstrap que hace la app compilable y funcional.

**Independent Test**: quickstart.md S1–S5 en dispositivo (`flutter run`): lista con 5 seeds, registro completo, validación, toggle con visual inactivo.

### Implementation for User Story 3

- [ ] T022 [US3] Agregar `FloatingActionButton` "Agregar" (abre `/form`) a `EmployeeListPage` y crear `App` (MaterialApp con tema de T002 y las rutas de `lib/app/routes.dart` definidas en T016/T021) en `lib/app/app.dart`
- [ ] T023 [US3] Reescribir `lib/main.dart` (init de `get_it` con `injector` + `runApp(App)`) y reemplazar el test de plantilla `test/widget_test.dart` (hace referencia al counter de la plantilla y rompería `flutter test`) por un smoke test que verifica que la app arranca y muestra la lista

**Checkpoint**: All user stories are functional; la app compila y corre.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validación final de extremo a extremo y calidad (Constitución VII/VIII).

- [ ] T024 Ejecutar la validación de `quickstart.md` (S1–S6: registro válido, campos requeridos, fecha no editable, toggle y seed) y confirmar `flutter analyze` sin issues + `flutter test` en verde

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - US1 y US2 pueden ejecutarse en paralelo si hay capacidad; en orden secuencial van P1 → P1 → P2
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational - No dependencies on other stories
- **User Story 2 (P1)**: Can start after Foundational - No dependencies on other stories
- **User Story 3 (P2)**: Depends on US1 (rutas base `/form`, `/success` en `routes.dart`) y US2 (existencia de `EmployeeListPage` y ruta `/` para el FAB)

### Within Each User Story

- Models/estado antes que cubits; cubits antes que páginas; páginas antes que integración
- Story complete before moving to next priority

### Parallel Opportunities

- Todos los Setup/Foundational `[P]` en paralelo
- T012 y T013 (tests data layer) en paralelo
- Estados + cubits + widgets de una story `[P]` en paralelo
- US1 y US2 en paralelo tras Foundational (si capacidad lo permite)

---

## Parallel Example: User Story 1

```text
Task: "Create EmployeeFormState in lib/features/employees/presentation/cubits/employee_form/employee_form_state.dart"
Task: "Create EmployeeFormCubit in lib/features/employees/presentation/cubits/employee_form/employee_form_cubit.dart"
Task: "Create EmployeeSuccessPage in lib/features/employees/presentation/pages/employee_success_page.dart"
```

## Parallel Example: User Story 2

```text
Task: "Create EmployeeListState in lib/features/employees/presentation/cubits/employee_list/employee_list_state.dart"
Task: "Create EmployeeListCubit in lib/features/employees/presentation/cubits/employee_list/employee_list_cubit.dart"
Task: "Create EmployeeCard in lib/features/employees/presentation/widgets/employee_card.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 + 2)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1 + Phase 4: User Story 2
4. **STOP and VALIDATE**: `flutter analyze` + `flutter test` verdes
5. Combine con Phase 5 (US3 integración) para obtener app ejecutable y funcional

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready (domain + data + DI, testeado)
2. Add User Story 1 (registro validado + éxito) → Test independently
3. Add User Story 2 (lista + toggle) → Test independently
4. Add User Story 3 (FAB + App/main bootstrap) → App completa, demoable
5. Add Polish (validación quickstart S1–S6) → Cierre de feature

### Parallel Team Strategy

Con varios desarrolladores:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1 (register)
   - Developer B: User Story 2 (list + toggle)
3. One developer integra User Story 3 + Polish (depende de ambas)

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Constitución VIII: un commit por fase (`feat: domain`, `feat: data layer`, `feat: UI`, ...); cada fase deja la app compilable y `flutter analyze` sin issues + tests del data layer en verde
- Evitar: tareas vagas, conflictos de mismo archivo, dependencias cruzadas que rompan la independencia de stories
- US3 toca `EmployeeListPage` (compartido con US2): ejecutar en orden (US2 antes de US3)