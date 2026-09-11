import 'package:get_it/get_it.dart';

import '../../features/employees/data/datasources/mock_employee_data_source.dart';
import '../../features/employees/data/repositories/employee_repository_impl.dart';
import '../../features/employees/domain/repositories/employee_repository.dart';
import '../../features/employees/domain/usecases/get_employees.dart';
import '../../features/employees/domain/usecases/register_employee.dart';
import '../../features/employees/domain/usecases/toggle_employee_status.dart';

/// Contenedor de dependencias (get_it manual, sin código generado).
final GetIt getIt = GetIt.instance;

void setupLocator() {
  // Data layer
  getIt
    ..registerLazySingleton<MockEmployeeDataSource>(MockEmployeeDataSource.new)
    ..registerLazySingleton<EmployeeRepository>(
      () => EmployeeRepositoryImpl(getIt<MockEmployeeDataSource>()),
    );

  // Use cases
  getIt
    ..registerLazySingleton<GetEmployees>(
      () => GetEmployees(getIt<EmployeeRepository>()),
    )
    ..registerLazySingleton<RegisterEmployee>(
      () => RegisterEmployee(getIt<EmployeeRepository>()),
    )
    ..registerLazySingleton<ToggleEmployeeStatus>(
      () => ToggleEmployeeStatus(getIt<EmployeeRepository>()),
    );

  // Los cubits de presentación se registran como Factory en sus fases
  // (EmployeeFormCubit y EmployeeListCubit).
}