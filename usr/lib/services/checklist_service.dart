import 'package:flutter/material.dart';

class ChecklistService extends ChangeNotifier {
  static final ChecklistService _instance = ChecklistService._internal();
  factory ChecklistService() => _instance;

  ChecklistService._internal();

  final Map<String, bool> _checklist = {
    'Preferences persist after refresh': false,
    'Match score calculates correctly': false,
    '"Show only matches" toggle works': false,
    'Save job persists after refresh': false,
    'Apply opens in new tab': false,
    'Status update persists after refresh': false,
    'Status filter works correctly': false,
    'Digest generates top 10 by score': false,
    'Digest persists for the day': false,
    'No console errors on main pages': false,
  };

  final Map<String, String> _tooltips = {
    'Preferences persist after refresh': 'Change preferences, reload the page, and verify they are restored.',
    'Match score calculates correctly': 'Manually verify the math on a job card match score.',
    '"Show only matches" toggle works': 'Toggle the switch and verify non-matching jobs are hidden.',
    'Save job persists after refresh': 'Save a job, reload the app, and check the saved jobs list.',
    'Apply opens in new tab': 'Click the apply button and verify it opens the link in a new browser tab.',
    'Status update persists after refresh': 'Change a job status, reload, and verify the status is preserved.',
    'Status filter works correctly': 'Filter the list by a specific status and verify only those jobs appear.',
    'Digest generates top 10 by score': 'Check that the daily digest contains exactly the top 10 jobs by score.',
    'Digest persists for the day': 'Reload the app and verify the digest does not regenerate for the same day.',
    'No console errors on main pages': 'Navigate through main pages and check the debug console for red errors.',
  };

  bool isChecked(String key) => _checklist[key] ?? false;
  String getTooltip(String key) => _tooltips[key] ?? '';
  List<String> get items => _checklist.keys.toList();

  int get completedCount => _checklist.values.where((v) => v).length;
  int get totalCount => _checklist.length;
  bool get isAllCompleted => completedCount == totalCount;

  void toggleItem(String key) {
    if (_checklist.containsKey(key)) {
      _checklist[key] = !(_checklist[key] ?? false);
      notifyListeners();
    }
  }

  void reset() {
    _checklist.updateAll((key, value) => false);
    notifyListeners();
  }
}
