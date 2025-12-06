import 'package:equatable/equatable.dart';

class SearchAndSortForPropertyState extends Equatable {
  const SearchAndSortForPropertyState({
    this.query = '',
    this.selectedType = 'All',
    this.showFilter = false,
    this.selectedBedroom = 0,
    this.sizeValue = 500,
    this.priceValue = 5000000,
    this.selectedFeatures = const <String>{},
  });

  final String query;
  final String selectedType;
  final bool showFilter;
  final int selectedBedroom;
  final double sizeValue;
  final double priceValue;
  final Set<String> selectedFeatures;

  SearchAndSortForPropertyState copyWith({
    String? query,
    String? selectedType,
    bool? showFilter,
    int? selectedBedroom,
    double? sizeValue,
    double? priceValue,
    Set<String>? selectedFeatures,
  }) {
    return SearchAndSortForPropertyState(
      query: query ?? this.query,
      selectedType: selectedType ?? this.selectedType,
      showFilter: showFilter ?? this.showFilter,
      selectedBedroom: selectedBedroom ?? this.selectedBedroom,
      sizeValue: sizeValue ?? this.sizeValue,
      priceValue: priceValue ?? this.priceValue,
      selectedFeatures: selectedFeatures != null
          ? Set<String>.from(selectedFeatures)
          : this.selectedFeatures,
    );
  }

  @override
  List<Object> get props => [
    query,
    selectedType,
    showFilter,
    selectedBedroom,
    sizeValue,
    priceValue,
    selectedFeatures,
  ];
}
