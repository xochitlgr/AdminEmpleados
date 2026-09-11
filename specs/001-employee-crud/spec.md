# Feature Specification: Gestión de Empleados (CRUD)

**Feature Branch**: `001-employee-crud`

**Created**: 2026-09-10

**Status**: Draft

**Input**: User description: "Aplicación Flutter para registrar y administrar empleados" (3 pantallas: lista, registro, registro exitoso).

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Registrar un empleado nuevo (Priority: P1)

El usuario (gestor de RR. HH.) accede desde la lista principal al registro de un
empleado, completa los datos obligatorios y válidos, y confirma el registro. El
sistema crea al empleado con estado inicial Activo, lo guarda en el origen de
datos local y muestra una confirmación de éxito.

**Why this priority**: Sin registro no puede existir ningún empleado en la lista:
es la fuente de datos de la aplicación.

**Independent Test**: Puede probarse abriendo el registro, completando los campos
y confirmando; debe aparecer el mensaje de éxito y, al volver, el nuevo empleado
debe estar en la lista.

**Acceptance Scenarios**:

1. **Given** un usuario en el formulario de registro, **When** completa nombre,
   área, fecha de entrada, puesto y género, **Then** el botón Registrar guarda al
   empleado y navega a la pantalla de éxito.
2. **Given** el formulario con un campo obligatorio vacío, **When** se pulsa
   Registrar, **Then** el registro se bloquea y se muestra el error de validación
   sin crear ningún empleado.
3. **Given** la pantalla de éxito, **When** el usuario pulsa "Regresar a
   empleados", **Then** el empleado recién creado aparece en la lista.

---

### User Story 2 - Ver la lista y activar/desactivar empleados (Priority: P1)

El usuario consulta la lista principal con todos los campos visibles de cada
empleado y usa el Switch de cada fila para activar o desactivar el estado del
empleado. El estado guardado cambia al instante y la fila refleja visualmente el
nuevo estado.

**Why this priority**: Es la pantalla principal y donde el usuario gestiona el día
a día; el toggle es la acción de administración más frecuente.

**Independent Test**: Puede probarse abriendo la lista, cambiando el Switch de
cualquier empleado y confirmando que el estado (y su apariencia) cambian y se
mantienen en la sesión.

**Acceptance Scenarios**:

1. **Given** la lista con empleados, **When** el usuario apaga el Switch de un
   empleado activo, **Then** el estado guardado pasa a Inactivo y la fila cambia
   visualmente (fondo, opacidad y/o estilo de texto).
2. **Given** la lista con empleados, **When** el usuario enciende el Switch de un
   empleado inactivo, **Then** el estado guardado pasa a Activo y la fila vuelve
   a su apariencia normal.
3. **Given** la lista principal, **When** se desactiva un empleado, **Then** el
   cambio permanece al volver a la lista desde otra pantalla.

---

### User Story 3 - Acceso rápido al registro (Priority: P2)

El usuario dispone de un botón flotante en la lista que abre el formulario de
registro en cualquier momento, sin pasos intermedios.

**Why this priority**: Mejora la eficiencia, pero la funcionalidad ya está
cubierta por la pantalla de registro.

**Independent Test**: Puede probarse pulsando el botón flotante desde la lista y
comprobando que se abre el formulario de registro.

**Acceptance Scenarios**:

1. **Given** la lista principal, **When** el usuario pulsa el botón flotante,
   **Then** se abre la pantalla de registro de empleado.

---

### Edge Cases

- ¿Qué pasa si el usuario deja vacío un campo obligatorio (nombre, puesto, área) y
  pulsa Registrar? El registro se bloquea y se muestran mensajes de validación en
  los campos afectados.
- ¿Qué pasa si el usuario no selecciona una fecha de entrada? Se trata como campo
  obligatorio: el registro se bloquea hasta que se seleccione una fecha mediante
  el selector de fechas.
- ¿Qué pasa si se cambia el Switch de una fila mientras se está en otra pantalla?
  El cambio queda guardado en el origen de datos y se refleja al volver a la lista.
- ¿Qué pasa si el usuario intenta escribir la fecha manualmente? No es posible: el
  campo de fecha no es editable manualmente y solo acepta selección por DatePicker.
- ¿Qué pasa con la fecha de nacimiento? Es opcional: si no se selecciona, el empleado
  se registra igualmente sin fecha de nacimiento.
