class UserModel {
  bool? success;
  Data? data;
  String? message;

  UserModel({
    this.success,
    this.data,
    this.message,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        success: json["success"],
        data: Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data?.toJson(),
        "message": message,
      };

  static var empty = UserModel(success: false);

  bool get isEmpty => success == false;

  bool get isNotEmpty => !isEmpty;
}

class Data {
  String? userId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? profilePic;
  String? address;
  GoalClass? goal;

  Data(
      {
      this.userId,
      this.firstName,
      this.lastName,
      this.phone,
      this.email,
      this.profilePic,
      this.address,
      this.goal});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        email: json["email"],
        profilePic: json["profile_pic"],
        address: json["address"],
        goal: json["goal"] == null ? null : GoalClass.fromJson(json["goal"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "profile_pic": profilePic,
        "address": address,
        "goal": goal?.toJson(),
      };
}

class GoalClass {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? type;
  int? targetValue;
  String? targetUnit;
  String? startDate;
  String? endDate;
  bool? isActive;

  GoalClass({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.type,
    this.targetValue,
    this.targetUnit,
    this.startDate,
    this.endDate,
    this.isActive,
  });

  factory GoalClass.fromJson(Map<String, dynamic> json) => GoalClass(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
        targetValue: json["target_value"],
        targetUnit: json["target_unit"],
        startDate: json["start_date"],
        endDate: json["end_date"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "type": type,
        "target_value": targetValue,
        "target_unit": targetUnit,
        "start_date": startDate,
        "end_date": endDate,
        "is_active": isActive,
      };
}
