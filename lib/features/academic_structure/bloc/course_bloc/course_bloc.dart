import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_event.dart';
import 'package:markme_admin/features/academic_structure/bloc/course_bloc/course_state.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';

class CourseBloc extends Bloc<CourseEvent,CourseState>{
  final CourseRepository repository;
  CourseBloc(this.repository):super(CourseInitial()){
    on<LoadCourses>(_onLoadCourses);
    on<AddCourseEvent>(_onAddCourse);
    on<UpdateCourseEvent>(_onUpdateCourse);
    on<DeleteCourseEvent>(_onDeleteCourse);
  }

  FutureOr<void> _onLoadCourses(LoadCourses event, Emitter<CourseState> emit) async {
    emit (CourseLoading());
    final result=await repository.getCourses();
    result.fold((failure)=>emit(CourseError(failure.message)), (courses)=>emit(CourseLoaded(courses: courses)));
  }

  FutureOr<void> _onAddCourse(AddCourseEvent event, Emitter<CourseState> emit) async{
    emit(CourseLoading());
    final result= await repository.addCourse(event.course);
    result.fold((failure)=>emit( CourseError(failure.message)), (_)=>add(LoadCourses()));
  }


  FutureOr<void> _onUpdateCourse(UpdateCourseEvent event, Emitter<CourseState> emit) async {
    final result = await repository.updateCourse(event.course);
    result.fold(
          (failure) => emit(CourseError(failure.message)),
          (_) => add(LoadCourses()), // reload after update
    );
  }

  FutureOr<void> _onDeleteCourse(DeleteCourseEvent event, Emitter<CourseState> emit) async{
    final result = await repository.deleteCourse(event.course);
    result.fold(
          (failure) => emit(CourseError(failure.message)),
          (_) => add(LoadCourses()), // reload after delete
    );
  }
}