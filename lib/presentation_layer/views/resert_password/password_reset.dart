import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_bloc.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_states.dart';
import 'package:fluttertodoapi/helper/constant/string_helper.dart';
import 'package:fluttertodoapi/helper/extension/validation_helper.dart';
import '../../../bloc/login_methods_bloc.dart/login_events.dart';
import '../../../helper/constant/dimensions.dart';
import '../../../helper/constant/screen_percentage.dart';
import '../../widgets/btn_widget.dart';
import '../../widgets/sizedBox.dart';
import '../../widgets/text_field.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController passreset = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passreset.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginBloc, LoginStates>(
        builder: (context, state) {
          return Center(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextField(
                      cntrl: passreset,
                      hint: StringHelper.RESET_PASSWORD,
                      validator: (v) =>
                          ('$v'.isRequired() && '$v'.isValidEmail())
                              ? null
                              : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    SizeBoxWidget(
                      widths: double.infinity,
                      heights:
                          ScreenPercentage.SCREEN_SIZE_100 * Dimensions.D_40,
                      childs: ButtonWidget(
                        btnText: StringHelper.RESET_PASSWORD,
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            BlocProvider.of<LoginBloc>(context).add(
                                PassworsReset(
                                    email: passreset.text, context: context));
                            // bloc.add(LoginEvnts(
                            //     emailCotroller.text, passwordController.text, context));
                            // if (state.status == LoginStatus.login) {
                            //   Navigator.pushReplacement(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: ((context) => const HomeScreen())));
                            // }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
