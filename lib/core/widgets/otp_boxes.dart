import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpBoxes extends StatefulWidget{
  final TextEditingController controller;
  final void Function(String)? onCompleted;

  const OtpBoxes({super.key,required this.controller,this.onCompleted});

  @override
  State<OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<OtpBoxes> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg
      ),
      child: PinCodeTextField(
          appContext: context,
          length: 6,
          controller: widget.controller,
          keyboardType: TextInputType.number,
          autoFocus: true,
          cursorColor: Colors.black,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(12),
            fieldHeight: 50,
            fieldWidth: 50,
            activeFillColor: AppColors.scaffoldBg,
            selectedColor: AppColors.primary,
            selectedFillColor: AppColors.secondary,
            inactiveFillColor:AppColors.scaffoldBg,
            inactiveColor: Colors.grey.shade400,
            activeColor: AppColors.primaryDark,
            disabledColor: Colors.grey.shade100
          ),
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          onChanged: (value){
          },
          onCompleted:(value){
            if(widget.onCompleted!=null){
              widget.onCompleted!(value);
            }
            //verify otp
          },
        ),
    );
  }
}