import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/core/utils/app_utils.dart';

import '../../../../data/models/student.dart';
import '../../bloc/student_verification_bloc.dart';
import '../../bloc/student_verification_event.dart';
import '../../bloc/student_verification_state.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/error_view.dart';
import '../../widgets/qualification_card.dart';
import '../../widgets/student_profile_card.dart';

class StudentVerificationConfirmationScreen extends StatefulWidget {
  final String collegeId;
  final Student student;

  const StudentVerificationConfirmationScreen({
    super.key,
    required this.collegeId,
    required this.student,
  });

  @override
  State<StudentVerificationConfirmationScreen> createState() =>
      _StudentVerificationConfirmationScreenState();
}

class _StudentVerificationConfirmationScreenState
    extends State<StudentVerificationConfirmationScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StudentOnboardingBloc>().add(
      LoadQualificationsForStudentVerification(
        collegeId: widget.collegeId,
        studentId: widget.student.id,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Student'),
        centerTitle: true,
      ),
      body: BlocConsumer<StudentOnboardingBloc, StudentOnboardingState>(
        listener: (context, state) {
          if (state is StudentVerificationFailure) {
         AppUtils.showCustomSnackBar(context, state.message,isError: true);
          }

          if (state is MarkedStudentAsVerified) {
           AppUtils.showCustomSnackBar(context, 'Student verification updated successfully');
            context.pop("verified");
          }
          if(state is MarkedStudentProfileVerificationFailed){
            AppUtils.showCustomSnackBar(context, 'Student verification updated successfully');
            context.pop("failed");
          }
        },
        builder: (context, state) {
          if (state is StudentVerificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentVerificationFailure) {
            return ErrorView(
              message: state.message,
              onRetry: () {
                context.read<StudentOnboardingBloc>().add(
                  LoadQualificationsForStudentVerification(
                    collegeId: widget.collegeId,
                    studentId: widget.student.id,
                  ),
                );
              },
            );
          }

          if (state is LoadedQualificationsForStudentVerification) {
            return Column(
              children: [
                /// Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Student Profile
                        StudentProfileCard(student: widget.student),

                        const SizedBox(height: 20),

                        /// Qualifications List
                        Text(
                          'Qualifications (${state.qualifications.length})',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),

                        ...List.generate(
                          state.qualifications.length,
                              (index) => Column(
                            children: [
                              QualificationCard(
                                qualification: state.qualifications[index],
                              ),
                              if (index < state.qualifications.length - 1)
                                const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// Fixed Bottom Action Bar
                BottomActionBar(
                  collegeId: widget.collegeId,
                  student: widget.student,
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
