import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/models/academic_batch.dart';
import 'package:markme_admin/features/academic_structure/models/branch.dart';

import '../../academic_structure/models/course.dart';
import '../blocs/session/session_bloc.dart';
import '../blocs/session/session_state.dart';
import '../blocs/session/sesssion_event.dart';
import '../models/company/company_details.dart';
import '../models/session/eligibility.dart';
import '../models/session/placement_session.dart';
import '../widgets/add_placement_session/company_info_section.dart';
import '../widgets/add_placement_session/session_details_section.dart';
import '../widgets/add_placement_session/eligibility_section.dart';
import '../widgets/add_placement_session/schedule_section.dart';

class AddPlacementSessionScreen extends StatefulWidget {
  final CompanyDetails companyDetails;

  const AddPlacementSessionScreen({
    super.key,
    required this.companyDetails,
  });

  @override
  State<AddPlacementSessionScreen> createState() =>
      _AddPlacementSessionScreenState();
}

class _AddPlacementSessionScreenState
    extends State<AddPlacementSessionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final sessionNameCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final skillsCtrl = TextEditingController();
  final cgpaCtrl = TextEditingController();
  final backlogCtrl = TextEditingController();

  String driveType = 'Placement';
  String status = 'upcoming';
  String? jobRole;
  DateTime? startDate;
  DateTime? endDate;

  List<Course> loadedCourses=[];
  List<Branch> loadedBranches=[];
  List<AcademicBatch> loadedBatches=[];

  List<String> selectedBranches = [];
  List<String> selectedBatches = [];

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (startDate == null || endDate == null) return;

    final eligibility = Eligibility(
      branches: selectedBranches,
      batches: selectedBatches,
      minCgpa: double.parse(cgpaCtrl.text),
      maxBacklogs: int.parse(backlogCtrl.text),
    );

    final now = DateTime.now();

    final session = PlacementSession(
      sessionId: now.microsecondsSinceEpoch.toString(),
      sessionName: sessionNameCtrl.text.trim(),
      companyId: widget.companyDetails.company.companyId,
      companyName: widget.companyDetails.company.name,
      role: jobRole!,
      driveType: driveType,
      description: descriptionCtrl.text.trim(),
      location: locationCtrl.text.trim(),
      eligibility: eligibility,
      requiredSkills:
      skillsCtrl.text.split(',').map((e) => e.trim()).toList(),
      startDate: startDate!,
      endDate: endDate!,
      createdAt: now,
      status: status,
      formId: '',
      collegeId: widget.companyDetails.collegeId,
    );

    context.read<PlacementSessionBloc>().add(
      AddPlacementSession(session),
    );
  }

  @override
  Widget build(BuildContext context) {
    final company = widget.companyDetails.company;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Placement Session')),
      body: BlocListener<PlacementSessionBloc, PlacementSessionState>(
        listener: (context, state) {
          if (state is PlacementSessionAdded) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CompanyInfoSection(company: company),
                const SizedBox(height: 12),
                SessionDetailsSection(
                  company: company,
                  sessionNameCtrl: sessionNameCtrl,
                  descriptionCtrl: descriptionCtrl,
                  locationCtrl: locationCtrl,
                  skillsCtrl: skillsCtrl,
                  driveType: driveType,
                  status: status,
                  jobRole: jobRole,
                  onDriveTypeChanged: (v) => setState(() => driveType = v),
                  onStatusChanged: (v) => setState(() => status = v),
                  onJobRoleChanged: (v) => setState(() => jobRole = v),
                ),

                const SizedBox(height: 12),

                EligibilitySection(
                  cgpaCtrl: cgpaCtrl,
                  backlogCtrl: backlogCtrl,
                ),

                const SizedBox(height: 12),

                ScheduleSection(
                  startDate: startDate,
                  endDate: endDate,
                  onStartDate: (d) => setState(() => startDate = d),
                  onEndDate: (d) => setState(() => endDate = d),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _submit,
                    child: const Text('Create Session'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
