// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/utils/permission_utils.dart';
import 'package:fluttertodoapi/model/user_model.dart';
import 'package:fluttertodoapi/services/notification_helper/notifyHelper.dart';

TextEditingController titleUpdatecontroller = TextEditingController();
TextEditingController desCUpdatecontroller = TextEditingController();

FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

String token = '';
var userID = '';
UserModel? data_user;
final dio = Dio();

NotificationHelper notifyHelper = NotificationHelper();
PermissionUtils permissionUtils = PermissionUtils();

const String API_URL = 'http://api.nstack.in/v1/';

const String userIMG =
    "https://cdn.pixabay.com/photo/2014/04/03/10/32/user-310807_640.png";
