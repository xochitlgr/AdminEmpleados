# Data Model: Gestión de Empleados (CRUD)

**Branch**: `001-employee-crud` | **Spec**: [spec.md](spec.md)

## Entidad `Employee` (domain, Dart puro)

| Campo | Tipo | Obligatorio | Descripción |
|-------|------|-------------|-------------|
| `id` | `int` | — | Identificador único, autoincremental (asignado por el data source) |
| `nombreCompleto` | `String` | ✅ | Nombre del empleado; se persiste sin espacios al inicio/fin |
| `area` | `Area` (enum) | ✅ | Área a la que pertenece (ver enums) |
| `puesto` | `String` | ✅ | Puesto dentro del área; se persiste sin espacios al inicio/fin |
| `genero` | `Genero` (enum) | ✅ | Género del empleado |
| `fechaEntrada` | `DateTime` | ✅ | Fecha de ingreso (fecha a nivel de día: hora 00:00) |
| `fechaNacimiento` | `DateTime?` | ❌ | Fecha de nacimiento opcional (nivel de día, hora 00:00) |
| `isActive` | `bool` | ✅ | Estado: `true`=Activo, `false`=Inactivo |

> Regla de negocio: todo empleado nuevo se crea con `isActive = true`
> (ver `Estado del empleado`).

### Enums

**`Area`** (6 valores, lista cerrada — FR-005):

| Enum | Etiqueta UI |
|------|-------------|
| `Area.tecnologia` | Tecnología |
| `Area.recursosHumanos` | Recursos Humanos |
| `Area.finanzas` | Finanzas |
| `Area.operaciones` | Operaciones |
| `Area.ventas` | Ventas |
| `Area.administracion` | Administración |

**`Genero`** (3 valores — FR-005):

| Enum | Etiqueta UI |
|------|-------------|
| `Genero.masculino` | Masculino |
| `Genero.femenino` | Femenino |
| `Genero.otro` | Otro |

### Reglas de validación (construcción/registro)

| Campo | Regla |
|-------|-------|
| `nombreCompleto` | No vacío tras trim; longitud razonable (sin topes rígidos) |
| `area` | Debe seleccionarse un área válida de la lista cerrada (no opción placeholder) |
| `puesto` | No vacío tras trim |
| `genero` | Debe seleccionarse uno de los 3 valores |
| `fechaEntrada` | Obligatoria, elegida con DatePicker; no editable manualmente |
| `fechaNacimiento` | Opcional; si se elige, válida vía DatePicker |

Nada se persiste sin pasar la validación del formulario (Constitución V).

## Estado del empleado (transiciones)

```text
              Registrar (siempre Activo)
   ┌──────────────────────────────────────►  Activo (isActive = true)
   │                                              │
   │                                              │ ToggleEmployeeStatus (Switch)
   │                                              ▼
   │                                          Inactivo (isActive = false)
   └──────────────────────────────────────► (toggle de vuelta)
```

- **Registro** (`RegisterEmployee`): crea el empleado con `isActive = true`. Siempre.
- **Toggle** (`ToggleEmployeeStatus`): invierte el estado actual del empleado
  dado su `id` y devuelve el empleado actualizado; el cambio se persiste en el
  data source y debe reflejarse al instante en la lista (FR-002/FR-003).

## Modelo de datos (capa data)

`EmployeeModel extends Employee` (entidad de dominio) añade:

- `copyWith(...)` para producir copias y toggles funcionales.
- `==`/`hashCode` por valor (consistente con la base `equatable` del domain si
  se usa) para detección sencilla de cambios en listas.
- Es el tipo de las listas en memoria del data source.
- Mapeo explícito `EmployeeModel` ↔ `Employee` en el repositorio; **el domain
  nunca ve `EmployeeModel`**.

## Seed inicial (data source mock)

5 empleados precargados cubriendo variedad de áreas/géneros/estados para poder
validar el toggle y la distinción visual de inactivos:

| Nombre | Área | Puesto | Género | Activo |
|--------|------|--------|--------|--------|
| Ana García | Recursos Humanos | Reclutadora | Femenino | ✅ |
| Luis Pérez | Tecnología | Desarrollador | Masculino | ✅ |
| Marta Ruiz | Finanzas | Contadora | Femenino | ❌ |
| Carlos Díaz | Ventas | Ejecutivo | Masculino | ✅ |
| Sofía López | Operaciones | Supervisora | Otro | ✅ |

> Fechas de ejemplo (entrada 2023–2025; nacimiento opcional para algunos) se
> deciden en la implementación con valores coherentes.

## Claves de construcción

- `fechaEntrada`/`fechaNacimiento` se guardan con hora `00:00` (nivel de día);
  el formateo `dd/MM/yyyy` con `intl` ocurre solo en `presentation`.
- Identidad por `id`; no hay unicidad de nombre ni de puesto (assumption de
  spec) — no se implementa validación de duplicados.