# Quickstart: Validación de la Gestión de Empleados

**Branch**: `001-employee-crud` | **Spec**: [spec.md](spec.md) · **Data model**: [data-model.md](data-model.md) · **Contracts**: [domain](contracts/domain.md) / [ui](contracts/ui.md)

Guía de validación de extremo a extremo (sin código de implementación — eso
vive en `tasks.md` y la fase de implementación).

## Prerequisitos

- Flutter 3.47.x / Dart 3.x (ya instalados en el proyecto).
- Paquetes del plan (se agregan en la fase de implementación):

```bash
flutter pub add flutter_bloc equatable get_it intl
```

## Comandos

```bash
flutter pub get          # después de agregar dependencias
flutter analyze          # CALIDAD: debe terminar sin issues
flutter test             # data layer (y domain/usecases si se valoran)
flutter run -d windows   # o -d chrome / -d android (última fase)
```

**Salida esperada**: `flutter analyze` = sin issues; `flutter test` = tests del
data layer en verde; la app compila y lanza mostrando la lista con 5 empleados.

## Escenarios de validación (mapeados a la spec)

### S1 — Registrar un empleado válido (US1 / FR-005..FR-009)
1. `flutter run` → pulsar FAB "Agregar".
2. Completar nombre, área, fecha de entrada (DatePicker), puesto y género;
   opcional: fecha de nacimiento (DatePicker).
3. Pulsar "Registrar" → debe navegar a éxito ("Empleado registrado correctamente").
4. Pulsar "Regresar a empleados" → el nuevo empleado aparece con estado Activo.

### S2 — Validación de campos obligatorios (FR-006)
1. Abrir el formulario y pulsar "Registrar" sin tocar nada.
2. Deben aparecer errores en nombre, área, fecha de entrada, puesto y género;
   **no** se crea ningún empleado (SC-004).

### S3 — Fecha no editable manualmente (FR-005 / Constitución VI)
1. Intentar escribir en el campo de fecha de entrada.
2. Solo se puede cambiar mediante el selector; el texto muestra `dd/MM/yyyy`.

### S4 — Toggle Activo/Inactivo (US2 / FR-002, FR-003, FR-010)
1. En la lista, apagar el Switch de un empleado activo (p. ej. Luis Pérez).
2. La fila debe cambiar a un aspecto visual distinto al instante (inactivo).
3. Abrir `/form` y volver: el estado guardado se conserva.
4. Encender el Switch → la fila vuelve al aspecto activo.

### S5 — Seed precargado (data model)
1. Al arrancar, la lista muestra 5 empleados con nombre, puesto, área, género,
   fecha de entrada y Estado (Activo/Inactivo); al menos uno inactivo con
   aspecto distinto.

### S6 — Calidad (Constitución VII)
Probar `flutter analyze` y `flutter test` después de cada fase de la implementación
(commits por fase — Constitución VIII).

## Detalle de referencia

- Entidad y enums: [data-model.md](data-model.md)
- Contrato del puerto y use cases: [contracts/domain.md](contracts/domain.md)
- Navegación, estados y comportamiento de UI: [contracts/ui.md](contracts/ui.md)