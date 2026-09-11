import 'package:flutter_test/flutter_test.dart';
import 'package:employee_app/features/employees/data/datasources/mock_employee_data_source.dart';
import 'package:employee_app/features/employees/data/models/employee_model.dart';
import 'package:employee_app/features/employees/domain/entities/employee.dart';

void main() {
  group('MockEmployeeDataSource', () {
    late MockEmployeeDataSource dataSource;

    setUp(() {
      dataSource = MockEmployeeDataSource();
    });

    test('se precargan 5 empleados con al menos uno inactivo', () {
      final employees = dataSource.getEmployees();

      expect(employees, hasLength(5));
      expect(employees.where((e) => !e.isActive), isNotEmpty);
      expect(employees.map((e) => e.id).toSet(), hasLength(5));
    });

    test('register asigna id autoincremental y isActive = true', () {
      final created = dataSource.register(
        EmployeeModel(
          id: 0,
          nombreCompleto: 'Nuevo Empleado',
          area: Area.tecnologia,
          puesto: 'Analista',
          genero: Genero.masculino,
          fechaEntrada: DateTime(2026, 1, 1),
        ),
      );

      expect(created.id, 6);
      expect(created.isActive, isTrue);
      expect(dataSource.getEmployees(), hasLength(6));
      expect(dataSource.getEmployees().last.nombreCompleto, 'Nuevo Empleado');
    });

    test('toggle invierte el estado y persiste en la lista', () {
      final target = dataSource.getEmployees().firstWhere((e) => e.isActive);
      final previous = target.isActive;

      final toggled = dataSource.toggle(target.id);

      expect(toggled.isActive, !previous);
      expect(
        dataSource.getEmployees().firstWhere((e) => e.id == target.id).isActive,
        !previous,
      );
    });

    test('toggle con id inexistente lanza StateError', () {
      expect(() => dataSource.toggle(999), throwsStateError);
    });

    test('toggle de vuelta restaura el estado', () {
      final target = dataSource.getEmployees().firstWhere((e) => !e.isActive);
      final original = target.isActive;

      dataSource.toggle(target.id);
      final restored = dataSource.toggle(target.id);

      expect(restored.isActive, original);
    });
  });
}