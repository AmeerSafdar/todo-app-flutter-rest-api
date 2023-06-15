import '../../enums/status_enum.dart';
import '../../model/todos_model.dart';

class FetchTodo {
  FetchTodo({
    this.status = Status.initial,
    this.data = const <TodosApi>[],
  });

  final Status status;
  final List<TodosApi> data;

  FetchTodo copyWith({
    Status? status,
    List<TodosApi>? data,
  }) {
    return FetchTodo(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
