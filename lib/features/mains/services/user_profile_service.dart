import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_vokasi/features/mains/models/user_profile_model.dart';

class UserProfileService {
  final String baseUrl =
      "https://api-rumah-vokasi.dnabisa.com/rumah-vokasi-main";

  Future<ProfileData?> getProfile(String token, String userID) async {
    final url = Uri.parse("$baseUrl/admin/user-profile?id=$userID");

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final profile = UserProfile.fromJson(jsonMap);
      return profile.data;
    } else {
      return null;
    }
  }

  Future<bool> updateProfile({
    required String userID,
    required String name,
    required String email,
    required String profilePicture,
    required String bio,
    required String phone,
    required String address,
    required String experience,
    required String specialist,
    required String document,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/user/profile");

    final body = jsonEncode({
      "id": userID,
      "user_type": "STUDENT",
      "name": name,
      "email": email,
      "profile_picture": profilePicture,
      "bio": bio,
      "phone": phone,
      "address": address,
      "experience": experience,
      "specialist": specialist,
      "dokumen_kompetensi": document,
    });

    try {
      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
