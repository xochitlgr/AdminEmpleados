import '../entities/employee.dart';
import '../repositories/employee_repository.dart';

class RegisterEmployee {
  const RegisterEmployee(this._repository);

  final EmployeeRepository _repository;

  Future<Employee> call(Employee employee) =>
      _repository.registerEmployee(employee);
}