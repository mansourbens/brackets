class Tournament {
  int id;
  String name;
  String userId;
  int teamsNumber;
  String startDate;
  String endDate;
  String description;

  Tournament(this.id, this.name, this.userId, this.teamsNumber, this.startDate,
      this.endDate, this.description);

  factory Tournament.fromJson(Map<String, dynamic> parsedJson) {
    return Tournament(
        parsedJson['id'],
        parsedJson['name'],
        parsedJson['user_id'],
        parsedJson['teams_number'],
        parsedJson['dateh_start'],
        parsedJson['dateh_end'],
        parsedJson['description']);
  }
}
