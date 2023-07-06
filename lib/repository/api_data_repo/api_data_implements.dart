// ignore_for_file: unused_field, unused_local_variable, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, unnecessary_string_interpolations

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fluttertodoapi/helper/constant/const.dart';
import 'package:fluttertodoapi/model/todos_model.dart';
import 'package:fluttertodoapi/repository/API/api.dart';

import '../../helper/constant/common_keys.dart';

class TodosFetch {
  final API _api = API();
  Future<List<TodosApi>> fetchTodos() async {
    Response response = await _api.sendRequest.get(
      CommonKey.TODOS,
    );
    List<dynamic> todos = response.data[CommonKey.ITEMS];
    List<TodosApi> _todolist =
        todos.map((todos) => TodosApi.fromJson(todos)).toList();
    return _todolist;
  }

  void update(String title, String desc, String id) async {
    Response res = await _api.sendRequest.put("${CommonKey.TODOS}/$id",
        data: {"title": title, "description": desc, "is_completed": false},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ));
  }

  void deleteData(String id) async {
    Response res = await _api.sendRequest.delete("${CommonKey.TODOS}/$id",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ));
  }

  void submitData(String title, String subTitle) async {
    try {
      await _api.sendRequest.post(
        CommonKey.TODOS,
        data: {"title": title, "description": subTitle, "is_completed": false},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      //add to firebase realtime

      addRealtimeData(title, subTitle);
    } catch (e) {
      rethrow;
    }
  }

  void sendNotification() async {
    print('notification send');

    String server_key =
        'AAAA49FMREg:APA91bHP3oxTDp0BXbpmf1IrAZ7R1GXc7ZHNG6dAYYL4SwjYXn4bynckIxVAOqDjRrE3o9X9VuexN_i_NF_kYyMb8W2tnr2kaCWhsG-ofbPdUGPHX6u162DieEY1zhIzbace5FTgvOyQ';
    try {
      Response res = await dio.post(
        'https://fcm.googleapis.com/fcm/send',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "key=$server_key"
          },
        ),
        data: {
          "notification": <String, dynamic>{
            "body": "This is test notification",
            "title": "This is testing",
            "android_channel_id": "high_importance_channel",
            "image":
                "https://cdn2.vectorstock.com/i/1000x1000/23/91/small-size-emoticon-vector-9852391.jpg",
            "sound": true
          },
          "priority": "high",
          "data": {
            // 'scheduledTime': '2023-06-15 16:55:10',
            //(DateTime('2023-6-15,10, 17, 35')),
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "id": "1",
            "status": "done"
          },
          "to": "$token"
        },
      );

      print('notification response is $res');
    } catch (e) {
      print(e);
    }
  }

  // firebase Remote Data config

  Future<String?> initConfig() async {
    String? a;
    try {
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 1),
        minimumFetchInterval: const Duration(seconds: 5),
      ));

      _fetchConfig();
      a = remoteConfig.getString("btn_text");
      print(" a value from remote config: $a");
      return a;
    } catch (err) {
      // throw err;
      print(" a value from remote config1: $a");
      print("error is :${err.toString()}");
    }
    return a;
  }

  void _fetchConfig() async {
    await remoteConfig.fetchAndActivate();
  }

  addRealtimeData(String title, String subTitle) {
    try {
      databaseReference
          .child("devteam")
          .set({"title": title, "subTitle": subTitle});
    } catch (e) {
      print(e.toString());
    }

    readData();
  }

  updateRealtimeData(String title, String subTitle) {
    try {
      databaseReference
          .child("devteam")
          .update({"title": title, "subTitle": subTitle});
    } catch (e) {
      print(e.toString());
    }
  }

  void readData() async {
    DatabaseEvent event = await databaseReference.once();
    print("data is:${event.snapshot.value}");
  }
}
