import 'package:flutter/material.dart';

import '../utils/constants.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final String message;
  final bool isIndeterminate;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    this.message = '',
    this.isIndeterminate = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress bar
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.radiusS),
            child: isIndeterminate
                ? const LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  )
                : LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
          ),
        ),
        
        const SizedBox(height: AppSizes.marginS),
        
        // Progress text
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (message.isNotEmpty)
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ),
            if (!isIndeterminate)
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ],
    );
  }
} 