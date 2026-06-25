class Tenant {
  final int? id;
  final String? name;
  final String? slug;
  final String? logo;
  final String? logoUrl;

  Tenant({
    this.id,
    this.name,
    this.slug,
    this.logo,
    this.logoUrl,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      logo: json['logo'],
      logoUrl: json['logo_url'],
    );
  }
}