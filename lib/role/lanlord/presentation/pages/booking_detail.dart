import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rentverse/features/bookings/domain/entity/res/booking_list_entity.dart';
import 'package:rentverse/features/disputes/presentation/pages/create_dispute_page.dart';

class LandlordBookingDetailPage extends StatelessWidget {
  const LandlordBookingDetailPage({super.key, required this.booking});

  final BookingListItemEntity booking;

  String _dateRange(DateTime? start, DateTime? end) {
    if (start == null || end == null) return '-';
    final fmt = DateFormat('dd MMM yyyy');
    return '${fmt.format(start)} - ${fmt.format(end)}';
  }

  String _amount() {
    try {
      final symbol = booking.payment.currency.toUpperCase() == 'IDR'
          ? 'Rp'
          : booking.payment.currency;
      return NumberFormat.currency(
        locale: 'id_ID',
        symbol: symbol.isNotEmpty ? '$symbol ' : 'Rp ',
        decimalDigits: 0,
      ).format(booking.payment.amount);
    } catch (_) {
      return '${booking.payment.currency} ${booking.payment.amount}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  _InfoCard(
                    booking: booking,
                    dateRangeText: _dateRange(
                      booking.startDate,
                      booking.endDate,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _PaymentCard(
                    amountText: _amount(),
                    status: booking.payment.status,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.report),
                label: const Text('Raise Dispute'),
                onPressed: () async {
                  final submitted = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) =>
                          CreateDisputePage.withProvider(bookingId: booking.id),
                    ),
                  );
                  if (submitted == true && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dispute submitted')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.booking, required this.dateRangeText});

  final BookingListItemEntity booking;
  final String dateRangeText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.property.title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Text(
            booking.property.city,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.event, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(dateRangeText)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 8),
              _StatusChip(label: booking.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.amountText, required this.status});

  final String amountText;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.receipt_long, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(amountText)),
              _StatusChip(label: status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  Color get _color {
    switch (label.toUpperCase()) {
      case 'CONFIRMED':
        return const Color(0xFF1CD8D2);
      case 'PAID':
        return Colors.green;
      case 'PENDING':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
