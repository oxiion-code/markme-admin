import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markme_admin/core/theme/color_scheme.dart';

class PhoneNumberBox extends StatelessWidget{
  final TextEditingController controller;
  const PhoneNumberBox({super.key,required this.controller});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 56,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
        color:Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border:Border.all(
          color: AppColors.hint,
          width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryLight,
            blurRadius: 6,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: Row(
        children: [
          Image.asset("assets/icon/flag.png",height: 28,width: 28,),
          const SizedBox(width: 4,),
          Text("+91",style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),),
          const SizedBox(width: 6,),
      Container(
      height: 30,
      width: 1,
      color: Colors.grey.shade300,
    ),
          Expanded(
            child: TextField(
              autofocus: true,
              maxLength: 10,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Enter phone number",
                border: InputBorder.none,
                counterText: '',
                filled: true,
                fillColor: Colors.grey.shade100
              ),
            ),
          ),
        ],
      ),
    );
  }
}