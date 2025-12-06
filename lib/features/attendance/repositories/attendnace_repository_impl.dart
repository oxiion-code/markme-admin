import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/data/models/student.dart';
import 'package:markme_admin/features/attendance/model/student_with_status.dart';
import 'package:markme_admin/features/attendance/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl extends AttendanceRepository{
  FirebaseFirestore firestore;
  AttendanceRepositoryImpl({required this.firestore});

  @override
  Future<Either<AppFailure, List<StudentWithStatus>>> getAttendanceStudentsById(String attendanceId) async{
   try{
     final recordsSnapshot= await firestore.collection("attendance").doc(attendanceId).collection("records").get();
     if(recordsSnapshot.docs.isEmpty){
       return const Right([]);
     }
     final Map<String,bool> studentStatus={};
     for(var doc in recordsSnapshot.docs){
       final id=doc["studentId"] as String;
       final status= doc["status"] as String;
       studentStatus[id]=status.toLowerCase() =="present";
     }

     final studentIds= studentStatus.keys.toList();
     final List<StudentWithStatus> studentsWithStatus = [];

     const batchSize=10;
     for(var i=0; i<studentIds.length; i+=batchSize){
       final batchIds=studentIds.sublist(i,i+batchSize>studentIds.length? studentIds.length:i+batchSize);

       final studentSnapshot= await firestore.collection("students").where("id", whereIn: batchIds).get();

       for(var doc in studentSnapshot.docs){
         final student= Student.fromMap(doc.data());
         final isPresent= studentStatus[student.id]?? false;
         studentsWithStatus.add(StudentWithStatus(student: student, isPresent: isPresent ));
       }
     }
     return Right(studentsWithStatus);

   }catch(e){
     return Left(AppFailure(message: e.toString()));
   }
  }

}