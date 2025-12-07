import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markme_admin/core/utils/app_utils.dart';
import 'package:markme_admin/core/widgets/custom_button.dart';
import 'package:markme_admin/features/auth/models/auth_info.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_bloc.dart';
import 'package:markme_admin/features/onboarding/bloc/onboard_event.dart';
import 'package:markme_admin/features/onboarding/models/college_detail.dart';

import '../bloc/onboard_state.dart';

class SelectCollegeScreen extends StatefulWidget {
  final AuthInfo authInfo;

  const SelectCollegeScreen({super.key, required this.authInfo});

  @override
  State<SelectCollegeScreen> createState() => _SelectCollegeScreenState();
}

class _SelectCollegeScreenState extends State<SelectCollegeScreen> {
  CollegeDetail? selectedCollege;
  List<CollegeDetail> colleges = [];
  File? selectedBanner;

  @override
  void initState() {
    context.read<OnboardBloc>().add(LoadAllClassesEvent());
    super.initState();
  }

  Future<void> pickBanner() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedBanner = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardBloc, OnboardState>(
      listener: (context, state) {
        if (state is OnboardLoading) {
          AppUtils.showCustomLoading(context);
        } else {
          context.pop();
        }

        if (state is LoadedAllColleges) {
          setState(() {
            colleges = state.collegeList;
          });
        } else if (state is OnboardError) {
          AppUtils.showCustomSnackBar(context, state.errorMessage);
        } else if (state is BannerImageUploaded) {
          final authInfo= widget.authInfo.copyWith(
            collegeId: selectedCollege!.id,
            collegeName: selectedCollege!.collegeName,
            bannerLink: state.bannerLink
          );
          context.push('/onboarding',extra: authInfo);
        }
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            onTap: () {
              if (selectedBanner != null && selectedCollege != null) {
                context.read<OnboardBloc>().add(
                  UploadBannerImageEvent(
                    bannerImage: selectedBanner,
                    collegeUid: selectedCollege!.id,
                  ),
                );
              }else if(selectedBanner==null){
                AppUtils.showCustomSnackBar(context, "Upload the college banner");
              }else if(selectedCollege==null){
                AppUtils.showCustomSnackBar(context, "Please select the college");
              }
            },
            text: "Continue",
            icon: Icons.arrow_circle_right_rounded,
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top Banner Image
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Colors.transparent],
                      stops: [0.0, 0.8, 1.0],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.asset(
                    "assets/images/select_college_image.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Heading
                      Text(
                        'Select your college',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.blueGrey[900],
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 8),

                      /// Subtitle
                      Text(
                        'Choose your institution to personalise your MarkMe experience.',
                        style: TextStyle(
                          color: Colors.blueGrey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// College Dropdown
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<CollegeDetail>(
                              value: selectedCollege,
                              hint: const Text('Select college'),
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              isExpanded: true,
                              items: colleges
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c.collegeName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCollege = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Banner Upload Label
                      Text(
                        "Upload a banner image of your college (1080 × 300 px)",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// Upload Banner Card
                      GestureDetector(
                        onTap: pickBanner,
                        child: Container(
                          height: 130,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: selectedBanner == null
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.upload_rounded, size: 32),
                                      SizedBox(height: 8),
                                      Text("Upload College Banner"),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    selectedBanner!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
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
