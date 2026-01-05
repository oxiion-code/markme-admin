import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/repository/batch_repo/academic_batch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/branch_repo/branch_repository.dart';
import 'package:markme_admin/features/academic_structure/repository/course_repo/course_repository.dart';
import 'package:markme_admin/features/onboarding/models/user_model.dart';
import 'package:markme_admin/features/placement/blocs/session/session_bloc.dart';
import 'package:markme_admin/features/placement/repositories/session/placement_session_repository.dart';
import 'package:markme_admin/features/placement/screens/applications/applications_tab.dart';
import 'package:markme_admin/features/placement/screens/company/companies_screen.dart';

import '../../../../core/services/service_locator.dart';
import '../../blocs/company/company_bloc.dart';
import '../../repositories/company/company_repository.dart';
class PlacementDashboardScreen extends StatelessWidget {
  final AdminUser adminUser;
  const PlacementDashboardScreen({super.key, required this.adminUser});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('Placement Dashboard'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black87,
                  indicator: BoxDecoration(
                    color:Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Companies'),
                    Tab(text: 'Applications'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: TabBarView(
            children: [
              BlocProvider(
                create: (_) => CompanyBloc(
                  repository: sl<CompanyRepository>(), // make sure sl() has it registered
                ),
                child: const CompaniesTab(),
              ),
              BlocProvider(
                create: (_) => PlacementSessionBloc(
                  batchRepository:sl<AcademicBatchRepository>() ,
                  branchRepository:sl<BranchRepository>() ,
                  courseRepository: sl<CourseRepository>(),
                  repository: sl<PlacementSessionRepository>(), // make sure sl() has it registered
                ),
                child:ApplicationsTab(collegeId:adminUser.collegeId,),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

