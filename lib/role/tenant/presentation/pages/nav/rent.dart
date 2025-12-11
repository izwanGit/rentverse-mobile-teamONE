import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/core/services/service_locator.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/features/bookings/domain/usecase/get_bookings_usecase.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_response_entity.dart';
import 'package:rentverse/features/midtrans/domain/usecase/pay_invoice_usecase.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent/midtrans_payment_page.dart';
import 'package:rentverse/role/tenant/presentation/pages/rent/detail_active_rent.dart';
import 'package:rentverse/role/tenant/presentation/cubit/rent/cubit.dart';
import 'package:rentverse/role/tenant/presentation/cubit/rent/state.dart';

enum BookingSortOrder { statusAsc, statusDesc }

class TenantRentPage extends StatefulWidget {
  const TenantRentPage({super.key});

  @override
  State<TenantRentPage> createState() => _TenantRentPageState();
}

class _TenantRentPageState extends State<TenantRentPage> {
  BookingSortOrder _sortOrder = BookingSortOrder.statusAsc;

  List<BookingListItemEntity> _sorted(List<BookingListItemEntity> items) {
    final sorted = List<BookingListItemEntity>.of(items);
    sorted.sort((a, b) {
      final statusCompare = _sortOrder == BookingSortOrder.statusAsc
          ? a.status.compareTo(b.status)
          : b.status.compareTo(a.status);

      if (statusCompare != 0) return statusCompare;
      return a.property.title.compareTo(b.property.title);
    });
    return sorted;
  }

