class Subject {
  final int? id;
  final String? name;
  final int? tenantId;

  Subject({
    this.id,
    this.name,
    this.tenantId,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'],
      name: json['name'],
      tenantId: json['tenant_id'],
    );
  }
}