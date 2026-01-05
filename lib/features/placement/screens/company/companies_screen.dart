import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:markme_admin/features/onboarding/cubit/admin_user_cubit.dart';
import 'package:markme_admin/features/placement/models/company/company.dart';
import 'package:markme_admin/features/placement/models/company/company_details.dart';

import '../../blocs/company/company_bloc.dart';
import '../../blocs/company/company_event.dart';
import '../../blocs/company/company_state.dart';

class CompaniesTab extends StatefulWidget {
  const CompaniesTab({super.key});

  @override
  State<CompaniesTab> createState() => _CompaniesTabState();
}
class _CompaniesTabState extends State<CompaniesTab> {
  @override
  void initState() {
    super.initState();
    final collegeId = context.read<AdminUserCubit>().state!.collegeId;
    context.read<CompanyBloc>().add(LoadCompanies(collegeId));
  }

  @override
  Widget build(BuildContext context) {
    final collegeId = context.read<AdminUserCubit>().state!.collegeId;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/addOrModifyCompany', extra: collegeId).then(
                (_) {
              // Trigger refresh event when coming back
              context.read<CompanyBloc>().add(LoadCompanies(collegeId));
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Company'),
      ),
      body: BlocBuilder<CompanyBloc, CompanyState>(
        builder: (context, state) {
          if (state is CompanyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CompanyOperationFailure) {
            return Center(child: Text(state.message));
          } else if (state is CompaniesLoaded) {
            final companies = state.companies;

            if (companies.isEmpty) {
              return const Center(child: Text("No companies found."));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<CompanyBloc>().add(LoadCompanies(collegeId));
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 80, top: 8),
                itemCount: companies.length,
                itemBuilder: (context, index) {
                  final Company company = companies[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 4),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: company.logoUrl.isNotEmpty
                              ? NetworkImage(company.logoUrl)
                              : null,
                          child: company.logoUrl.isEmpty
                              ? Text(company.name[0])
                              : null,
                        ),
                        title: Text(company.name),
                        subtitle: Text(
                            company.description.isNotEmpty
                                ? company.description
                                : 'Tap to view details'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          final companyDetails=CompanyDetails(company: company, collegeId: collegeId);
                          context.push('/companyDetails', extra: companyDetails).then((result){
                            if(result=="deleted" || result=="updated"){
                              context.read<CompanyBloc>().add(LoadCompanies(collegeId));
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
