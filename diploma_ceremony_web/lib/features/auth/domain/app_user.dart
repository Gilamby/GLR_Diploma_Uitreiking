enum UserRole { student, family, friend, mentor, photographer }

class AppUser {
  const AppUser({
    required this.uid,
    required this.role,
    required this.examClass,
  });

  final String uid;
  final UserRole role;
  final String examClass;

  bool get canUpload => role == UserRole.mentor || role == UserRole.photographer;
  bool get canViewLivestream => true;
}
