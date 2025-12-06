import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markme_admin/core/widgets/app_nav_bar.dart';

class ManageClasses extends StatelessWidget {
  const ManageClasses({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppNavBar(title: "Manage Classes", onTap: () {}),

    );
  }
}
