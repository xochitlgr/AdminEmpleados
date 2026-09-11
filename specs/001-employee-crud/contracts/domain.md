# Contract: Domain (puerto + use cases)

**Branch**: `001-employee-crud` | **Data model**: [data-model.md](../data-model.md)

Contrato entre la capa `domain` (puerto) y la capa `data` (adaptador),
más los casos de uso que consume `presentation`. **El `domain` es Dart puro
y no conoce `EmployeeModel`.**

## Puerto `EmployeeRepository` (`domain/repositories/employee_repository.dart`)

```dart
abstract class EmployeeRepository {
  Future<List<Employee>> getEmployees();
  Future<Employee> registerEmployee(Employee employee);
  Future<Employee> toggleEmployeeStatus(int id);
}
```

| Método | Params | Retorna | Contrato |
|--------|--------|---------|----------|
| `getEmployees` | — | `List<Employee>` (no vacía tras seed) | Devuelve todos los empleados en orden de inserción |
| `registerEmployee` | `Employee` (sin `id` asignable: el adapter lo asigna) | `Employee` registrado | Crea con `isActive = true`, asigna `id`, persiste en el mock y lo devuelve |
| `toggleEmployeeStatus` | `id` (`int`, debe existir) | `Employee` actualizado | Invierte `isActive`, persiste y devuelve el empleado actualizado |

**Invariantes**:
- Los únicos tipos de dominio que cruzan el borde son entidades `Employee` y
  enums `Area`/`Genero` — nunca modelos de datos.
- `toggleEmployeeStatus` con un `id` inexistente lanza `StateError`
  (`"Employee not found: <id>"`) — no es alcanzable desde la UI (solo opera
  sobre filas existentes).
- El adaptador `EmployeeRepositoryImpl` (`data/repositories/`) es la **única**
  implementación del puerto y devuelve copias/estado desde el data source.

## Use cases (`domain/usecases/`)

```dart
class GetEmployees {
  final EmployeeRepository repository;
  Future<List<Employee>> call();
}

class RegisterEmployee {
  final EmployeeRepository repository;
  Future<Employee> call(Employee employee);
}

class ToggleEmployeeStatus {
  final EmployeeRepository repository;
  Future<Employee> call(int id);
}
```

| Use case | `call` | Comportamiento |
|----------|--------|----------------|
| `GetEmployees` | — | Delega en `repository.getEmployees()` |
| `RegisterEmployee` | `Employee` | Delega en `repository.registerEmployee(...)` |
| `ToggleEmployeeStatus` | `int id` | Delega en `repository.toggleEmployeeStatus(id)` |

**Regla**: `presentation` solo conversa con use cases (obtenidos de `get_it`),
nunca con `data` ni con el puerto directamente.

## Registro en DI (`app/di/injector.dart`)

```text
sí = registrado como singletón en get_it
MockEmployeeDataSource          (data)      → LazySingleton
EmployeeRepositoryImpl          (data)      → Singleton (recibe el data source)
EmployeeRepository (por interface)          → factory del impl en Singleton
GetEmployees / RegisterEmployee / Toggle   → LazySingleton factory (reciben el repo)
EmployeeListCubit / EmployeeFormCubit      → Factory (no singleton)
```

Nada de código generado: registro 100% manual en `injector.dart`.