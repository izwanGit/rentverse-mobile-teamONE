import 'package:flutter/material.dart';
import 'package:rentverse/features/property/domain/entity/list_property_entity.dart';

class AccessoriseWidget extends StatelessWidget {
  const AccessoriseWidget({
    super.key,
    required this.attributes,
    this.amenities = const [],
  });

  final List<PropertyAttributeEntity> attributes;
  final List<String> amenities;

  @override
  Widget build(BuildContext context) {
    final amenityItems = amenities
        .map(_mapAmenity)
        .where((data) => data != null)
        .cast<_AccessoriseData>()
        .toList();

    final attributeItems = attributes
        .where((attr) => attr.attributeType != null)
        .map(_mapAttribute)
        .where((data) => data != null)
        .cast<_AccessoriseData>()
        .toList();

    final items = [...amenityItems, ...attributeItems];

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 20,
        runSpacing: 12,
        children: items
            .map(
              (item) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(item.icon, size: 18, color: Colors.teal),
                  const SizedBox(width: 6),
                  Text(
                    item.value.isEmpty
                        ? item.label
                        : '${item.value} ${item.label}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  _AccessoriseData? _mapAmenity(String amenity) {
    if (amenity.isEmpty) return null;
    final key = amenity.toLowerCase();
    return _AccessoriseData(
      label: _formatAmenityLabel(key),
      value: '',
      icon: _iconForAmenity(key),
    );
  }

  _AccessoriseData? _mapAttribute(PropertyAttributeEntity attr) {
    final type = attr.attributeType;
    if (type == null) return null;

    final slug = type.slug.toLowerCase();
    final iconKey = type.iconUrl.toLowerCase();
    final value = attr.value.isNotEmpty ? attr.value : '-';

    return _AccessoriseData(
      label: type.label,
      value: value,
      icon: _iconFor(slug, iconKey),
    );
  }

  IconData _iconFor(String slug, String iconKey) {
    switch (slug) {
      case 'bedroom':
        return Icons.bed;
      case 'bathroom':
        return Icons.bathtub_outlined;
      case 'furnishing':
        return Icons.chair_alt;
      case 'area':
      case 'size':
      case 'sqft':
        return Icons.square_foot;
      default:
        switch (iconKey) {
          case 'bed':
            return Icons.bed;
          case 'bath':
            return Icons.bathtub_outlined;
          case 'sofa':
            return Icons.chair_alt;
          default:
            return Icons.info_outline;
        }
    }
  }

  IconData _iconForAmenity(String key) {
    switch (key) {
      case 'pool':
      case 'swimming_pool':
        return Icons.pool;
      case 'wifi':
        return Icons.wifi;
      case 'ac':
      case 'air_conditioner':
      case 'air_conditioning':
        return Icons.ac_unit;
      case 'garden':
        return Icons.park_outlined;
      default:
        return Icons.check_circle_outline;
    }
  }

  String _formatAmenityLabel(String key) {
    if (key.isEmpty) return '';
    return key[0].toUpperCase() + key.substring(1);
  }
}

class _AccessoriseData {
  const _AccessoriseData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}
