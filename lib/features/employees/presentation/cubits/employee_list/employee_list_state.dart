import 'package:equatable/equatable.dart';

import '../../../domain/entities/employee.dart';

/// Estado de la lista de empleados (US2).
sealed class EmployeeListState extends Equatable {
  const EmployeeListState();

  @override
  List<Object?> get props => const [];
}

class EmployeeListLoading extends EmployeeListState {
  const EmployeeListLoading();
}

class EmployeeListLoaded extends EmployeeListState {
  const EmployeeListLoaded(this.employees);

  final List<Employee> employees;

  @override
  List<Object?> get props => [employees];
}

class EmployeeListError extends EmployeeListState {
  const EmployeeListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}