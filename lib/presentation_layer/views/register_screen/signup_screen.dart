import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:fluttertodoapi/bloc/login_methods_bloc.dart/login_events.dart";
import "package:fluttertodoapi/bloc/login_methods_bloc.dart/login_states.dart";
import "package:fluttertodoapi/enums/login.dart";
import "package:fluttertodoapi/helper/constant/dimensions.dart";
import "package:fluttertodoapi/helper/constant/string_helper.dart";
import "package:fluttertodoapi/helper/extension/validation_helper.dart";
import "package:fluttertodoapi/presentation_layer/widgets/btn_widget.dart";
import "package:image_picker/image_picker.dart";

import "../../../bloc/login_methods_bloc.dart/login_bloc.dart";
import "../../../helper/constant/const.dart";
import "../../../helper/utils/dialogue_utils.dart";
import "../../widgets/sizedBox.dart";
import "../../widgets/text_field.dart";
import "../home_screen.dart";

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameCNTRL = TextEditingController();

  TextEditingController userNameCNTRL = TextEditingController();

  TextEditingController emailCntrl = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ImageSource? imgSRC;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameCNTRL.dispose();
    userNameCNTRL.dispose();
    emailCntrl.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Center(
        child: BlocBuilder<LoginBloc, LoginStates>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        state.img == null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(userIMG))
                            : CircleAvatar(
                                radius: 50,
                                backgroundImage: FileImage(state.img!),
                              ),
                        Positioned(
                          bottom: 2,
                          right: -6,
                          child: IconButton(
                              onPressed: () async {
                                imgSRC = await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        DialogUtils.imagePickDialog(context));
                                print("images source is $imgSRC");
                                switch (imgSRC) {
                                  case ImageSource.camera:
                                    bloc.add(PickImagesEvent(imgSRC: imgSRC));
                                    return;

                                  case ImageSource.gallery:
                                    bloc.add(PickImagesEvent(imgSRC: imgSRC));
                                    return;
                                  default:
                                    break;
                                }
                              },
                              icon: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              )),
                        )
                      ],
                    ),
                    SizeBoxWidget(
                      heights: 20,
                    ),
                    MyTextField(
                      hint: StringHelper.NAME,
                      cntrl: nameCNTRL,
                      validator: (v) =>
                          '$v'.isRequired() ? null : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    MyTextField(
                      hint: StringHelper.USERNAME,
                      cntrl: userNameCNTRL,
                      validator: (v) =>
                          '$v'.isRequired() ? null : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    MyTextField(
                      hint: StringHelper.EMAIL,
                      cntrl: emailCntrl,
                      validator: (v) =>
                          ('$v'.isRequired() && '$v'.isValidEmail())
                              ? null
                              : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    MyTextField(
                      obsecureTxt: true,
                      hint: StringHelper.PASSWORD,
                      cntrl: passwordController,
                      validator: (v) =>
                          '$v'.isRequired() ? null : StringHelper.VALIDITY,
                    ),
                    SizeBoxWidget(),
                    Container(
                        width: double.infinity,
                        child:
                            // state.status == LoginStatus.loading
                            //     ? Container(
                            //         height: Dimensions.D_10,
                            //         child: const CircularProgressIndicator())
                            //     :
                            ButtonWidget(
                                btnText: "Register",
                                press: () {
                                  if (_formKey.currentState!.validate() &&
                                      state.img != null) {
                                    BlocProvider.of<LoginBloc>(context).add(
                                        RegisterEvents(
                                            name: nameCNTRL.text,
                                            uName: userNameCNTRL.text,
                                            email: emailCntrl.text,
                                            password: passwordController.text,
                                            img: state.img,
                                            context: context));
                                    // if (state.status == LoginStatus.login) {
                                    //   Navigator.pushAndRemoveUntil(
                                    //       context,
                                    //       MaterialPageRoute(
                                    //         builder: ((context) =>
                                    //             const HomeScreen()),
                                    //       ),
                                    //       (Route<dynamic> route) => false);
                                    // }
                                  }
                                }))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
