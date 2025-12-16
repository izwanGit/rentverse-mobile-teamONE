import 'package:flutter/material.dart';
import 'package:rentverse/role/lanlord/widget/my_property/property_components.dart';
class PropertyBeingProposed extends StatelessWidget {
  const PropertyBeingProposed({super.key, required this.items});

  final List<PropertyProposal> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Property Being Proposed',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            for (final item in items) ...[
              _PropertyCard(item: item),
              if (item != items.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  const _PropertyCard({required this.item});

  final PropertyProposal item;

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
      child: Row(
        children: [
          PropertyImage(
            imageUrl: item.imageUrl,
            title: item.title,
            width: 110,
            height: 80,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Color(0xFF9E9E9E),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.city,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF9E9E9E),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,

                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: item.statusBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item.status,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyProposal {
  const PropertyProposal({
    required this.title,
    required this.city,
    this.imageUrl,
    required this.status,
    this.statusBackground = const Color(0xFFBDBDBD),
  });

  final String title;
  final String city;
  final String? imageUrl;
  final String status;
  final Color statusBackground;
}
