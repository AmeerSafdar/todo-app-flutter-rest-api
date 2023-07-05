// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/presentation_layer/views/login_screen/loginScreen.dart';
import 'package:fluttertodoapi/services/notification_helper/notifyHelper.dart';

import 'bloc/fetchRemoteData/remote_bloc.dart';
import 'bloc/get_data_bloc/fetch_data_bloc.dart';
import 'bloc/login_methods_bloc.dart/login_bloc.dart';
import 'helper/constant/const.dart';
import 'presentation_layer/views/home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  notifyHelper.getMessage();
  Future.delayed(const Duration(seconds: 2)).then((value) {
    FlutterNativeSplash.remove();
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    if (auth.currentUser != null) {
      userID = FirebaseAuth.instance.currentUser!.uid;
    }
    print("user id is $userID");
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<FetchTodoBloc>(create: ((context) => FetchTodoBloc())),
          BlocProvider<LoginBloc>(create: ((context) => LoginBloc())),
          BlocProvider<FetchRemoteBlocData>(
              create: ((context) => FetchRemoteBlocData()))
        ],
        child: GestureDetector(
          onTap: () {
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter TODO API',
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              home: StreamBuilder(
                  stream: auth.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        if (userID == null || userID == '') {
                          return LoginScreen();
                        } else {
                          return const HomeScreen();
                        }
                      } else if (snapshot.hasError) {
                        return Center(child: Text('${snapshot.error}'));
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    }
                    return (userID == null || userID == '')
                        ? LoginScreen()
                        : const HomeScreen();
                  })
              // const HomeScreen(),
              ),
        ));
  }
}
