class UserProfile {
  final String result;
  final int code;
  final String message;
  final ProfileData data;

  UserProfile({
    required this.result,
    required this.code,
    required this.message,
    required this.data,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      result: json['result'],
      code: json['code'],
      message: json['message'],
      data: ProfileData.fromJson(json['data']),   // FIXED
    );
  }
}

class ProfileData {
  final String id;
  final String userType;
  final String name;
  final String email;
  final String? profilePicture;
  final String? bio;
  final String? phone;
  final String? address;
  final String? organization;
  final String? experience;
  final String? specialist;

  ProfileData({
    required this.id,
    required this.userType,
    required this.name,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.phone,
    required this.address,
    required this.organization,
    required this.experience,
    required this.specialist,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'],
      userType: json['user_type'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      phone: json['phone'],
      address: json['address'],
      organization: json['organization'],
      experience: json['experience'],
      specialist: json['specialist'],
    );
  }
}
