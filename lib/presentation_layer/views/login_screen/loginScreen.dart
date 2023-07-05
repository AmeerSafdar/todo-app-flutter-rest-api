import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/bloc/fetchRemoteData/remote_bloc.dart';
import 'package:fluttertodoapi/bloc/fetchRemoteData/remote_states.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_bloc.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_states.dart';
import 'package:fluttertodoapi/enums/login.dart';
import 'package:fluttertodoapi/helper/constant/dimensions.dart';
import 'package:fluttertodoapi/helper/constant/screen_percentage.dart';
import 'package:fluttertodoapi/helper/constant/string_helper.dart';
import 'package:fluttertodoapi/helper/extension/validation_helper.dart';
import 'package:fluttertodoapi/presentation_layer/views/home_screen.dart';
import 'package:fluttertodoapi/presentation_layer/views/register_screen/signup_screen.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/sizedBox.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_field.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_widget.dart';

import '../../../bloc/fetchRemoteData/remote_event.dart';
import '../../../bloc/get_data_bloc/fetch_data_bloc.dart';
import '../../../bloc/login_methods_bloc.dart/login_events.dart';
import '../../widgets/btn_widget.dart';
import '../resert_password/password_reset.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCotroller = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<FetchRemoteBlocData>(context).add(FetchRemoteData());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailCotroller.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: SafeArea(child: Center(
        child: BlocBuilder<LoginBloc, LoginStates>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      hint: StringHelper.EMAIL,
                      cntrl: emailCotroller,
                      validator: (v) =>
                          ('$v'.isRequired() && '$v'.isValidEmail())
                              ? null
                              : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    MyTextField(
                      hint: StringHelper.PASSWORD,
                      cntrl: passwordController,
                      validator: (v) =>
                          '$v'.isRequired() ? null : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    SizeBoxWidget(
                      widths: double.infinity,
                      heights:
                          ScreenPercentage.SCREEN_SIZE_100 * Dimensions.D_40,
                      childs: ButtonWidget(
                        btnText: StringHelper.LOGIN,
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            bloc.add(LoginEvnts(emailCotroller.text,
                                passwordController.text, context));
                            // if (state.status == LoginStatus.login) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => const HomeScreen())),
                                (Route<dynamic> route) => false);
                            // }
                          }
                        },
                      ),
                    ),
                    SizeBoxWidget(),
                    SizeBoxWidget(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: "Don't have an account? ",
                              style: DefaultTextStyle.of(context)
                                  .style
                                  .copyWith(fontWeight: FontWeight.w500),
                              children: [
                                TextSpan(
                                    text: "SIGN UP",
                                    style: const TextStyle(
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    SignUpScreen())));
                                        // navigate to desired screen
                                      }),
                              ]),
                        ),
                        // TextButton(
                        //     onPressed: () {},
                        //     child: MyTextWidget(
                        //         text: "Don\'t have an account ? Signup"))
                      ],
                    ),

                    SizeBoxWidget(),

                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ResetPassword())));
                        },
                        child: MyTextWidget(text: StringHelper.FORGOT_PASSWORD))
                    // BlocBuilder<FetchRemoteBlocData, RemoteConfigState>(
                    //   builder: (context, remState) {
                    //     if (remState.data == null) {
                    //       return MyTextWidget(text: "No Data");
                    //     } else {
                    //       return MyTextWidget(text: remState.data!);
                    //     }
                    //     // return remState.data!.isNotEmpty
                    //     //     ? Container(
                    //     //         child: MyTextWidget(text: remState.data!),
                    //     //       )
                    //     //     : Container(
                    //     //         child: MyTextWidget(text: "No data Found"),
                    //     //       );
                    //   },
                    // )
                  ],
                ),
              ),
            );
          },
        ),
      )),
    );
  }
}
