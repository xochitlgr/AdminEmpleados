import 'package:equatable/equatable.dart';

/// Estado del formulario de registro de empleado.
sealed class EmployeeFormState extends Equatable {
  const EmployeeFormState();

  @override
  List<Object?> get props => const [];
}

class EmployeeFormInitial extends EmployeeFormState {
  const EmployeeFormInitial();
}

class EmployeeFormSubmitting extends EmployeeFormState {
  const EmployeeFormSubmitting();
}

class EmployeeFormSuccess extends EmployeeFormState {
  const EmployeeFormSuccess();
}

class EmployeeFormError extends EmployeeFormState {
  const EmployeeFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}