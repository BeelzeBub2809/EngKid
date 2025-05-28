class Teacher {
  String name;
  String phone;
  Teacher({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      name: json['name'] != null ? json['name'] as String : '',
      phone: json['phone'] != null ? json['phone'] as String : '',
    );
  }
}
