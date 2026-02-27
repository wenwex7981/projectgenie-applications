import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/data/mock_data.dart';
import '../../core/models/models.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Orders', style: AppTypography.headingMedium),
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: MockData.orders.length,
        itemBuilder: (context, index) {
          final order = MockData.orders[index];
          
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID #${order.id}', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(8)),
                      child: Text(order.status, style: AppTypography.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(order.serviceName, style: AppTypography.subheadingMedium.copyWith(fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                Text('Vendor: ${order.vendorName}', style: AppTypography.caption),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${order.price}', style: AppTypography.priceMedium),
                    TextButton(onPressed: () {}, child: Text('View Details', style: AppTypography.buttonSmall.copyWith(color: AppColors.accent))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
