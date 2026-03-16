import 'dart:convert';

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
  final String? documentUrl;
  final List<String> galleryImages;
  final List<String> features;
  final String difficulty;
  final bool isFeatured;
  final String createdAt;
  final Map<String, dynamic>? vendor;

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
    this.documentUrl,
    this.galleryImages = const [],
    this.features = const [],
    this.difficulty = 'Intermediate',
    this.isFeatured = false,
    this.createdAt = '',
    this.vendor,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    // Parse techStack - could be a JSON string or a list
    List<String> parseTechStack() {
      final raw = json['techStack'] ?? json['tech_stack'];
      if (raw is List) return List<String>.from(raw);
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return List<String>.from(decoded);
        } catch (_) {}
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    // Parse features
    List<String> parseFeatures() {
      final raw = json['features'];
      if (raw is List) return List<String>.from(raw);
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return List<String>.from(decoded);
        } catch (_) {}
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    // Parse gallery images
    List<String> parseGallery() {
      final raw = json['galleryImages'] ?? json['gallery_images'];
      if (raw is List) return List<String>.from(raw);
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return List<String>.from(decoded);
        } catch (_) {}
      }
      return [];
    }

    return ProjectModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      domain: json['domain']?.toString() ?? '',
      branch: json['branch']?.toString() ?? '',
      price: json['price']?.toString() ?? '₹0',
      originalPrice: json['originalPrice']?.toString() ?? json['original_price']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image_url']?.toString() ?? '',
      techStack: parseTechStack(),
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating']?.toDouble() ?? 0.0),
      reviewCount: json['reviewCount'] ?? json['review_count'] ?? 0,
      enrollees: json['enrollees'] ?? 0,
      videoUrl: json['videoUrl']?.toString() ?? json['video_url']?.toString() ?? '',
      documentUrl: json['documentUrl']?.toString() ?? json['document_url']?.toString(),
      galleryImages: parseGallery(),
      features: parseFeatures(),
      difficulty: json['difficulty']?.toString() ?? 'Intermediate',
      isFeatured: json['isFeatured'] ?? json['is_featured'] ?? false,
      createdAt: json['createdAt']?.toString() ?? json['created_at']?.toString() ?? '',
      vendor: json['vendor'] is Map ? Map<String, dynamic>.from(json['vendor']) : null,
    );
  }
}

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String vendorName;
  final String vendorAvatar;
  final String? vendorId;
  final String category;
  final String price;
  final String originalPrice;
  final double rating;
  final int reviewCount;
  final String deliveryDays;
  final String? imageUrl;
  final String? videoUrl;
  final String? documentUrl;
  final List<String> galleryImages;
  final List<String> features;
  final List<ReviewModel> reviews;
  final bool isFeatured;
  final bool isTrending;
  final Map<String, dynamic>? vendor;

  const ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.vendorName,
    this.vendorAvatar = '',
    this.vendorId,
    required this.category,
    required this.price,
    this.originalPrice = '',
    required this.rating,
    required this.reviewCount,
    required this.deliveryDays,
    this.imageUrl,
    this.videoUrl,
    this.documentUrl,
    this.galleryImages = const [],
    this.features = const [],
    this.reviews = const [],
    this.isFeatured = false,
    this.isTrending = false,
    this.vendor,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    // Parse features - could be a JSON string or a list
    List<String> parseFeatures() {
      final raw = json['features'];
      if (raw is List) return List<String>.from(raw);
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return List<String>.from(decoded);
        } catch (_) {}
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    // Parse gallery images
    List<String> parseGallery() {
      final raw = json['galleryImages'] ?? json['gallery_images'];
      if (raw is List) return List<String>.from(raw);
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) return List<String>.from(decoded);
        } catch (_) {}
      }
      return [];
    }

    // Get vendor avatar from vendor object if available
    String vendorAvatar = '';
    if (json['vendor'] is Map) {
      vendorAvatar = json['vendor']['profileImage']?.toString() ?? '';
    }
    vendorAvatar = vendorAvatar.isNotEmpty ? vendorAvatar : (json['vendorAvatar'] ?? json['vendor_avatar'] ?? '');

    // Get vendorName - prefer vendor object, then direct field
    String vendorName = '';
    if (json['vendor'] is Map) {
      vendorName = json['vendor']['businessName']?.toString() ?? json['vendor']['name']?.toString() ?? '';
    }
    vendorName = vendorName.isNotEmpty ? vendorName : (json['vendorName'] ?? json['vendor_name'] ?? '');

    return ServiceModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      vendorName: vendorName,
      vendorAvatar: vendorAvatar,
      vendorId: json['vendorId']?.toString() ?? json['vendor_id']?.toString(),
      category: json['category'] is Map
          ? (json['category']['title']?.toString() ?? '')
          : (json['category']?.toString() ?? ''),
      price: json['price']?.toString() ?? '0',
      originalPrice: json['originalPrice']?.toString() ?? json['original_price']?.toString() ?? '',
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : (json['rating']?.toDouble() ?? 0.0),
      reviewCount: json['reviewCount'] ?? json['review_count'] ?? 0,
      deliveryDays: json['deliveryDays']?.toString() ?? json['delivery_days']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image_url']?.toString(),
      videoUrl: json['videoUrl']?.toString() ?? json['video_url']?.toString(),
      documentUrl: json['documentUrl']?.toString() ?? json['document_url']?.toString(),
      galleryImages: parseGallery(),
      features: parseFeatures(),
      reviews: (json['reviews'] as List?)
              ?.map((r) => ReviewModel.fromJson(r))
              .toList() ??
          [],
      isFeatured: json['isFeatured'] ?? json['is_featured'] ?? false,
      isTrending: json['isTrending'] ?? json['is_trending'] ?? false,
      vendor: json['vendor'] is Map ? Map<String, dynamic>.from(json['vendor']) : null,
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
      userName: json['userName']?.toString() ?? json['user_name']?.toString() ?? '',
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
          : (json['count'] is int)
              ? (json['count'] as int)
              : (int.tryParse(json['service_count']?.toString() ?? json['count']?.toString() ?? '0') ?? 0),
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
  final String orderNumber;
  final String serviceName;
  final String serviceImage;
  final String vendorName;
  final String price;
  final String status;
  final String date;
  final List<OrderTimelineStep> timeline;

  const OrderModel({
    required this.id,
    this.orderNumber = '',
    required this.serviceName,
    this.serviceImage = '',
    required this.vendorName,
    required this.price,
    required this.status,
    required this.date,
    this.timeline = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Parse timeline from JSON string if needed
    List<OrderTimelineStep> parseTimeline() {
      final raw = json['timeline'];
      if (raw is List) {
        return raw.map((t) => OrderTimelineStep.fromJson(t)).toList();
      }
      if (raw is String) {
        try {
          final decoded = jsonDecode(raw);
          if (decoded is List) {
            return decoded.map((t) => OrderTimelineStep.fromJson(t)).toList();
          }
        } catch (_) {}
      }
      return [];
    }

    return OrderModel(
      id: json['id'] ?? '',
      orderNumber: json['orderNumber']?.toString() ?? '',
      serviceName: json['service']?['title'] ?? json['serviceName'] ?? '',
      serviceImage: json['service']?['imageUrl'] ?? json['serviceImage'] ?? '',
      vendorName: json['vendor']?['businessName'] ?? json['vendor']?['name'] ?? json['service']?['vendorName'] ?? json['vendorName'] ?? '',
      price: json['totalPrice']?.toString() ?? json['price']?.toString() ?? '0',
      status: json['status']?.toString() ?? 'Pending',
      date: json['date']?.toString() ?? '',
      timeline: parseTimeline(),
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
  final String vendorImage;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const ChatThread({
    required this.id,
    required this.vendorName,
    this.vendorImage = '',
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(
      id: json['vendorId']?.toString() ?? json['id']?.toString() ?? '',
      vendorName: json['vendor']?['businessName']?.toString() ?? json['vendor']?['name']?.toString() ?? json['vendorName']?.toString() ?? '',
      vendorImage: json['vendor']?['profileImage']?.toString() ?? '',
      lastMessage: json['lastMessage']?.toString() ?? '',
      time: json['lastTime']?.toString() ?? json['time']?.toString() ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      isOnline: json['isOnline'] ?? false,
    );
  }
}

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String walletBalance;
  final String college;
  final String branch;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    this.avatar = '',
    this.walletBalance = '0',
    this.college = '',
    this.branch = '',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['profileImage'] ?? json['avatar'] ?? '',
      walletBalance: json['walletBalance']?.toString() ?? '0',
      college: json['college'] ?? '',
      branch: json['branch'] ?? '',
    );
  }
}
