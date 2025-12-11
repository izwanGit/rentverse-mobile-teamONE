import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entity/dispute_entity.dart';
import '../cubit/disputes_cubit.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/disputes/domain/usecase/get_my_disputes_usecase.dart';
import 'package:rentverse/features/disputes/domain/usecase/create_dispute_usecase.dart';

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
                child: Text(state.error ?? 'Failed to load disputes'),
              );
            }
            if (state.disputes.isEmpty) {
              return const Center(child: Text('No disputes found'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: state.disputes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final d = state.disputes[idx];
                return _DisputeTile(dispute: d);
              },
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dispute.reason,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            if (dispute.booking != null)
              Text(
                '${dispute.booking!.property.title} • ${dispute.booking!.property.city}',
              ),
            const SizedBox(height: 6),
            Text('Status: ${dispute.status}'),
            const SizedBox(height: 6),
            Text(
              'Created: ${dispute.createdAt.toLocal().toString().split(".").first}',
            ),
          ],
        ),
      ),
    );
  }
}
