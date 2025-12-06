import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class SearchAndSortForPropertyCubit
    extends Cubit<SearchAndSortForPropertyState> {
  SearchAndSortForPropertyCubit()
    : super(const SearchAndSortForPropertyState());

  void updateQuery(String value) {
    emit(state.copyWith(query: value));
  }

  void selectType(String type) {
    emit(state.copyWith(selectedType: type));
  }

  void toggleFilter() {
    emit(state.copyWith(showFilter: !state.showFilter));
  }

  void setBedroom(int value) {
    emit(state.copyWith(selectedBedroom: value));
  }

  void setSize(double value) {
    emit(state.copyWith(sizeValue: value));
  }

  void setPrice(double value) {
    emit(state.copyWith(priceValue: value));
  }

  void toggleFeature(String feature) {
    final next = Set<String>.from(state.selectedFeatures);
    if (next.contains(feature)) {
      next.remove(feature);
    } else {
      next.add(feature);
    }
    emit(state.copyWith(selectedFeatures: next));
  }

  void resetFilters() {
    emit(
      state.copyWith(
        selectedBedroom: 0,
        sizeValue: 500,
        priceValue: 5000000,
        selectedFeatures: <String>{},
      ),
    );
  }
}
