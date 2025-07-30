class Meal {
  final int? id;
  final String name;
  final String image;
  final double requiredTime;
  final double rate;
  final bool available;
  final String description;
  final List<String> images;
  final bool vegetarianFriendly;
  final bool glutenFree;
  final bool allergySafe;
  final bool lowCalorie;
  final String status;

  Meal({
    this.id,
    required this.name,
    required this.image,
    required this.requiredTime,
    required this.rate,
    required this.available,
    required this.description,
    required this.images,
    required this.vegetarianFriendly,
    required this.glutenFree,
    required this.allergySafe,
    required this.lowCalorie,
    this.status = 'available'
  });

  // Convert Meal to a Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': requiredTime,
      'rate': rate,
      'available': available ? 1 : 0, // Store boolean as integer
      'description': description,
      'images': images.join(','), // Convert images list to a string
      'tv': vegetarianFriendly ? 1 : 0,
      'shower': glutenFree ? 1 : 0,
      'wifi': allergySafe ? 1 : 0,
      'breakfast': lowCalorie ? 1 : 0,
      'status': status
    };
  }

  // Convert a Map to a Meal object
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      requiredTime: map['price'],
      rate: map['rate'],
      available: map['available'] == 1,
      description: map['description'],
      images: map['images'].split(','), // Parse string back into list
      vegetarianFriendly: map['tv'] == 1,
      glutenFree: map['shower'] == 1,
      allergySafe: map['wifi'] == 1,
      lowCalorie: map['breakfast'] == 1,
      status: map['status']
    );
  }
}
