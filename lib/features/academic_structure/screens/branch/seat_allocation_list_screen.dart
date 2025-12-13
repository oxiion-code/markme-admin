import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:markme_admin/features/academic_structure/models/branch_seat_allocation.dart';
import '../../../onboarding/cubit/admin_user_cubit.dart';
import '../../bloc/branch_bloc/branch_bloc.dart';
import '../../bloc/branch_bloc/branch_event.dart';
import '../../bloc/branch_bloc/branch_state.dart';
import '../../models/branch.dart';
import '../../widgets/branch_widgets/add_seat_allocation_screen.dart';
import '../../widgets/branch_widgets/seat_allocation_card.dart';

class SeatAllocationListScreen extends StatefulWidget {
  final Branch branch;
  const SeatAllocationListScreen({super.key, required this.branch});

  @override
  State<SeatAllocationListScreen> createState() =>
      _SeatAllocationListScreenState();
}

class _SeatAllocationListScreenState extends State<SeatAllocationListScreen> {
  @override
  void initState() {
    super.initState();
    _loadSeatAllocations();
  }

  void _loadSeatAllocations() {
    final collegeId = context.read<AdminUserCubit>().state!.collegeId;

    context.read<BranchBloc>().add(
      LoadBranchSeatAllocationsEvent(
        collegeId: collegeId,
        branchId: widget.branch.branchId,
      ),
    );
  }

  void _openAddOrEditSheet({BranchSeatAllocation? seat}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<BranchBloc>(),
        child: AddSeatAllocationBottomSheet(
          branch: widget.branch, existingSeat: seat,// Pass null for add, object for edit
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seat Allocations"), centerTitle: true),

      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Add Seats"),
        icon: const Icon(Icons.add),
        onPressed: () => _openAddOrEditSheet(),
      ),

      body: BlocConsumer<BranchBloc, BranchState>(
        listener: (context, state) {
          if (state is BranchSeatAllocationAdded ||
              state is BranchSeatAllocationUpdated ||
              state is BranchSeatAllocationDeleted) {
            _loadSeatAllocations();
          }
        },
        builder: (context, state) {
          if (state is BranchSeatAllocationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BranchSeatAllocationError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is BranchSeatAllocationsLoaded) {
            final seatList = state.seatAllocations;

            if (seatList.isEmpty) {
              return const Center(child: Text("No seat allocations found"));
            }

            return ListView.builder(
              itemCount: seatList.length,
              itemBuilder: (context, index) {
                final seat = seatList[index];

                return SeatAllocationCard(
                  seat: seat,
                  onEdit: () => _openAddOrEditSheet(seat: seat),
                  onDelete: () {
                    final collegeId =
                        context.read<AdminUserCubit>().state!.collegeId;

                    context.read<BranchBloc>().add(
                      DeleteBranchSeatAllocationEvent(
                        collegeId: collegeId,
                        seatAllocation: seat
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
