class User{
  final String id;
  final String name;
  final String avatar;
  final String age;
  final String city;
  final String birthdate;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.age,
    required this.city,
    required this.birthdate
});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      age: json['age'].toString(),
      city: json['city'],
      birthdate: json['birthdate']
    );
  }

}