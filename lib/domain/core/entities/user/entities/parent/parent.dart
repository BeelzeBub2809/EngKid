class Parent {
  String name;
  String phone;
  Parent({
    required this.name,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
      };

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      name: json['name'] != null ? json['name'] as String : '',
      phone: json['phone'] != null ? json['phone'] as String : '',
    );
  }
}
