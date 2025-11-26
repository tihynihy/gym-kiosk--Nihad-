class Member {
  final String id;
  final String firstName;
  final String lastName;
  final String profilePicture;

  Member({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
  });

  String get fullName => '$firstName $lastName';

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePicture: json['profilePicture'],
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