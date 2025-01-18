class Avaliacao {
  String id;
  String comment;
  double score;

  Avaliacao({
    required this.id,
    required this.comment,
    required this.score,
  });

  Avaliacao.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        comment = map["comment"],
        score = map["score"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "comment": comment,
      "score": score,
    };
  }
}
