class Character {
  late int charId;
  late String name;
  late String birthday;
  late List<dynamic> jobOccupation;
  late String image;
  late String status; // alive or dead
  late String nickname;
  late List<dynamic> appearance;
  late String portrayed;
  late String category;
  late List<dynamic> betterCallSaulAppearance;

  Character.fromJson(Map<String, dynamic> json) {
    charId = json['char_id'];
    name = json['name'];
    birthday = json['birthday'];
    jobOccupation = json['occupation'].cast<dynamic>();
    image = json['img'];
    status = json['status'];
    nickname = json['nickname'];
    appearance = json['appearance'].cast<dynamic>();
    portrayed = json['portrayed'];
    category = json['category'];
    betterCallSaulAppearance =
        json['better_call_saul_appearance'].cast<dynamic>();
  }
}
