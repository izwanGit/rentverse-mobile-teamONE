import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/disputes_cubit.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/disputes/domain/usecase/create_dispute_usecase.dart';
import 'package:rentverse/features/disputes/domain/usecase/get_my_disputes_usecase.dart';

class CreateDisputePage extends StatefulWidget {
  final String bookingId;
  const CreateDisputePage({super.key, required this.bookingId});

  static Widget withProvider({required String bookingId}) {
    return BlocProvider(
      create: (_) =>
          DisputesCubit(sl<GetMyDisputesUseCase>(), sl<CreateDisputeUseCase>()),
      child: CreateDisputePage(bookingId: bookingId),
    );
  }

  @override
  State<CreateDisputePage> createState() => _CreateDisputePageState();
}

class _CreateDisputePageState extends State<CreateDisputePage> {
  final _formKey = GlobalKey<FormState>();
  final _reasonCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Dispute')),
      body: BlocConsumer<DisputesCubit, DisputesState>(
        listener: (context, state) {
          if (state.status == DisputesStatus.failure && state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.status == DisputesStatus.success) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == DisputesStatus.loading;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _reasonCtrl,
                    validator: (v) => (v == null || v.trim().length < 5)
                        ? 'Min 5 chars'
                        : null,
                    decoration: const InputDecoration(labelText: 'Reason'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description (optional)',
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;
                              final reason = _reasonCtrl.text.trim();
                              final desc = _descCtrl.text.trim().isEmpty
                                  ? null
                                  : _descCtrl.text.trim();

                              await context.read<DisputesCubit>().create(
                                widget.bookingId,
                                reason,
                                desc,
                              );
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit Dispute'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
