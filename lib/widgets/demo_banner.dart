import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class DemoBanner extends StatelessWidget {
  const DemoBanner({
    super.key,
    this.message =
        'Mode demo: autentikasi dan data masih berjalan di perangkat ini, belum terhubung ke server.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.blueTint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.blue.withValues(alpha: 0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              Icons.info_outline_rounded,
              size: 18,
              color: AppColors.blue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.navy,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
