import '../../enums/status_enum.dart';

class RemoteConfigState {
  RemoteConfigState({
    this.status = Status.initial,
    this.data,
  });

  final Status status;
  String? data;

  RemoteConfigState copyWith({
    Status? status,
    String? data,
  }) {
    return RemoteConfigState(
      status: status ?? this.status,
      data: data ?? this.data,
    );
  }
}
