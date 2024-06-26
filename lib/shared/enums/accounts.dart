enum AccountType {
  patient('patient'),
  pharmacy('pharmacy'),
  company('company'),
  transporter('transporter'),
  admin('admin');

  final String type;
  const AccountType(this.type);

  factory AccountType.fromString(String string) {
    return values.firstWhere((element) => element.type == string);
  }
}
