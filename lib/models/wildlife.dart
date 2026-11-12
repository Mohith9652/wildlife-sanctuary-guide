class Animal {
  final String name;
  final String category;
  final String habitat;
  final String description;
  final String image;

  const Animal({
    required this.name,
    required this.category,
    required this.habitat,
    required this.description,
    required this.image,
  });
}

class Sanctuary {
  final String name;
  final String location;
  final String description;

  const Sanctuary({
    required this.name,
    required this.location,
    required this.description,
  });
}