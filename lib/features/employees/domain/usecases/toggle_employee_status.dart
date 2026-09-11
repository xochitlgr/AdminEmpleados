import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class ToggleEmployeeStatus {
  const ToggleEmployeeStatus(this._repository);

  final EmployeeRepository _repository;

  Future<Employee> call(int id) => _repository.toggleEmployeeStatus(id);
}