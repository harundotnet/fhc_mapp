class Test {
  final int id;
  final String? code;
  final String name;
  final String? description;
  final String? testCategory;
  final String? testSubCategory;
  final bool? active;

  Test({
    required this.id,
    this.code,
    required this.name,
    this.description,
    this.testCategory,
    this.testSubCategory,
    this.active,
  });

  factory Test.fromJson(Map<String, dynamic> json) => Test(
    id: json['id'] as int,
    code: json['code'] as String?,
    name: json['name'] as String,
    description: json['description'] as String?,
    testCategory: json['testCategory'] as String?,
    testSubCategory: json['testSubCategory'] as String?,
    active: json['active'] as bool?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code,
    'name': name,
    'description': description,
    'testCategory': testCategory,
    'testSubCategory': testSubCategory,
    'active': active,
  };
}
