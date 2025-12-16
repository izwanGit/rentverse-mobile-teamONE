import 'package:flutter/material.dart';
import 'package:rentverse/role/lanlord/widget/my_property/property_components.dart';
class RentedProperty extends StatelessWidget {
  const RentedProperty({super.key, required this.items});

  final List<RentedItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rented',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            for (final item in items) ...[
              _RentedCard(item: item),
              if (item != items.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _RentedCard extends StatelessWidget {
  const _RentedCard({required this.item});

  final RentedItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child:
                      (item.renterAvatarUrl == null ||
                          item.renterAvatarUrl!.isEmpty)
                      ? Icon(
                          Icons.person,
                          color: Colors.grey.shade500,
                          size: 20,
                        )
                      : Image.network(
                          item.renterAvatarUrl!,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person,
                            color: Colors.grey.shade500,
                            size: 20,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rented by',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    item.renterName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PropertyImage(
                imageUrl: item.imageUrl,
                title: item.title,
                width: 120,
                height: 90,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.location_on,
                      iconColor: const Color(0xFF9E9E9E),
                      text: item.city,
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.calendar_month,
                      iconColor: const Color(0xFF00BFA6),
                      text: '${item.startDate} - ${item.endDate}',
                      bold: true,
                    ),
                    const SizedBox(height: 6),
                    _InfoRow(
                      icon: Icons.access_time,
                      iconColor: const Color(0xFF00BFA6),
                      text: item.duration,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
    this.bold = false,
  });

  final IconData icon;
  final Color iconColor;
  final String text;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class RentedItem {
  const RentedItem({
    required this.renterName,
    this.renterAvatarUrl,
    required this.title,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.duration,
    this.imageUrl,
    this.statusColor = const Color(0xFF00C9B3),
  });

  final String renterName;
  final String? renterAvatarUrl;
  final String title;
  final String city;
  final String startDate;
  final String endDate;
  final String duration;
  final String? imageUrl;
  final Color statusColor;
}