  void _openActiveDetail(BuildContext context, BookingListItemEntity item) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ActiveRentDetailPage(booking: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: BlocProvider(
        create: (_) =>
            RentCubit(sl<GetBookingsUseCase>(), sl<PayInvoiceUseCase>())
              ..load(),
        child: Scaffold(
          backgroundColor: Color(0xFFF5F5F5),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: const Text(
              'My Booking',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<BookingSortOrder>(
                icon: const Icon(Icons.sort),
                initialValue: _sortOrder,
                onSelected: (value) => setState(() => _sortOrder = value),
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: BookingSortOrder.statusAsc,
                    child: Text('Sort status A → Z'),
                  ),
                  PopupMenuItem(
                    value: BookingSortOrder.statusDesc,
                    child: Text('Sort status Z → A'),
                  ),
                ],
              ),
            ],
            bottom: const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicatorColor: Color(0xFF1CD8D2),
              labelColor: Color(0xFF1CD8D2),
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Pending Payment'),
                Tab(text: 'Paid'),
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Overdue'),
                Tab(text: 'Canceled'),
              ],
            ),
          ),
          body: BlocBuilder<RentCubit, RentState>(
            builder: (context, state) {
              if (state.error != null) {
                return Center(child: Text(state.error!));
              }

              // Aggregate all bookings into a single map to avoid duplicates
              final allMap = <String, BookingListItemEntity>{};
              for (final list in [
                state.pendingPayment,
                state.active,
                state.completed,
                state.cancelled,
                state.paymentPending,
                state.paymentPaid,
                state.paymentOverdue,
                state.paymentCanceled,
              ]) {
                for (final b in list) {
                  allMap[b.id] = b;
                }
              }

              final all = allMap.values.toList();

              // Helper to filter by exact status matches (case-insensitive)
              List<BookingListItemEntity> byStatuses(List<String> statuses) {
                final set = statuses.map((s) => s.toUpperCase()).toSet();
                return all
                    .where((b) => set.contains(b.status.toUpperCase()))
                    .toList();
              }

              // New tab order requested: Pending, Pending Payment, Paid,
              // Active, Completed, Overdue, Canceled
              final bookingPending = byStatuses(['PENDING', 'PENDING_PAYMENT']);
              final bookingPendingPayment = byStatuses(['CONFIRMED']);
              final bookingPaid = byStatuses(['PAID']);
              final bookingActive = byStatuses(['ACTIVE']);
              final bookingCompleted = byStatuses(['COMPLETED']);
              final bookingOverdue = byStatuses(['OVERDUE']);
              final bookingCanceled = all.where((b) {
                final s = b.status.toUpperCase();
                return s.contains('CANCEL');
              }).toList();

              return TabBarView(
                children: [
                  // Pending (PENDING, PENDING_PAYMENT) — PENDING_PAYMENT should
                  // show disabled button with label "Waiting For Accept".
                  _BookingList(
                    statusLabel: 'Approved by the owner',
                    items: _sorted(bookingPending),
                    buttonLabel: 'Go to Payment',
                    isPendingTab: true,
                    onTap: (item) => _handlePayment(context, item),
                  ),

                  // Pending Payment (CONFIRMED)
                  _BookingList(
                    statusLabel: 'Waiting for payment',
                    items: _sorted(bookingPendingPayment),
                    buttonLabel: 'Go to Payment',
                    onTap: (item) => _handlePayment(context, item),
                  ),

                  // Paid
                  _BookingList(
                    statusLabel: 'Paid',
                    items: _sorted(bookingPaid),
                    buttonLabel: 'View Detail',
                    onTap: (item) => _openActiveDetail(context, item),
                  ),

                  // Active
                  _BookingList(
                    statusLabel: 'Active Booking',
                    items: _sorted(bookingActive),
                    buttonLabel: 'View Detail',
                    onTap: (item) => _openActiveDetail(context, item),
                  ),

                  // Completed
                  _BookingList(
                    statusLabel: 'Completed',
                    items: _sorted(bookingCompleted),
                    buttonLabel: 'View Detail',
                    onTap: (item) => _openActiveDetail(context, item),
                  ),

                  // Overdue
                  _BookingList(
                    statusLabel: 'Overdue',
                    items: _sorted(bookingOverdue),
                    buttonLabel: 'Go to Payment',
                    onTap: (item) => _handlePayment(context, item),
                  ),

                  // Canceled
                  _BookingList(
                    statusLabel: 'Canceled',
                    items: _sorted(bookingCanceled),
                    buttonLabel: 'View Detail',
                    onTap: (item) => _openActiveDetail(context, item),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final String statusLabel;
  final List<BookingListItemEntity> items;
  final String buttonLabel;
  final void Function(BookingListItemEntity) onTap;
  final bool isPendingTab;
  const _BookingList({
    required this.statusLabel,
    required this.items,
    required this.buttonLabel,
    required this.onTap,
    this.isPendingTab = false,
  });

  final Widget? leading = null;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = items[index];
        return _BookingListItemCard(
          statusLabel: statusLabel,
          title: item.property.title,
          city: item.property.city,
          imageUrl: item.property.image,
          buttonLabel: buttonLabel,
          leading: leading,
          onTap: () => onTap(item),
          status: item.status,
          isPendingTab: isPendingTab,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: items.length,
    );
  }
}

class _BookingListItemCard extends StatelessWidget {
  const _BookingListItemCard({
    required this.statusLabel,
    required this.title,
    required this.city,
    required this.imageUrl,
    required this.buttonLabel,
    required this.onTap,
    this.leading,
    required this.status,
    this.isPendingTab = false,
  });

  final String statusLabel;
  final String title;
  final String city;
  final String imageUrl;
  final String buttonLabel;
  final VoidCallback onTap;
  final Widget? leading;
  final String status;
  final bool isPendingTab;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  leading ??
                      const Icon(
                        Icons.check,
                        color: Color(0xFF00C853),
                        size: 18,
                      ),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 100,
                      height: 90,
                      child: Image.network(imageUrl, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                city,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1CD8D2), Color(0xFF0097F6)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed:
                                  (isPendingTab &&
                                      status.toUpperCase() == 'PENDING_PAYMENT')
                                  ? null
                                  : onTap,
                              child: Text(
                                (isPendingTab &&
                                        status.toUpperCase() ==
                                            'PENDING_PAYMENT')
                                    ? 'Waiting For Accept'
                                    : buttonLabel,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _handlePayment(
  BuildContext context,
  BookingListItemEntity item,
) async {
  final cubit = context.read<RentCubit>();
  final payment = await cubit.payInvoice(item.payment.invoiceId);
  if (payment == null) return;
  if (!context.mounted) return;

  final booking = _mapToBookingResponse(item);
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => MidtransPaymentPage(
        booking: booking,
        redirectUrl: payment.redirectUrl,
        snapToken: payment.token,
        clientKey: payment.clientKey,
      ),
    ),
  );
}

BookingResponseEntity _mapToBookingResponse(BookingListItemEntity item) {
  return BookingResponseEntity(
    bookingId: item.id,
    invoiceId: item.payment.invoiceId,
    status: item.status,
    amount: item.payment.amount,
    currency: item.payment.currency,
    checkIn: item.startDate,
    checkOut: item.endDate,
    billingPeriod: null,
    paymentDeadline: null,
    property: BookingPropertySummaryEntity(
      id: item.property.id,
      title: item.property.title,
      address: item.property.city,
      imageUrl: item.property.image,
    ),
    message: null,
  );
}
