class Tournament {
  int? id;
  String name;
  String userId;
  int teamsNumber;
  String startDate;
  String endDate;
  String description;

  Tournament(
      {this.id,
      required this.name,
      required this.userId,
      required this.teamsNumber,
      required this.startDate,
      required this.endDate,
      required this.description});

  factory Tournament.fromJson(Map<String, dynamic> parsedJson) {
    return Tournament(
        id: parsedJson['id'],
        name: parsedJson['name'],
        userId: parsedJson['user_id'],
        teamsNumber: parsedJson['teams_number'],
        startDate: parsedJson['dateh_start'],
        endDate: parsedJson['dateh_end'],
        description: parsedJson['description']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'description': description,
        'dateh_start': startDate,
        'dateh_end': endDate,
        'teams_number': teamsNumber
      };
}
