import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State Model
class DaySelectionState {
  final List<String> selectedDays;
  final List<String> selectedYears;
  final List<String> selectedMonths;

  DaySelectionState({
    required this.selectedDays,
    required this.selectedYears,
    required this.selectedMonths,
  });

  DaySelectionState copyWith({
    List<String>? selectedDays,
    List<String>? selectedYears,
    List<String>? selectedMonths,
  }) {
    return DaySelectionState(
      selectedDays: selectedDays ?? this.selectedDays,
      selectedYears: selectedYears ?? this.selectedYears,
      selectedMonths: selectedMonths ?? this.selectedMonths,
    );
  }
}

// Provider
class DaySelectionNotifier extends StateNotifier<DaySelectionState> {
  DaySelectionNotifier()
      : super(DaySelectionState(
          selectedDays: [],
          selectedYears: [],
          selectedMonths: [],
        )) {
    _loadSelections(); // Load saved selections
  }

  // Load saved selections
  Future<void> _loadSelections() async {
    final prefs = await SharedPreferences.getInstance();
    state = DaySelectionState(
      selectedDays: prefs.getStringList('selectedDays') ?? [],
      selectedYears: prefs.getStringList('selectedYears') ?? [],
      selectedMonths: prefs.getStringList('selectedMonths') ?? [],
    );
  }

  // Save selections
  Future<void> saveSelections() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedDays', state.selectedDays);
    await prefs.setStringList('selectedYears', state.selectedYears);
    await prefs.setStringList('selectedMonths', state.selectedMonths);
  }

  void toggleDay(String day) {
    state = state.selectedDays.contains(day)
        ? state.copyWith(
            selectedDays: state.selectedDays.where((d) => d != day).toList())
        : state.copyWith(selectedDays: [...state.selectedDays, day]);
    saveSelections();
  }

  void toggleYear(String year) {
    state = state.selectedYears.contains(year)
        ? state.copyWith(
            selectedYears: state.selectedYears.where((y) => y != year).toList())
        : state.copyWith(selectedYears: [...state.selectedYears, year]);
    saveSelections();
  }

  void toggleMonth(String month) {
    state = state.selectedMonths.contains(month)
        ? state.copyWith(
            selectedMonths:
                state.selectedMonths.where((m) => m != month).toList())
        : state.copyWith(selectedMonths: [...state.selectedMonths, month]);
    saveSelections();
  }

  void clearSelection() {
    state = DaySelectionState(
      selectedDays: [],
      selectedYears: [],
      selectedMonths: [],
    );
    saveSelections();
  }
}

final daySelectionProvider =
    StateNotifierProvider<DaySelectionNotifier, DaySelectionState>(
  (ref) => DaySelectionNotifier(),
);
