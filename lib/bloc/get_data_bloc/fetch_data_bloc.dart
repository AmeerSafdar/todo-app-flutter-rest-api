// ignore_for_file: use_rethrow_when_possible

import 'package:fluttertodoapi/bloc/get_data_bloc/fetch_data_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/repository/api_data_repo/api_data_implements.dart';
import '../../enums/status_enum.dart';
import '../../model/todos_model.dart';
import 'fetch_data_event.dart';

class FetchTodoBloc extends Bloc<TodoEvents, FetchTodo> {
  List<TodosApi>? data;
  TodosFetch todoData = TodosFetch();
  FetchTodoBloc() : super(FetchTodo()) {
    on<GetData>(_getApiData);
    on<AddData>(_addData);
    on<DeleteTodo>(_delete);
    on<UpdateData>(_updateData);
    on<Notify>(_notify);
  }

  void _notify(Notify event, Emitter<FetchTodo> emit) {
    print('notification bloc');
    todoData.sendNotification();
  }

  void _updateData(UpdateData event, Emitter<FetchTodo> emit) {
    try {
      todoData.update(event.title, event.description, event.sID);
      emit(state.copyWith(status: Status.updated));
    } catch (e) {
      throw e;
    }
  }

  void _delete(DeleteTodo event, Emitter<FetchTodo> emit) {
    try {
      todoData.deleteData(event.sID);
      emit(state.copyWith(status: Status.deleted));
    } catch (e) {
      throw e;
    }
  }

  void _addData(AddData event, Emitter<FetchTodo> emit) {
    try {
      todoData.submitData(event.title, event.description);
    } catch (e) {
      throw e;
    }
  }

  void _getApiData(GetData event, Emitter<FetchTodo> emit) async {
    try {
      emit(state.copyWith(status: Status.loading));
      data = await todoData.fetchTodos();
      emit(state.copyWith(
        status: Status.success,
        data: data,
      ));
    } catch (e) {
      emit(state.copyWith(status: Status.error));
    }
  }
}
