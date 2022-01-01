import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:smile/model/user_model.dart';
import 'package:smile/view/pages/profile_page.dart';
import 'package:smile/view/widgets/custom_text_form_field_widget.dart';
import 'package:smile/view/widgets/gender_radio_widget.dart';

class CompleteSocialSignUp extends StatefulWidget {
  CompleteSocialSignUp({
    Key? key,
    required this.user,
    this.action = 'add',
  }) : super(key: key) ;

  String action;
   final UserModel user;

  @override
  State<CompleteSocialSignUp> createState() => _CompleteSocialSignUpState();
}

class _CompleteSocialSignUpState extends State<CompleteSocialSignUp> {
  DateTime? birthdate;
 // final UserViewModel userController = Get.find<UserViewModel>();

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _formKy = GlobalKey<FormState>();
    widget.user.username = widget.user.username?? '@'+ (widget.user.name?.replaceAll(' ', '')??'');
    return Scaffold(
      //appBar: AppBar(title: const Text('Complete Sign up'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Form(
          key: _formKy,
          child: ListView(
            children: [
              CustomTextFormFieldWidget(
                hint: 'Name'.tr,
                value: widget.user.name,
                validator: Validator.name,
                onChange: (newValue) {
                  widget.user.name = newValue;
                },
                onSaved: (newValue) {
                  widget.user.name = newValue;
                },
              ),
              const SizedBox(height: 20),
              GenderRadioWidget(
                gender: widget.user.gender??'male',
                onChange: (value) {
                  widget.user.gender = value;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                value: widget.user.username,
                validator: Validator.newUsername,
                hint: '@username'.tr,
                onChange:(newValue) {
                  widget.user.username = newValue;
                } ,
                onSaved: (newValue) {
                  widget.user.username = newValue;
                },
              ),
              const SizedBox(height: 20),
              CustomTextFormFieldWidget(
                hint: 'Phone'.tr,
                validator: Validator.phone,
                value: widget.user.phone,
                onChange: (newValue) {
                  widget.user.phone = newValue;
                },
                onSaved: (newValue) {
                  widget.user.phone = newValue;
                },
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  pickDate(context);
                },
                child: Text(
                   birthdate == null
                      ? 'Birthday'.tr
                      : DateFormat('MM/dd/yyyy').format(birthdate!),

                ),
                style: ButtonStyle(
                  alignment: Alignment.centerLeft,
                  //backgroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(0),
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
          child: Text('Sign Up'.tr),
          onPressed: () {
            _formKy.currentState!.save();
            if (_formKy.currentState!.validate()) {
              authViewModel.signUp(widget.user);
            }
          }),
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: birthdate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (newDate == null) return;

    setState(() => birthdate = newDate);
  }
}
