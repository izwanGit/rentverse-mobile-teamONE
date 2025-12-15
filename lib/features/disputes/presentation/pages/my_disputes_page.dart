import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/dispute_entity.dart';
import '../cubit/disputes_cubit.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/disputes/domain/usecase/get_my_disputes_usecase.dart';
import 'package:rentverse/features/disputes/domain/usecase/create_dispute_usecase.dart';
import 'package:intl/intl.dart';

class MyDisputesPage extends StatelessWidget {
  const MyDisputesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DisputesCubit(sl<GetMyDisputesUseCase>(), sl<CreateDisputeUseCase>())
            ..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Disputes')),
        body: BlocBuilder<DisputesCubit, DisputesState>(
          builder: (context, state) {
            if (state.status == DisputesStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == DisputesStatus.failure) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.error ?? 'Failed to load disputes'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<DisputesCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state.disputes.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => context.read<DisputesCubit>().load(),
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: const [
                    SizedBox(height: 120),
                    Center(child: Text('No disputes found')),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<DisputesCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: state.disputes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, idx) {
                  final d = state.disputes[idx];
                  return _DisputeTile(dispute: d);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DisputeTile extends StatelessWidget {
  final DisputeEntity dispute;

  const _DisputeTile({required this.dispute});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy, HH:mm');
    final booking = dispute.booking;
    final property = booking?.property;
    final statusColor = _statusColor(dispute.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    dispute.reason,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _StatusChip(label: dispute.status, color: statusColor),
              ],
            ),
            const SizedBox(height: 6),
            if (property != null)
              Text(
                '${property.title} • ${property.city}',
                style: const TextStyle(color: Colors.black87),
              ),
            const SizedBox(height: 4),
            Text(
              'Booking: ${booking?.id ?? dispute.bookingId}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text(
              dispute.description?.isNotEmpty == true
                  ? dispute.description!
                  : 'No description provided',
              style: const TextStyle(color: Colors.black87),
            ),
            if (dispute.resolution != null) ...[
              const SizedBox(height: 6),
              Text(
                'Resolution: ${dispute.resolution}',
                style: const TextStyle(fontSize: 12, color: Colors.teal),
              ),
            ],
            if (dispute.adminNotes != null) ...[
              const SizedBox(height: 4),
              Text(
                'Admin Notes: ${dispute.adminNotes}',
                style: const TextStyle(fontSize: 12, color: Colors.deepPurple),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              'Created: ${fmt.format(dispute.createdAt.toLocal())}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

Color _statusColor(String status) {
  switch (status.toUpperCase()) {
    case 'OPEN':
      return const Color(0xFF1CD8D2);
    case 'RESOLVED':
      return Colors.green.shade600;
    case 'REJECTED':
      return Colors.red.shade600;
    default:
      return Colors.grey.shade600;
  }
}
