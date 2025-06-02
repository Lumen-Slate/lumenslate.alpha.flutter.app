class Variable {
  String id;
  String name;
  List<int> namePositions;
  String value;
  List<int> valuePositions;
  String variableType;

  Variable({
    required this.id,
    required this.name,
    required this.namePositions,
    required this.value,
    required this.valuePositions,
    required this.variableType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'namePositions': namePositions,
      'value': value,
      'valuePositions': valuePositions,
      'variableType': variableType,
    };
  }

  factory Variable.fromJson(Map<String, dynamic> json) {
    return Variable(
      id: json['id'],
      name: json['name'],
      namePositions: List<int>.from(json['namePositions']),
      value: json['value'],
      valuePositions: List<int>.from(json['valuePositions']),
      variableType: json['variableType'],
    );
  }
}