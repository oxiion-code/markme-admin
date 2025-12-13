import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/subjects/models/subject.dart';
import 'package:markme_admin/features/subjects/repository/subject_repository.dart';

class SubjectRepositoryImpl extends SubjectRepository{
  final FirebaseFirestore _firestore;
  SubjectRepositoryImpl(this._firestore);
  @override
  Future<Either<AppFailure, Unit>> addSubject(Subject subject,String collegeId) async {
    try{
      await _firestore
          .collection('subjects')
          .doc(collegeId)
          .collection("subjects")
          .doc(subject.subjectId)
          .set(subject.toMap());
      return Right(unit);
    }catch(e){
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> deleteSubject(Subject subject,String collegeId) async{
    try{
      await _firestore
          .collection('subjects')
          .doc(collegeId)
          .collection("subjects")
          .doc(subject.subjectId).delete();
      return Right(unit);
    }catch(e){
      return Left(AppFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Subject>>> getSubjects(String collegeId,String branchId) async{
     try{
       final snapshot= await _firestore .collection('subjects')
           .doc(collegeId)
           .collection("subjects").where("branchId", isEqualTo: branchId)
          .get();
       final subjects=snapshot.docs.map((subject)=>Subject.fromMap(subject.data())).toList();
       return Right(subjects);
     }catch(e){
       return Left(AppFailure(message: e.toString()));
     }
  }

  @override
  Future<Either<AppFailure, Unit>> updateSubject(Subject subject,String collegeId) async{
   try{
     await _firestore
         .collection('subjects')
         .doc(collegeId)
         .collection("subjects")
         .doc(subject.subjectId).update(subject.toMap());
     return Right(unit);
   }catch(e){
     return Left(AppFailure(message: e.toString()));
   }
  }

}