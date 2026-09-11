import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class GetEmployees {
  const GetEmployees(this._repository);

  final EmployeeRepository _repository;

  Future<List<Employee>> call() => _repository.getEmployees();
}