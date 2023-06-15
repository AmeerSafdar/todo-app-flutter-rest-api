abstract class TodoEvents {}

class GetData extends TodoEvents {}

class Notify extends TodoEvents {}

class AddData extends TodoEvents {
  String title, description;
  AddData({required this.title, required this.description});
}

class DeleteTodo extends TodoEvents {
  String sID;
  DeleteTodo({
    required this.sID,
  });
}

class UpdateData extends TodoEvents {
  String title, description, sID;
  UpdateData(
      {required this.description, required this.title, required this.sID});
}
