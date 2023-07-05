import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertodoapi/bloc/get_data_bloc/fetch_data_event.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_bloc.dart';
import 'package:fluttertodoapi/bloc/login_methods_bloc.dart/login_states.dart';
import 'package:fluttertodoapi/helper/constant/const.dart';
import 'package:fluttertodoapi/helper/constant/dimensions.dart';
import 'package:fluttertodoapi/helper/constant/string_helper.dart';
import 'package:fluttertodoapi/presentation_layer/views/login_screen/loginScreen.dart';
import 'package:fluttertodoapi/presentation_layer/views/update/update_user.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/sizedBox.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_widget.dart';

import '../../bloc/get_data_bloc/fetch_data_bloc.dart';
import '../../bloc/get_data_bloc/fetch_data_states.dart';
import '../../bloc/login_methods_bloc.dart/login_events.dart';
import '../../helper/constant/iconhelper.dart';
import '../../helper/utils/dialogue_utils.dart';
import '../../model/todos_model.dart';
import 'add_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FetchTodoBloc>(context).add(GetData());
    BlocProvider.of<LoginBloc>(context).add(UserDataEvent());
    firebaseMessaging.getToken().then((tokenDev) {
      token = tokenDev.toString();
      debugPrint("token is: $token");
    });
  }

  RenderObject? overlay;
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    overlay = Overlay.of(context).context.findRenderObject();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FetchTodoBloc>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => AddTodoData(
                        bloc: bloc,
                      ))));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        centerTitle: false,
        title: BlocBuilder<LoginBloc, LoginStates>(
          builder: (context, state) {
            return Row(
              children: [
                state.userModel != null
                    ? GestureDetector(
                        onTap: () {
                          print("user model tapped");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => EditUser(
                                        user: state.userModel!,
                                      ))));
                        },
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage:
                              NetworkImage(state.userModel!.photo!),
                        ),
                      )
                    : CircleAvatar(
                        radius: 20, backgroundImage: NetworkImage(userIMG)),
                SizeBoxWidget(
                  widths: 5,
                ),
                MyTextWidget(
                    text: state.userModel?.name ?? StringHelper.TODOS_LIST),
              ],
            );
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<FetchTodoBloc>(context).add(Notify());

                // child: Container(),

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: ((context) => AddTodoData(
                //               bloc: bloc,
                //             ))));
              },
              icon: IconHelper.addIcon),
          IconButton(
              onPressed: () {
                // BlocListener<LoginBloc, LoginStates>(
                //   listener: (context, state) {
                BlocProvider.of<LoginBloc>(context).add(
                  LogoutEvents(cntxt: context),
                  // },
                  // child: Container(),
                );
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => LoginScreen()),
                    ),
                    (Route<dynamic> route) => false);
              },
              icon: IconHelper.logOut)
        ],
      ),
      body: SafeArea(
          //
          child: BlocBuilder<FetchTodoBloc, FetchTodo>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: getData,
            child: Visibility(
              visible: state.data.isNotEmpty,
              replacement: const Center(child: CircularProgressIndicator()),
              child: ListView.builder(
                  itemCount: state.data.length,
                  itemBuilder: (context, index) {
                    var myTodo = state.data[index];
                    return Card(
                      child: InkWell(
                        onTapDown: (details) => _getTapPosition(details),
                        onLongPress: () async {
                          overlay =
                              Overlay.of(context).context.findRenderObject();
                          await menuBar(context, bloc, index, myTodo);
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            child: MyTextWidget(text: index.toString()),
                          ),
                          title: MyTextWidget(text: myTodo.title!),
                          subtitle: MyTextWidget(text: myTodo.description!),
                        ),
                      ),
                    );
                  }),
            ),
          );
        },
      )),
    );
  }

  Future<void> getData() async {
    BlocProvider.of<FetchTodoBloc>(context).add(GetData());
  }

  Future<int?> menuBar(
      BuildContext context, FetchTodoBloc bloc, int index, TodosApi todo) {
    return showMenu(
      context: context,
      position: RelativeRect.fromRect(
          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay!.paintBounds.size.height)),
      items: [
        PopupMenuItem(
            onTap: () {
              bloc.add(DeleteTodo(sID: todo.sId!));
              bloc.add(GetData());
            },
            value: 1,
            child: MyTextWidget(text: StringHelper.DELETE)),
        PopupMenuItem(
            onTap: () async {
              int? updatedval = await Future.delayed(Duration.zero, () {
                return showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: ((context) => DialogUtils.dialogBox(
                        context, todo.title!, todo.description!)));
              });
              if (updatedval != null && updatedval == 1) {
                bloc.add(UpdateData(
                    description: desCUpdatecontroller.text,
                    title: titleUpdatecontroller.text,
                    sID: todo.sId!));
                bloc.add(GetData());
              }
            },
            value: 2,
            child: MyTextWidget(text: StringHelper.EDIT)),
      ],
      elevation: Dimensions.D_8,
    );
  }
}
