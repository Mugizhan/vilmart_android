import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String? id;
  final String? username;
  final String? email;
  final String? role;
  final int? number;

  UserProfile({
    this.id,
    this.username,
    this.email,
    this.role,
    this.number,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      number: json['number'] is int
          ? json['number']
          : int.tryParse(json['number'].toString()) ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, username: $username, email: $email, role: $role, number: $number)';
  }
}

class Shop {
  final String? id;
  final String? shopName;
  final String? shopImageLink;
  final String? description;
  final String? category;
  final String? email;
  final String? gst;
  final String? phone;
  final String? ownerId;
  final String? ownerName;
  final String? rating;
  final Address? address;
  final LatLon? latlon;

  Shop({
    this.id,
    this.shopName,
    this.shopImageLink,
    this.description,
    this.category,
    this.email,
    this.gst,
    this.phone,
    this.ownerId,
    this.ownerName,
    this.rating,
    this.address,
    this.latlon,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['shopId'] ?? '',
      shopName: json['shopName'] ?? '',
      shopImageLink: json['shopImageLink'] ?? '',
      description: json['description'],
      category: json['category'] ?? '',
      email: json['email'] ?? '',
      gst: json['gst'] ?? '',
      phone: json['phone'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      rating: json['rating'] ?? '0',
      address: Address.fromJson(json['address'] ?? {}),
      latlon: LatLon.fromJson(json['latlon'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'Shop(id: $id, shopName: $shopName, image: $shopImageLink, category: $category, owner: $ownerName, email: $email, phone: $phone, rating: $rating, address: $address, latlon: $latlon)';
  }
}

class Address {
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;

  Address({
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      pincode: json['pincode'] ?? '',
    );
  }

  @override
  String toString() {
    return '$address, $city, $state, $country - $pincode';
  }
}

class LatLon {
  final double? latitude;
  final double? longitude;

  LatLon({
    this.latitude,
    this.longitude,
  });

  factory LatLon.fromJson(Map<String, dynamic> json) {
    return LatLon(
      latitude: (json['latitude'] is num) ? json['latitude'].toDouble() : 0.0,
      longitude: (json['longitude'] is num) ? json['longitude'].toDouble() : 0.0,
    );
  }

  @override
  String toString() {
    return 'Lat: $latitude, Lon: $longitude';
  }
}

class Order {
  final String? id;
  final String? sellerId;
  final String? userId;
  final String? status;
  final DateTime? timestamp;
  final OrderItem? item;

  Order({
    this.id,
    this.sellerId,
    this.userId,
    this.status,
    this.timestamp,
    this.item,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      userId: json['userId'] ?? '',
      status: json['status'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      item: OrderItem.fromJson(json['item'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'Order(id: $id, sellerId: $sellerId, userId: $userId, status: $status, timestamp: $timestamp, item: $item)';
  }
}

class OrderItem {
  final String? productId;
  final String? productName;
  final String? imageUrl;
  final double? price;
  final int? quantity;

  OrderItem({
    this.productId,
    this.productName,
    this.imageUrl,
    this.price,
    this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as int?) ?? 0,
    );
  }

  @override
  String toString() {
    return 'OrderItem(productId: $productId, name: $productName, price: $price, quantity: $quantity, imageUrl: $imageUrl)';
  }
}

class CartItem {
  final String? productId;
  final String? productName;
  final String? imageUrl;
  final double? price;
  final int? quantity;
  final String? sellerId;

  CartItem({
    this.productId,
    this.productName,
    this.imageUrl,
    this.price,
    this.quantity,
    this.sellerId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (json['quantity'] as int?) ?? 0,
      sellerId: json['sellerId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'sellerId': sellerId,
    };
  }

  @override
  String toString() {
    return 'CartItem(productId: $productId, productName: $productName, imageUrl: $imageUrl, price: $price, quantity: $quantity, sellerId: $sellerId)';
  }
}

class CompleteUserData {
  final UserProfile? userProfile;
  final List<Shop>? userShops;
  final List<Order>? orders;
  final List<CartItem>? cartItems;

  CompleteUserData({
    this.userProfile,
    this.userShops,
    this.orders,
    this.cartItems,
  });

  factory CompleteUserData.fromJson(Map<String, dynamic> json) {
    return CompleteUserData(
      userProfile: UserProfile.fromJson(json['userProfile'] ?? {}),
      userShops: (json['userShops'] as List<dynamic>?)
          ?.map((e) => Shop.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => Order.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      cartItems: (json['cartItems'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return '''
--- User Profile ---
$userProfile

--- Shops ---
${userShops?.map((s) => s.toString()).join('\n')}

--- Orders ---
${orders?.map((o) => o.toString()).join('\n')}

--- Cart Items ---
${cartItems?.map((c) => c.toString()).join('\n')}
''';
  }
}
