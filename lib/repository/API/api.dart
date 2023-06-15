// ignore_for_file: prefer_final_fields

import 'package:dio/dio.dart';

import '../../helper/constant/const.dart';

class API {
  Dio _dio = dio;

  API() {
    _dio.options.baseUrl = API_URL;
  }

  Dio get sendRequest => _dio;
}
