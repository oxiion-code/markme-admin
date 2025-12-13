import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils{
  static void showCustomSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }

  static void showCustomLoading(BuildContext context){
    showDialog(context: context, builder: (_)=>Dialog(
      backgroundColor: Colors.transparent,
      child: Loading(),
    ));
  }
  static Future<void> saveCollegeId(String collegeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('college_id', collegeId);
  }
  static Future<String?> getCollegeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('college_id');
  }
  static Future<void> deleteCollegeId(String collegeIdKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(collegeIdKey);
  }
  static void showDialogMessage(BuildContext context,String message,String title){
    showDialog(context: context, builder: (context)=>AlertDialog(
      title:Text(title) ,
      content: Text(message),
      actions: [
        IconButton(onPressed: ()=>context.pop(), icon: Icon(Icons.close_outlined))
      ],
    ));
  }

   static void showDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onConfirmDelete,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this teacher?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirmDelete(); // 👉 perform actual deletion
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}