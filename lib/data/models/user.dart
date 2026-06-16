class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final bool isVerified;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.isVerified,
    this.avatarUrl,
  });

  AppUser copyWith({
    String? fullName,
    String? email,
    String? phone,
    bool? isVerified,
    String? avatarUrl,
  }) =>
      AppUser(
        id: id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        isVerified: isVerified ?? this.isVerified,
        avatarUrl: avatarUrl ?? this.avatarUrl,
      );
}
