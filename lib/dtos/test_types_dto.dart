class TestTypesDto {
  final int id;
  final String name;
  bool isSelected;

  TestTypesDto({required this.id, required this.name, this.isSelected = false});

  factory TestTypesDto.fromJson(Map<String, dynamic> json) {
    return TestTypesDto(id: json['id'], name: json['name']);
  }
}
