class UserModel {
  final String? name;
  final String? image, uid;
  final String? age, bio, collegeName, semesterName, contact;
  UserModel({
     this.name,
    this.image,
    this.uid,
    this.age,
    this.bio,
    this.collegeName,
    this.semesterName,
    this.contact,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name']!,
        uid: json['uid']!,
        image: json['image']!,
        age: json['age']!,
        bio: json['bio']!,
        collegeName: json['collegeName']!,
        semesterName: json['semesterName']!,
        contact: json['contact']!,
      );

  Map<String, String> toJson(UserModel user) {
    Map<String, String> json = {
      'name': name!,
      'uid': uid!,
      'image': image!,
      'age': age!,
      'collegeName': collegeName!,
      'semesterName': semesterName!,
      'contact': contact!,
    };
    return json;
  }
}
