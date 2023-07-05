import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_bloc.dart';
import 'package:fluttertodoapi/helper/extension/validation_helper.dart';
import 'package:fluttertodoapi/model/user_model.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/btn_widget.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';

import '../../../bloc/login_methods_bloc.dart/login_events.dart';
import '../../../bloc/login_methods_bloc.dart/login_states.dart';
import '../../../helper/constant/string_helper.dart';
import '../../../helper/utils/dialogue_utils.dart';
import '../home_screen.dart';

class EditUser extends StatefulWidget {
  EditUser({super.key, required this.user});
  UserModel user;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  TextEditingController nameCNTRL = TextEditingController();

  TextEditingController userNameCNTRL = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  ImageSource? imgSRC;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add Your Code here.
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: BlocBuilder<LoginBloc, LoginStates>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      state.img == null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(widget.user.photo!))
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
                  SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    hint: StringHelper.NAME,
                    cntrl: nameCNTRL..text = widget.user.name ?? "",
                    validator: (v) =>
                        '$v'.isRequired() ? null : StringHelper.VALIDITY,
                  ),
                  SizedBox(),
                  SizedBox(
                    height: 5,
                  ),
                  MyTextField(
                    hint: StringHelper.USERNAME,
                    cntrl: userNameCNTRL..text = widget.user.username ?? "",
                    validator: (v) =>
                        '$v'.isRequired() ? null : StringHelper.VALIDITY,
                  ),
                  SizedBox(),
                  Container(
                    width: double.infinity,
                    child: ButtonWidget(
                        btnText: "Update",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            bloc.add(UpdateUser(
                                name: nameCNTRL.text,
                                uName: userNameCNTRL.text,
                                img: state.img,
                                photoURL: widget.user.photo!));

                            //navigate
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) => const HomeScreen()),
                                ),
                                (Route<dynamic> route) => false);
                          }
                        }),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
