import 'package:flutter/material.dart';

class DatePickerFilter extends StatelessWidget {
  const DatePickerFilter({
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.width = 280,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = MaterialLocalizations.of(context);
    final selectedDate = value == null ? null : DateUtils.dateOnly(value!);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.outlineVariant),
    );

    return SizedBox(
      width: width,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: border,
            enabledBorder: border,
            suffixIcon: selectedDate == null
                ? const Icon(Icons.calendar_month_outlined)
                : IconButton(
                    tooltip: 'Clear ${label.toLowerCase()} filter',
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => onChanged(null),
                  ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          child: Text(
            selectedDate == null
                ? localizations.dateHelpText
                : localizations.formatMediumDate(selectedDate),
            style: selectedDate == null
                ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final minimum = DateUtils.dateOnly(firstDate ?? DateTime(1900));
    final maximum = DateUtils.dateOnly(lastDate ?? DateTime(2100));
    final preferredDate = value == null ? today : DateUtils.dateOnly(value!);
    final initialDate = preferredDate.isBefore(minimum)
        ? minimum
        : preferredDate.isAfter(maximum)
        ? maximum
        : preferredDate;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimum,
      lastDate: maximum,
    );

    if (selectedDate != null) {
      onChanged(DateUtils.dateOnly(selectedDate));
    }
  }
}
