enum EquipmentType {
  patient('patient'),
  doctor('doctor');

  final String type;
  const EquipmentType(this.type);

  factory EquipmentType.fromString(String string) {
    return values.firstWhere((element) => element.type == string);
  }
}
