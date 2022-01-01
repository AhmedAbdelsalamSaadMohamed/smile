import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class GenderRadioWidget extends StatefulWidget {
  GenderRadioWidget({Key? key, required this.onChange, required this.gender })
      : super(key: key);
  final Function(String value) onChange;
   String gender;

  @override
  State<GenderRadioWidget> createState() => _GenderRadioWidgetState();
}

class _GenderRadioWidgetState extends State<GenderRadioWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: RadioListTile<String>(
            title: Text('Male'.tr),
            value: 'male',
            groupValue: widget.gender,
            onChanged: (String? value) {
              setState(() {
                widget.gender = value!;
                widget.onChange(value.toString());
              });
            },
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: RadioListTile<String>(
            title: Text('Female'.tr),
            value: 'female',
            groupValue: widget.gender,
            onChanged: (String? value) {
              setState(() {
                widget.gender = value!;
                widget.onChange(value.toString());
              });
            },
          ),
        ),
      ],
    );
  }
}
