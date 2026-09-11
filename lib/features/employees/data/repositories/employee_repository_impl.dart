import '../../domain/entities/employee.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/mock_employee_data_source.dart';
import '../models/employee_model.dart';

/// Adaptador del puerto `EmployeeRepository` sobre el data source mock.
class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl(this._dataSource);

  final MockEmployeeDataSource _dataSource;

  @override
  Future<List<Employee>> getEmployees() async {
    return _dataSource.getEmployees();
  }

  @override
  Future<Employee> registerEmployee(Employee employee) async {
    return _dataSource.register(EmployeeModel.fromEmployee(employee));
  }

  @override
  Future<Employee> toggleEmployeeStatus(int id) async {
    return _dataSource.toggle(id);
  }
}