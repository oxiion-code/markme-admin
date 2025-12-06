import 'package:equatable/equatable.dart';

import '../../academic_structure/models/academic_batch.dart';
import '../../academic_structure/models/branch.dart';
import '../../academic_structure/models/course.dart';
import '../models/class_info.dart';

class ClassState extends Equatable {
  const ClassState();
  @override
  List<Object?> get props => [];
}

class ClassInitial extends ClassState {}

class ClassLoading extends ClassState {}

class ClassSuccess extends ClassState {}

class ClassFailure extends ClassState {
  final String message;
  const ClassFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ClassesLoaded extends ClassState {
  final List<ClassInfo> classes;
  const ClassesLoaded(this.classes);
  @override
  List<Object?> get props => [classes];
}

class ClassesLoadedForTeacher extends ClassState {
  final List<ClassInfo> classes;
  const ClassesLoadedForTeacher(this.classes);
  @override
  List<Object?> get props => [classes];
}

// For dropdowns
class CoursesLoadedForClass extends ClassState {
  final List<Course> courses;
  const CoursesLoadedForClass(this.courses);
  @override
  List<Object?> get props => [courses];
}

class BranchesLoadedForClass extends ClassState {
  final List<Branch> branches;
  const BranchesLoadedForClass(this.branches);
  @override
  List<Object?> get props => [branches];
}

class BatchesLoadedForClass extends ClassState {
  final List<AcademicBatch> batches;
  const BatchesLoadedForClass(this.batches);
  @override
  List<Object?> get props => [batches];
}
