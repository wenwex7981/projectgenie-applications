// ─── Enterprise Data Models ────────────────────────────────────────
// All models for ProjectGenie platform

class ProjectModel {
  final String id;
  final String title;
  final String domain;
  final String branch;
  final String price;
  final String originalPrice;
  final String description;
  final String imageUrl;
  final List<String> techStack;
  final double rating;
  final int reviewCount;
  final int enrollees;
  final String videoUrl;
  final String difficulty;
  final bool isFeatured;
  final String createdAt;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.domain,
    required this.branch,
    required this.price,
    this.originalPrice = '',
    required this.description,
    this.imageUrl = '',
    this.techStack = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.enrollees = 0,
    this.videoUrl = '',
    this.difficulty = 'Intermediate',
    this.isFeatured = false,
    this.createdAt = '',
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      domain: json['domain']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      price: json['price']?.toString() ?? '₹0',
      originalPrice: json['original_price']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? '',
      techStack: List<String>.from(json['tech_stack'] ?? []),
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating']?.toDouble() ?? 0.0),
      reviewCount: json['review_count'] ?? 0,
      enrollees: json['enrollees'] ?? 0,
      videoUrl: json['video_url']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? 'Intermediate',
      isFeatured: json['is_featured'] ?? false,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String vendorName;
  final String vendorAvatar;
  final String category;
  final String price;
  final String originalPrice;
  final double rating;
  final int reviewCount;
  final String deliveryDays;
  final String imageUrl;
  final List<String> features;
  final List<ReviewModel> reviews;
  final bool isFeatured;
  final bool isTrending;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.vendorName,
    this.vendorAvatar = '',
    required this.category,
    required this.price,
    this.originalPrice = '',
    required this.rating,
    required this.reviewCount,
    required this.deliveryDays,
    this.imageUrl = '',
    this.features = const [],
    this.reviews = const [],
    this.isFeatured = false,
    this.isTrending = false,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      vendorName: json['vendor_name'] ?? json['vendorName'] ?? '',
      vendorAvatar: json['vendor_avatar'] ?? json['vendorAvatar'] ?? '',
      category: json['category'] is Map
          ? (json['category']['title']?.toString() ?? '')
          : (json['category']?.toString() ?? ''),
      price: json['price']?.toString() ?? '0',
      originalPrice: json['original_price']?.toString() ?? json['originalPrice']?.toString() ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating']?.toDouble() ?? 0.0),
      reviewCount: json['review_count'] ?? json['reviewCount'] ?? 0,
      deliveryDays: json['delivery_days']?.toString() ?? json['deliveryDays']?.toString() ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      reviews: (json['reviews'] as List?)
              ?.map((r) => ReviewModel.fromJson(r))
              .toList() ??
          [],
      isFeatured: json['is_featured'] ?? json['isFeatured'] ?? false,
      isTrending: json['is_trending'] ?? json['isTrending'] ?? false,
    );
  }
}

class ReviewModel {
  final String userName;
  final double rating;
  final String comment;
  final String date;

  const ReviewModel({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userName: json['user_name']?.toString() ?? json['userName']?.toString() ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating']?.toDouble() ?? 0.0),
      comment: json['comment']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
    );
  }
}

class CategoryModel {
  final String id;
  final String title;
  final String icon;
  final String subtitle;
  final int serviceCount;
  final String color;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    this.subtitle = '',
    required this.serviceCount,
    this.color = '',
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      serviceCount: (json['service_count'] is int)
          ? (json['service_count'] as int)
          : (int.tryParse(json['service_count']?.toString() ?? '0') ?? 0),
      color: json['color']?.toString() ?? '',
    );
  }
}

class DomainFilter {
  final String id;
  final String name;
  final String shortName;
  final int projectCount;

  const DomainFilter({
    required this.id,
    required this.name,
    required this.shortName,
    this.projectCount = 0,
  });
}

class OrderModel {
  final String id;
  final String serviceName;
  final String vendorName;
  final String price;
  final String status;
  final String date;
  final List<OrderTimelineStep> timeline;

  const OrderModel({
    required this.id,
    required this.serviceName,
    required this.vendorName,
    required this.price,
    required this.status,
    required this.date,
    this.timeline = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      serviceName: json['service']?['title'] ?? json['serviceName'] ?? '',
      vendorName: json['service']?['vendorName'] ?? json['vendorName'] ?? '',
      price: json['totalPrice']?.toString() ?? json['price']?.toString() ?? '0',
      status: json['status']?.toString() ?? 'Pending',
      date: json['date']?.toString() ?? '',
      timeline: (json['timeline'] as List?)
              ?.map((t) => OrderTimelineStep.fromJson(t))
              .toList() ??
          [],
    );
  }
}

class OrderTimelineStep {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isCurrent;

  const OrderTimelineStep({
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  factory OrderTimelineStep.fromJson(Map<String, dynamic> json) {
    return OrderTimelineStep(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      isCurrent: json['isCurrent'] ?? false,
    );
  }
}

class ChatMessage {
  final String id;
  final String text;
  final bool isSender;
  final String time;
  final MessageType type;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isSender,
    required this.time,
    this.type = MessageType.text,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      isSender: json['isSender'] ?? false,
      time: json['time']?.toString() ?? '',
    );
  }
}

enum MessageType { text, image, file }

class ChatThread {
  final String id;
  final String vendorName;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ChatThread({
    required this.id,
    required this.vendorName,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String walletBalance;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.avatar = '',
    this.walletBalance = '0',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['profileImage'] ?? '',
      walletBalance: json['walletBalance']?.toString() ?? '0',
    );
  }
}
