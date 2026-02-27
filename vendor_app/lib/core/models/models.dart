class VendorOrderModel {
  final String id;
  final String serviceName;
  final String buyerName;
  final String price;
  final String status;
  final String date;
  final String deadline;

  const VendorOrderModel({
    required this.id,
    required this.serviceName,
    required this.buyerName,
    required this.price,
    required this.status,
    required this.date,
    required this.deadline,
  });
}

class VendorServiceModel {
  final String id;
  final String title;
  final String category;
  final String price;
  final double rating;
  final int orderCount;
  final String deliveryDays;
  final bool isActive;

  const VendorServiceModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.orderCount,
    required this.deliveryDays,
    this.isActive = true,
  });
}

class TransactionModel {
  final String id;
  final String description;
  final String amount;
  final String date;
  final bool isCredit;

  const TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}

class VendorProfile {
  final String name;
  final String email;
  final String phone;
  final double rating;
  final int totalOrders;
  final int completedOrders;
  final String walletBalance;
  final String totalEarnings;
  final String joinedDate;
  final List<String> skills;

  const VendorProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.rating,
    required this.totalOrders,
    required this.completedOrders,
    required this.walletBalance,
    required this.totalEarnings,
    required this.joinedDate,
    this.skills = const [],
  });
}
