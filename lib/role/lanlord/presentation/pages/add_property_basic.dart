import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/add_property_cubit.dart';
import 'package:rentverse/role/lanlord/presentation/cubit/add_property_state.dart';
import 'package:rentverse/role/lanlord/widget/add_property/map_handling.dart';
import 'package:rentverse/features/map/presentation/screen/open_map_screen.dart';

class AddPropertyBasicPage extends StatefulWidget {
  const AddPropertyBasicPage({super.key});

  @override
  State<AddPropertyBasicPage> createState() => _AddPropertyBasicPageState();
}

class _AddPropertyBasicPageState extends State<AddPropertyBasicPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _projectController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _sizeController;

  int _propertyTypeId = 1;
  int _listingTypeId = 1;
  int _bedrooms = 0;
  int _bathrooms = 0;
  List<String> _images = const [];

  static const _propertyTypes = [
    {'id': 1, 'label': 'Apartment'},
    {'id': 2, 'label': 'House'},
    {'id': 3, 'label': 'Villa'},
  ];

  static const _listingTypes = [
    {'id': 1, 'label': 'Rent'},
    {'id': 2, 'label': 'Sell'},
  ];

  @override
  void initState() {
    super.initState();
    final state = context.read<AddPropertyCubit>().state;
    _titleController = TextEditingController(text: state.title);
    _descriptionController = TextEditingController(text: state.description);
    _projectController = TextEditingController(text: state.projectName);
    _addressController = TextEditingController(text: state.address);
    _cityController = TextEditingController(text: state.city);
    _countryController = TextEditingController(text: state.country);
    _sizeController = TextEditingController(text: state.size);
    _propertyTypeId = state.propertyTypeId;
    _listingTypeId = state.listingTypeId;
    _bedrooms = state.bedrooms;
    _bathrooms = state.bathrooms;
    _images = state.imagePaths;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _projectController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Basic Property Information'),
        centerTitle: true,
      ),
      body: BlocBuilder<AddPropertyCubit, AddPropertyState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabeledField(
                  label: 'Enter an appealing title for this property listing',
                  controller: _titleController,
                  hint: 'Stunning Studio Apartment...',
                  onChanged: (_) => _onChange(),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Provide a detailed description of this property unit',
                  controller: _descriptionController,
                  hint: 'Describe the property',
                  maxLines: 3,
                  onChanged: (_) => _onChange(),
                ),
                const SizedBox(height: 12),
                _DropdownField(
                  label: 'What type of property are you listing?',
                  value: _propertyTypeId,
                  items: _propertyTypes,
                  onChanged: (val) {
                    setState(() => _propertyTypeId = val);
                    _onChange();
                  },
                ),
                const SizedBox(height: 12),
                _DropdownField(
                  label: 'Listing type',
                  value: _listingTypeId,
                  items: _listingTypes,
                  onChanged: (val) {
                    setState(() => _listingTypeId = val);
                    _onChange();
                  },
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Project / building name',
                  controller: _projectController,
                  hint: 'Bandaraya Georgetown...',
                  onChanged: (_) => _onChange(),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'Your property address',
                  controller: _addressController,
                  hint: 'Address',
                  onChanged: (_) => _onChange(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _LabeledField(
                        label: 'City',
                        controller: _cityController,
                        hint: 'City',
                        onChanged: (_) => _onChange(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LabeledField(
                        label: 'Country',
                        controller: _countryController,
                        hint: 'Country',
                        onChanged: (_) => _onChange(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Map picker / preview (opens OpenStreetMap for selection)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: state.latitude != null && state.longitude != null
                      ? MapPreview(
                          lat: state.latitude!,
                          lon: state.longitude!,
                          displayName: state.address.isNotEmpty
                              ? state.address
                              : null,
                          onTap: () async {
                            final result = await Navigator.of(context)
                                .push<Map<String, dynamic>>(
                                  MaterialPageRoute(
                                    builder: (_) => OpenMapScreen(
                                      initialLat: state.latitude ?? -6.200000,
                                      initialLon: state.longitude ?? 106.816666,
                                    ),
                                  ),
                                );
                            if (result == null) return;
                            final lat = (result['lat'] as num).toDouble();
                            final lon = (result['lon'] as num).toDouble();
                            final displayName =
                                result['displayName'] as String?;
                            final city = result['city'] as String?;
                            final country = result['country'] as String?;
                            context.read<AddPropertyCubit>().updateBasic(
                              address: displayName ?? state.address,
                              city: city ?? state.city,
                              country: country ?? state.country,
                              latitude: lat,
                              longitude: lon,
                            );
                            setState(() {
                              _addressController.text =
                                  displayName ?? _addressController.text;
                              _cityController.text =
                                  city ?? _cityController.text;
                              _countryController.text =
                                  country ?? _countryController.text;
                            });
                          },
                        )
                      : MapPicker(
                          initialLat: state.latitude ?? -6.200000,
                          initialLon: state.longitude ?? 106.816666,
                          onLocationSelected:
                              (lat, lon, city, country, displayName) {
                                // update cubit with selected coordinates and address
                                context.read<AddPropertyCubit>().updateBasic(
                                  address: displayName ?? state.address,
                                  city: city ?? state.city,
                                  country: country ?? state.country,
                                  latitude: lat,
                                  longitude: lon,
                                );
                                setState(() {
                                  _addressController.text =
                                      displayName ?? _addressController.text;
                                  _cityController.text =
                                      city ?? _cityController.text;
                                  _countryController.text =
                                      country ?? _countryController.text;
                                });
                              },
                        ),
                ),
                const SizedBox(height: 12),
                _LabeledField(
                  label: 'What is the size of this property? (sqft)',
                  controller: _sizeController,
                  hint: '500',
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _onChange(),
                ),
                const SizedBox(height: 12),
                _NumberStepper(
                  label: 'How many bedrooms?',
                  value: _bedrooms,
                  onChanged: (v) {
                    setState(() => _bedrooms = v);
                    _onChange();
                  },
                ),
                const SizedBox(height: 12),
                _NumberStepper(
                  label: 'How many bathrooms?',
                  value: _bathrooms,
                  onChanged: (v) {
                    setState(() => _bathrooms = v);
                    _onChange();
                  },
                ),
                const SizedBox(height: 16),
                _ImagePickerRow(images: _images, onPick: _pickImages),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _reset,
                        child: const Text('Reset'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1CD8D2),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result == null) return;
    final paths = result.paths.whereType<String>().take(5).toList();
    setState(() => _images = paths);
    context.read<AddPropertyCubit>().setImages(paths);
  }

  void _reset() {
    context.read<AddPropertyCubit>().resetBasic();
    final state = context.read<AddPropertyCubit>().state;
    setState(() {
      _titleController.text = state.title;
      _descriptionController.text = state.description;
      _projectController.text = state.projectName;
      _addressController.text = state.address;
      _cityController.text = state.city;
      _countryController.text = state.country;
      _sizeController.text = state.size;
      _propertyTypeId = state.propertyTypeId;
      _listingTypeId = state.listingTypeId;
      _bedrooms = state.bedrooms;
      _bathrooms = state.bathrooms;
      _images = state.imagePaths;
    });
  }

  void _save() {
    context.read<AddPropertyCubit>().updateBasic(
      title: _titleController.text,
      description: _descriptionController.text,
      propertyTypeId: _propertyTypeId,
      listingTypeId: _listingTypeId,
      projectName: _projectController.text,
      address: _addressController.text,
      city: _cityController.text,
      country: _countryController.text,
      size: _sizeController.text,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
    );
    context.read<AddPropertyCubit>().setImages(_images);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Basic info saved')));
    Navigator.of(context).maybePop();
  }

  void _onChange() {
    context.read<AddPropertyCubit>().updateBasic(
      title: _titleController.text,
      description: _descriptionController.text,
      propertyTypeId: _propertyTypeId,
      listingTypeId: _listingTypeId,
      projectName: _projectController.text,
      address: _addressController.text,
      city: _cityController.text,
      country: _countryController.text,
      size: _sizeController.text,
      bedrooms: _bedrooms,
      bathrooms: _bathrooms,
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final int value;
  final List<Map<String, Object>> items;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: value,
          items: items
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e['id'] as int,
                  child: Text(e['label'] as String),
                ),
              )
              .toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _NumberStepper extends StatelessWidget {
  const _NumberStepper({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('$value', style: const TextStyle(fontWeight: FontWeight.w700)),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }
}

class _ImagePickerRow extends StatelessWidget {
  const _ImagePickerRow({required this.images, required this.onPick});

  final List<String> images;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Images (max 5)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: images.map((e) => Chip(label: Text(_fileName(e)))).toList(),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.upload_file),
          label: const Text('Select Images'),
        ),
      ],
    );
  }

  String _fileName(String path) {
    final parts = path.split('/');
    if (parts.isEmpty) return path;
    return parts.last;
  }
}
