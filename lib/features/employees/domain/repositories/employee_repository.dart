import '../entities/employee.dart';

/// Puerto de repositorio de empleados (contrato entre domain y data).
abstract class EmployeeRepository {
  /// Devuelve todos los empleados en orden de inserción.
  Future<List<Employee>> getEmployees();

  /// Registra un empleado asignándole `id` e `isActive = true`.
  Future<Employee> registerEmployee(Employee employee);

  /// Invierte el estado del empleado dado y lo devuelve actualizado.
  /// Lanza `StateError` si el `id` no existe.
  Future<Employee> toggleEmployeeStatus(int id);
}