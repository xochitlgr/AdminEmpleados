import 'package:flutter_test/flutter_test.dart';
import 'package:employee_app/features/employees/data/datasources/mock_employee_data_source.dart';
import 'package:employee_app/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:employee_app/features/employees/domain/entities/employee.dart';

void main() {
  group('EmployeeRepositoryImpl', () {
    late EmployeeRepositoryImpl repository;
    late MockEmployeeDataSource dataSource;

    setUp(() {
      dataSource = MockEmployeeDataSource();
      repository = EmployeeRepositoryImpl(dataSource);
    });

    test('getEmployees devuelve los 5 seeds', () async {
      final employees = await repository.getEmployees();

      expect(employees, hasLength(5));
      expect(employees.first.nombreCompleto, 'Ana García');
    });

    test('registerEmployee persiste y devuelve el empleado creado', () async {
      final created = await repository.registerEmployee(
        Employee(
          id: 0,
          nombreCompleto: 'Laura Vega',
          area: Area.administracion,
          puesto: 'Asistente',
          genero: Genero.femenino,
          fechaEntrada: DateTime(2026, 2, 1),
        ),
      );

      expect(created.id, 6);
      expect(created.isActive, isTrue);
      final all = await repository.getEmployees();
      expect(all, hasLength(6));
      expect(all.last.nombreCompleto, 'Laura Vega');
    });

    test('toggleEmployeeStatus persiste en el mock', () async {
      final all = await repository.getEmployees();
      final target = all.firstWhere((e) => e.isActive);

      final toggled = await repository.toggleEmployeeStatus(target.id);

      expect(toggled.isActive, isFalse);
      final after = await repository.getEmployees();
      expect(after.firstWhere((e) => e.id == target.id).isActive, isFalse);
    });

    test('toggleEmployeeStatus propaga StateError si el id no existe', () async {
      expect(
        repository.toggleEmployeeStatus(999),
        throwsStateError,
      );
    });
  });
}