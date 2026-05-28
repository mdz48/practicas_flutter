class PetEntity {
  final String id;
  final String name;
  final String specie;
  final String breed;
  final int age;
  final String ownerId;

  PetEntity({
    required this.id,
    required this.name,
    required this.specie,
    required this.breed,
    required this.age,
    required this.ownerId,
  });

  factory PetEntity.fromJson(Map<String, dynamic> json) => PetEntity(
    id: json['id'],
    name: json['name'],
    specie: json['specie'],
    breed: json['breed'],
    age: json['age'],
    ownerId: json['ownerId'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specie': specie,
    'breed': breed,
    'age': age,
    'ownerId': ownerId,
  };
}
