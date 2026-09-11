import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/employee.dart';
import '../../../domain/usecases/get_employees.dart';
import '../../../domain/usecases/toggle_employee_status.dart';
import 'employee_list_state.dart';

class EmployeeListCubit extends Cubit<EmployeeListState> {
  EmployeeListCubit(this._getEmployees, this._toggleEmployeeStatus)
      : super(const EmployeeListLoading());

  final GetEmployees _getEmployees;
  final ToggleEmployeeStatus _toggleEmployeeStatus;

  Future<void> load() async {
    emit(const EmployeeListLoading());
    try {
      emit(EmployeeListLoaded(await _getEmployees.call()));
    } on Exception {
      emit(const EmployeeListError('No se pudo cargar la lista de empleados.'));
    }
  }

  /// Cambia el estado visual de inmediato (optimista) y persiste en el mock.
  Future<void> toggle(Employee employee, {required bool isActive}) async {
    final current = state;
    if (current is! EmployeeListLoaded) return;

    emit(EmployeeListLoaded([
      for (final e in current.employees)
        if (e.id == employee.id) _withActive(e, isActive) else e,
    ]));

    try {
      await _toggleEmployeeStatus.call(employee.id);
    } on Exception {
      await load();
    }
  }

  Employee _withActive(Employee e, bool isActive) {
    return Employee(
      id: e.id,
      nombreCompleto: e.nombreCompleto,
      area: e.area,
      puesto: e.puesto,
      genero: e.genero,
      fechaEntrada: e.fechaEntrada,
      fechaNacimiento: e.fechaNacimiento,
      isActive: isActive,
    );
  }
}