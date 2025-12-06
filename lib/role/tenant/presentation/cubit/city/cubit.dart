import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'state.dart';

class CityCubit extends Cubit<CityState> {
  CityCubit() : super(const CityState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final jsonStr = await rootBundle.loadString('dummy_data/city.json');
      final Map<String, dynamic> data = json.decode(jsonStr);
      final rawCities = (data['citys'] as List<dynamic>? ?? []);
      final cities = rawCities
          .map((item) => City.fromMap(item as Map<String, dynamic>))
          .toList();
      emit(state.copyWith(cities: cities, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }
}
