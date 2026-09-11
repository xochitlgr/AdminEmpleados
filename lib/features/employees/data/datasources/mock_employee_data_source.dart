import '../../domain/entities/employee.dart';
import '../models/employee_model.dart';

/// Data source mock en memoria (Constitución III).
///
/// Almacena la lista viva de empleados y asigna `id` autoincremental.
class MockEmployeeDataSource {
  MockEmployeeDataSource() {
    _seed();
  }

  final List<EmployeeModel> _employees = <EmployeeModel>[];
  int _nextId = 1;

  /// Precarga 5 empleados (data-model.md); Marta Ruiz inicia inactiva.
  void _seed() {
    _employees.addAll([
      EmployeeModel(
        id: _nextId++,
        nombreCompleto: 'Ana García',
        area: Area.recursosHumanos,
        puesto: 'Reclutadora',
        genero: Genero.femenino,
        fechaEntrada: DateTime(2023, 3, 15),
        fechaNacimiento: DateTime(1990, 7, 22),
        isActive: true,
      ),
      EmployeeModel(
        id: _nextId++,
        nombreCompleto: 'Luis Pérez',
        area: Area.tecnologia,
        puesto: 'Desarrollador',
        genero: Genero.masculino,
        fechaEntrada: DateTime(2024, 1, 8),
        isActive: true,
      ),
      EmployeeModel(
        id: _nextId++,
        nombreCompleto: 'Marta Ruiz',
        area: Area.finanzas,
        puesto: 'Contadora',
        genero: Genero.femenino,
        fechaEntrada: DateTime(2022, 9, 1),
        fechaNacimiento: DateTime(1988, 11, 5),
        isActive: false,
      ),
      EmployeeModel(
        id: _nextId++,
        nombreCompleto: 'Carlos Díaz',
        area: Area.ventas,
        puesto: 'Ejecutivo',
        genero: Genero.masculino,
        fechaEntrada: DateTime(2025, 2, 20),
        isActive: true,
      ),
      EmployeeModel(
        id: _nextId++,
        nombreCompleto: 'Sofía López',
        area: Area.operaciones,
        puesto: 'Supervisora',
        genero: Genero.otro,
        fechaEntrada: DateTime(2024, 6, 12),
        isActive: true,
      ),
    ]);
  }

  /// Devuelve una copia inmutable de la lista actual.
  List<EmployeeModel> getEmployees() => List.unmodifiable(_employees);

  /// Registra un empleado: asigna `id`, fuerza `isActive = true` y lo agrega.
  EmployeeModel register(EmployeeModel employee) {
    final created = employee.copyWith(id: _nextId++, isActive: true);
    _employees.add(created);
    return created;
  }

  /// Invierte el estado del empleado dado; devuelve el modelo actualizado.
  /// Lanza `StateError` si el `id` no existe.
  EmployeeModel toggle(int id) {
    final index = _employees.indexWhere((e) => e.id == id);
    if (index == -1) {
      throw StateError('Employee not found: $id');
    }
    final updated = _employees[index].copyWith(isActive: !_employees[index].isActive);
    _employees[index] = updated;
    return updated;
  }
}