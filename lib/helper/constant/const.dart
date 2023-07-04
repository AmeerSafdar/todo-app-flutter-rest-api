// ignore_for_file: constant_identifier_names

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapi/services/notification_helper/notifyHelper.dart';

TextEditingController titleUpdatecontroller = TextEditingController();
TextEditingController desCUpdatecontroller = TextEditingController();

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

String token = '';
var userID = '';

final dio = Dio();
NotificationHelper notifyHelper = NotificationHelper();

const String API_URL = 'http://api.nstack.in/v1/';