- ¿Qué pasa si la aplicación se cierra? Los datos mock viven en memoria; el estado
  guardado se conserva durante la sesión de la aplicación.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE mostrar en la lista de empleados los campos: nombre
  completo, área, puesto, género, fecha de entrada y estado (Activo/Inactivo).
- **FR-002**: Cada fila DEBE incluir un Switch que permita activar/desactivar al
  empleado y DEBE persistir ese cambio en el origen de datos local.
- **FR-003**: Cuando un empleado está Inactivo, su fila DEBE distinguirse
  visualmente (color de fondo, opacidad y/o estilo de texto).
- **FR-004**: La lista DEBE tener un botón flotante para agregar un nuevo empleado
  que abra el formulario de registro.
- **FR-005**: El formulario DEBE capturar: nombre completo (texto obligatorio),
  área (selección: Tecnología, Recursos Humanos, Finanzas, Operaciones, Ventas,
  Administración), fecha de entrada (DatePicker, no editable manualmente), puesto
  (texto obligatorio), género (Masculino, Femenino, Otro) y fecha de nacimiento
  (DatePicker, opcional).
- **FR-006**: El botón Registrar DEBE validar los campos obligatorios y bloquear la
  creación si no se cumplen, mostrando los errores correspondientes.
- **FR-007**: Al registrar, el sistema DEBE crear el empleado con estado Activo,
  guardarlo en el origen de datos mock local y navegar a la pantalla de registro
  exitoso.
- **FR-008**: La pantalla de éxito DEBE mostrar el mensaje "Empleado registrado
  correctamente" y un botón "Regresar a empleados".
- **FR-009**: Al regresar a la lista, el nuevo empleado DEBE aparecer en la lista
  con sus datos y estado.
- **FR-010**: El estado de cada empleado DEBE leerse desde el origen de datos local
  (no de la interfaz) para todos los cálculos y visualizaciones.
- **FR-011**: La arquitectura DEBE separar presentación, dominio y datos; el
  dominio NO DEBE depender de la interfaz ni del ahorro de datos concreto. El
  estado de los formularios se gestiona con un único patrón de gestión de estado.
- **FR-012**: La interfaz DEBE capturar las fechas únicamente con DatePicker y
  mostrar todas las etiquetas y mensajes en español, con apariencia Material 3.

### Key Entities *(include if feature involves data)*

- **Empleado**: persona registrada en la organización; atributos: nombre completo,
  área, puesto, género, fecha de entrada, fecha de nacimiento (opcional) y estado
  (Activo/Inactivo).
- **Estado del empleado**: atributo de negocio que determina si el empleado está
  Activo o Inactivo; controlado desde la lista mediante el Switch.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El usuario puede registrar un empleado completo en menos de 2 minutos.
- **SC-002**: El 100% de los empleados registrados aparecen en la lista al regresar
  desde la pantalla de éxito.
- **SC-003**: El 100% de los cambios de estado hechos con el Switch se reflejan en
  la lista de inmediato y permanecen durante la sesión.
- **SC-004**: El registro con campos obligatorios vacíos no crea ningún empleado
  (0 registros inválidos generados).
- **SC-005**: La lista muestra los 6 atributos de cada empleado sin truncarse y sin
  ambigüedad visual entre activos e inactivos.

## Assumptions

- El nuevo empleado siempre se registra con estado **Activo**.
- El cambio de estado con el Switch no requiere confirmación previa.
- En esta fase no hay búsqueda, filtros, ordenación, paginación, edición ni
  eliminación de empleados (éste es el MVP).
- No se impone unicidad de nombre ni de puesto: pueden existir empleados con el
  mismo nombre.
- La fecha de entrada es obligatoria (aparece en todas las filas de la lista); la
  fecha de nacimiento es opcional.
- La persistencia es local y en memoria: los datos se conservan durante la sesión
  de la aplicación y se pierden al cerrarla.
- No hay autenticación ni múltiples usuarios; existe un único rol (gestor de
  personal) que usa la aplicación.
- El "área" se elige de la lista cerrada de seis áreas definidas.
- La fecha de entrada puede ser pasada o actual; no se impone una validación
  adicional (por ejemplo, prohibir fechas futuras) salvo que se confirme lo
  contrario en la fase de clarificación.