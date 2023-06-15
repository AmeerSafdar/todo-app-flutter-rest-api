// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:fluttertodoapi/helper/constant/string_helper.dart';
import 'package:fluttertodoapi/presentation_layer/widgets/text_widget.dart';

import '../../bloc/get_data_bloc/fetch_data_bloc.dart';
import '../../bloc/get_data_bloc/fetch_data_event.dart';
import '../widgets/text_field.dart';

class AddTodoData extends StatefulWidget {
  FetchTodoBloc bloc;
  AddTodoData({super.key, required this.bloc});

  @override
  State<AddTodoData> createState() => _AddTodoDataState();
}

class _AddTodoDataState extends State<AddTodoData> {
  TextEditingController titleCntrl = TextEditingController();

  TextEditingController descContrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyTextWidget(text: StringHelper.ADD_TODO),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
            child: Column(
          children: [
            MyTextField(
              cntrl: titleCntrl,
              hint: 'Title',
            ),
            const SizedBox(
              height: 10,
            ),
            MyTextField(
              cntrl: descContrl,
              hint: 'Description',
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  if (descContrl.text.isNotEmpty &&
                      titleCntrl.text.isNotEmpty) {
                    widget.bloc.add(AddData(
                        description: descContrl.text, title: titleCntrl.text));
                    descContrl.text = '';
                    titleCntrl.text = '';
                    Navigator.of(context).pop();
                  }
                },
                child: MyTextWidget(text: 'Submit '))
          ],
        )),
      )),
    );
  }
}
