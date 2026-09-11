# Contract: UI (pantallas y comportamiento)

**Branch**: `001-employee-crud` | **Spec**: [spec.md](../spec.md) | **Constitución**: VI (UX)

Contrato de experiencia de usuario del feature `employees`: navegación, estado,
formulario y look & feel.

## Navegación (rutas)

```text
lib/app/routes.dart: MaterialApp con rutas nombradas

"/"        → EmployeeListPage
"/form"    → EmployeeFormPage
"/success" → EmployeeSuccessPage
```

| Transición | Evento |
|------------|--------|
| Lista → Formulario | Botón flotante (FAB) en `EmployeeListPage` |
| Formulario → Éxito | `RegisterEmployee` exitoso (solo si la validación pasa) |
| Éxito → Lista | Botón "Regresar a empleados" (navegación de retorno, `popUntil` primera ruta) |

## Pantalla 1 — `EmployeeListPage` (lista)

- AppBar: "Empleados".
- Lista de `EmployeeCard` (una por empleado, orden de inserción).
- Botón flotante (`FloatingActionButton` "Agregar") → abre `/form`.
- **Estados**: carga (`CircularProgressIndicator`), lista cargada, error
  (mensaje + reintentar).

### `EmployeeCard` (widget)

| Elemento | Detalle |
|----------|---------|
| Título | `nombreCompleto` |
| Subtítulo | `puesto` + etiqueta de `area` (presentation) |
| Línea de datos | `género`, `fechaEntrada` (`dd/MM/yyyy` con intl) |
| Estado | Switch en la fila (on/off) |
| Fila inactiva | Visual distinto: fondo grisáceo, opacidad reducida y chip "Inactivo"; activa = fondo normal + chip "Activo" |

**Switch**:
- `value` desde `employee.isActive` (estado guardado, nunca valor local).
- Tap → `onToogle` en la fila (no rebuild manual): `EmployeeListCubit.toggle(id)`.
- Tras el cambio, la fila refleja al instante el nuevo estado (persistido en el
  data source; FR-002/FR-003/FR-010).
- Sin diálogo de confirmación (assumption de spec).

## Pantalla 2 — `EmployeeFormPage` (registro)

Formulario con `Form` + `GlobalKey<FormState>` (Constitución V).

| Campo | Widget | Validación |
|-------|--------|------------|
| Nombre completo | `TextFormField` (text) | Requerido, no vacío tras trim; error: "Ingresa el nombre completo" |
| Área | `DropdownButtonFormField<Area>` | Requerido (sin opción placeholder persistible); error: "Selecciona un área" |
| Fecha de entrada | `TextFormField` read-only + tap → `showDatePicker` | Requerido; error: "Selecciona la fecha de entrada" |
| Puesto | `TextFormField` (text) | Requerido, no vacío tras trim; error: "Ingresa el puesto" |
| Género | `DropdownButtonFormField<Genero>` | Requerido; error: "Selecciona un género" |
| Fecha de nacimiento | `TextFormField` read-only + tap → `showDatePicker` | Opcional; si se elige, se muestra `dd/MM/yyyy` |

- Fechas **nunca** editables como texto: campo solo-lectura que abre el date
  picker (Constitución VI; FR-005).
- `TextInputFormatter`/estructura del campo de fecha → informativo, no textual.
- Botón "Registrar": `validate()` → si OK dispara cubit de formulario →
  navegar a `/success`; si falla, mensajes por campo (FR-006).

## Pantalla 3 — `EmployeeSuccessPage`

- Mensaje: "Empleado registrado correctamente".
- Botón "Regresar a empleados" → vuelve a la lista (la nueva fila aparece;
  FR-008/FR-009).
- En esta fase no lleva "registrar otro" (fuera de alcance; ver spec).

## Cubits (estado)

| Cubit | Estado (`equatable`) | Eventos públicos |
|-------|----------------------|------------------|
| `EmployeeListCubit` | `EmployeeListInitial` / `EmployeeListLoading` / `EmployeeListLoaded(list)` / `EmployeeListError(msg)` | `load()` (rellena lista), `toggle(int id)` (alterna `isActive`) |
| `EmployeeFormCubit` | `EmployeeFormInitial` / `EmployeeFormSubmitting` / `EmployeeFormSuccess` / `EmployeeFormError(msg)` | `submit(Employee candidate)` (valida y registra) |

- `EmployeeListLoaded` reemplaza la lista completa (edad mínima; dataset pequeño).
- La UI escucha con `BlocBuilder` (Constitución II); `BlocProvider` para lista y
  formulario se inyecta por `get_it` (`factory`) y se abre/cierra con el página.

## Look & feel (Constitución VI)

- `core/theme/app_theme.dart`: `ThemeData(useMaterial3: true)`, seed color de
  marca; AppBar/listas Material 3 por defecto.
- Todas las etiquetas, mensajes de error y textos en español.
- Formato de fechas: `dd/MM/yyyy`.

## Fuera de alcance (spec)

Sin búsqueda, filtros, paginación, edición, eliminación, ni confirmación del
toggle.