class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String? profilePicture;  // Changed to nullable

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profilePicture,  // Changed to optional
  });

  String get fullName => '$firstName $lastName';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      profilePicture: json['profilePicture'] as String?,  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'profilePicture': profilePicture,
    };
  }
}