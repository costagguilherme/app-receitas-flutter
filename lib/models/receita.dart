class Receita {
  String id;
  String name;
  String description;
  String ingredients;
  String preparation;
  bool favorite;

  Receita({required this.id, required this.name, required this.description, required this.ingredients, required this.preparation, this.favorite = false});

  Receita.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        description = map["description"],
        ingredients = map["ingredients"],
        preparation = map["preparation"],
        favorite = map["favorite"] ?? false
    ;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "ingredients": ingredients,
      "preparation": preparation,
      "favorite": favorite
    };
  }
}
