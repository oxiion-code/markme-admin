import 'package:dartz/dartz.dart';
import 'package:markme_admin/core/error/failure.dart';
import 'package:markme_admin/features/attendance/model/student_with_status.dart';

abstract class AttendanceRepository{
  Future<Either<AppFailure,List<StudentWithStatus>>> getAttendanceStudentsById(String attendanceId);
}