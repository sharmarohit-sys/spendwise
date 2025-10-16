import 'package:flutter/material.dart';
import 'package:spendwise/core/utils/date_time_callback.dart';

class DateSelector extends StatefulWidget {
  final void Function(DateTime)? onSelected;

  const DateSelector({super.key, this.onSelected});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  late ValueNotifier<DateTime> selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = ValueNotifier<DateTime>(DateTime.now());
  }

  @override
  void dispose() {
    selectedDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: selectedDate,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              selectedDate.value = date;
              widget.onSelected?.call(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 10),
                Text(
                  DateTimeCallback.getTimeInString(value),

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
