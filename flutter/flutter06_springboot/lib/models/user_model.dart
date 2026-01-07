class User {
  final String email;
  final String pwd;
  final String name;
  final String birth;
  final String gender;

  User({
    required this.email,
    required this.pwd,
    required this.name,
    required this.birth,
    required this.gender
  });

  // 서버로 보낼 때 사용하는 방법
  Map<String, dynamic> toJson() {
    return {
      'email' : email,
      'pwd' : pwd,
      'name' : name,
      'birth' : birth,
      'gender' : gender
    };
  }

  // 만약 서버에서 그걸 가져오는 경우라면? = 정보를 받아오는 경우
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] as String,
      pwd: json['pwd'] as String,
      name: json['name'] as String,
      birth: json['birth'] as String,
      gender: json['gender'] as String
    );
  }
}