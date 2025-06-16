import 'package:flutter/material.dart';

import '../models/excel_data.dart';
import '../utils/constants.dart';

class StatisticsView extends StatelessWidget {
  final ProcessedExcelData processedData;

  const StatisticsView({
    super.key,
    required this.processedData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: HebrewStrings.totalRows,
                value: processedData.originalData.totalRows.toString(),
                icon: Icons.table_rows,
                color: AppColors.info,
              ),
            ),
            const SizedBox(width: AppSizes.marginM),
            Expanded(
              child: _buildStatCard(
                title: HebrewStrings.filteredRows,
                value: processedData.filteredRowCount.toString(),
                icon: Icons.filter_alt,
                color: AppColors.success,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.marginM),
        
        // Processing time and reduction
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: HebrewStrings.processingTime,
                value: processedData.statistics.formattedProcessingTime,
                icon: Icons.timer,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(width: AppSizes.marginM),
            Expanded(
              child: _buildStatCard(
                title: 'הפחתה',
                value: '${processedData.reductionPercentage.toStringAsFixed(1)}%',
                icon: Icons.trending_down,
                color: AppColors.accent3,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: AppSizes.marginM),
        
        // Processing details
        _buildDetailsCard(),
        
        // Warnings and errors
        if (processedData.statistics.hasWarnings || processedData.statistics.hasErrors) ...[
          const SizedBox(height: AppSizes.marginM),
          _buildWarningsErrorsCard(),
        ],
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: AppSizes.iconL),
          const SizedBox(height: AppSizes.marginS),
          Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSizes.marginXS),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, 
                color: AppColors.primary, 
                size: AppSizes.iconM,
              ),
              const SizedBox(width: AppSizes.marginS),
              Text(
                'פרטי עיבוד',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.marginM),
          
          _buildDetailRow('קובץ מקור:', processedData.originalData.fileName),
          _buildDetailRow('לוגיקה:', processedData.filterSettings.logicDescription),
          _buildDetailRow('טווח תאריכים:', processedData.filterSettings.dateRangeString),
          _buildDetailRow('מהירות עיבוד:', 
            '${processedData.statistics.processingSpeed.toStringAsFixed(0)} שורות/שנייה'),
          _buildDetailRow('זמן עיבוד:', 
            processedData.processedAt.toString().substring(0, 19)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.marginXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningsErrorsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: processedData.statistics.hasErrors 
          ? AppColors.error.withOpacity(0.1)
          : AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: processedData.statistics.hasErrors 
            ? AppColors.error.withOpacity(0.3)
            : AppColors.warning.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                processedData.statistics.hasErrors ? Icons.error : Icons.warning,
                color: processedData.statistics.hasErrors 
                  ? AppColors.error 
                  : AppColors.warning,
                size: AppSizes.iconM,
              ),
              const SizedBox(width: AppSizes.marginS),
              Text(
                processedData.statistics.hasErrors ? 'שגיאות' : 'אזהרות',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: processedData.statistics.hasErrors 
                    ? AppColors.error 
                    : AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.marginM),
          
          // Show errors
          if (processedData.statistics.hasErrors) ...[
            ...processedData.statistics.errors.map((error) => 
              _buildMessageRow(error, AppColors.error, Icons.error_outline)),
          ],
          
          // Show warnings
          if (processedData.statistics.hasWarnings) ...[
            ...processedData.statistics.warnings.map((warning) => 
              _buildMessageRow(warning, AppColors.warning, Icons.warning_outlined)),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageRow(String message, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.marginXS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: AppSizes.iconS),
          const SizedBox(width: AppSizes.marginS),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
} 