import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/enums/status_enum.dart';
import '../../repository/api_data_repo/api_data_implements.dart';
import 'remote_event.dart';
import 'remote_states.dart';

class FetchRemoteBlocData extends Bloc<RemoteEvents, RemoteConfigState> {
  FetchRemoteBlocData() : super(RemoteConfigState()) {
    on<FetchRemoteData>(_retrieveData);
  }

  void _retrieveData(
      FetchRemoteData event, Emitter<RemoteConfigState> emit) async {
    try {
      TodosFetch todoData = TodosFetch();
      String? b = await todoData.initConfig();
      emit(state.copyWith(status: Status.success, data: b));
    } catch (e) {
      debugPrint("error: ${e.toString()}");
    }
  }
}
