import 'package:flutter/material.dart';
import '../services/checklist_service.dart';

class TestChecklistScreen extends StatefulWidget {
  const TestChecklistScreen({super.key});

  @override
  State<TestChecklistScreen> createState() => _TestChecklistScreenState();
}

class _TestChecklistScreenState extends State<TestChecklistScreen> {
  final ChecklistService _checklistService = ChecklistService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Checklist'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[50],
      body: ListenableBuilder(
        listenable: _checklistService,
        builder: (context, child) {
          final completed = _checklistService.completedCount;
          final total = _checklistService.totalCount;
          final isComplete = _checklistService.isAllCompleted;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(completed, total),
                const SizedBox(height: 24),
                const Text(
                  'Required Tests',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                _buildChecklist(),
                const SizedBox(height: 32),
                _buildActionButtons(isComplete),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(int completed, int total) {
    final isPassing = completed == total;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isPassing ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tests Passed',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed / $total',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isPassing ? Colors.green[700] : Colors.black87,
                    ),
                  ),
                ],
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: isPassing ? Colors.green[50] : Colors.orange[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPassing ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: isPassing ? Colors.green : Colors.orange,
                  size: 28,
                ),
              ),
            ],
          ),
          if (!isPassing) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.orange[800]),
                  const SizedBox(width: 8),
                  Text(
                    'Resolve all issues before shipping.',
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChecklist() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: _checklistService.items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == _checklistService.items.length - 1;
          final isChecked = _checklistService.isChecked(item);

          return Column(
            children: [
              CheckboxListTile(
                value: isChecked,
                onChanged: (val) {
                  _checklistService.toggleItem(item);
                },
                title: Text(
                  item,
                  style: TextStyle(
                    decoration: isChecked ? TextDecoration.lineThrough : null,
                    color: isChecked ? Colors.grey : Colors.black87,
                    fontSize: 15,
                  ),
                ),
                secondary: Tooltip(
                  message: _checklistService.getTooltip(item),
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.help_outline,
                    size: 20,
                    color: Colors.grey[400],
                  ),
                ),
                activeColor: Colors.blue[700],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (!isLast)
                Divider(height: 1, color: Colors.grey[100], indent: 56, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons(bool isComplete) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isComplete
                ? () {
                    Navigator.pushNamed(context, '/jt/08-ship');
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[700],
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[500],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: isComplete ? 2 : 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(isComplete ? Icons.rocket_launch : Icons.lock_outline, size: 20),
                const SizedBox(width: 12),
                Text(
                  isComplete ? 'Proceed to Ship' : 'Locked: Complete Tests',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {
            _checklistService.reset();
          },
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Reset Test Status'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
