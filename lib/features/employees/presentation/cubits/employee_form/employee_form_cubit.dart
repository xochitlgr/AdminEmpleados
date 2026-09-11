import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/employee.dart';
import '../../../domain/usecases/register_employee.dart';
import 'employee_form_state.dart';

class EmployeeFormCubit extends Cubit<EmployeeFormState> {
  EmployeeFormCubit(this._registerEmployee) : super(const EmployeeFormInitial());

  final RegisterEmployee _registerEmployee;

  /// Registra un empleado validado por el formulario.
  Future<void> submit(Employee employee) async {
    emit(const EmployeeFormSubmitting());
    try {
      await _registerEmployee.call(employee);
      emit(const EmployeeFormSuccess());
    } on Exception {
      emit(
        const EmployeeFormError(
          'No se pudo registrar el empleado. Inténtalo de nuevo.',
        ),
      );
    }
  }
}