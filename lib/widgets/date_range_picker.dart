import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';

class DateRangePicker extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, DateTime?) onDateRangeChanged;

  const DateRangePicker({
    super.key,
    this.startDate,
    this.endDate,
    required this.onDateRangeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDateButton(
                context: context,
                label: HebrewStrings.fromDate,
                date: startDate,
                onDateSelected: (date) => onDateRangeChanged(date, endDate),
              ),
            ),
            const SizedBox(width: AppSizes.marginM),
            Expanded(
              child: _buildDateButton(
                context: context,
                label: HebrewStrings.toDate,
                date: endDate,
                onDateSelected: (date) => onDateRangeChanged(startDate, date),
              ),
            ),
          ],
        ),
        
        if (startDate != null && endDate != null) ...[
          const SizedBox(height: AppSizes.marginM),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.info.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, 
                  color: AppColors.info, 
                  size: AppSizes.iconS,
                ),
                const SizedBox(width: AppSizes.marginS),
                Text(
                  _getDurationText(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.info,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateButton({
    required BuildContext context,
    required String label,
    required DateTime? date,
    required Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.marginS),
        
        InkWell(
          onTap: () => _showDatePicker(context, date, onDateSelected),
          borderRadius: BorderRadius.circular(AppSizes.radiusM),
          child: Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              color: AppColors.inputBackground,
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, 
                  color: AppColors.primary, 
                  size: AppSizes.iconM,
                ),
                const SizedBox(width: AppSizes.marginS),
                Expanded(
                  child: Text(
                    date != null 
                      ? _formatDate(date)
                      : 'בחר תאריך',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: date != null 
                        ? AppColors.textPrimary 
                        : AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(
    BuildContext context, 
    DateTime? currentDate, 
    Function(DateTime) onDateSelected,
  ) {
    showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('he', 'IL'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    ).then((selectedDate) {
      if (selectedDate != null) {
        onDateSelected(selectedDate);
      }
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'he').format(date);
  }

  String _getDurationText() {
    if (startDate == null || endDate == null) return '';
    
    final difference = endDate!.difference(startDate!).inDays + 1;
    
    if (difference == 1) {
      return 'יום אחד';
    } else if (difference <= 7) {
      return '$difference ימים';
    } else if (difference <= 30) {
      final weeks = (difference / 7).round();
      return '$weeks שבועות (~$difference ימים)';
    } else {
      final months = (difference / 30).round();
      return '$months חודשים (~$difference ימים)';
    }
  }
} 