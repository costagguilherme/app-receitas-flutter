class Receita {
  String id;
  String name;
  String description;
  String ingredients;
  String preparation;

  Receita({required this.id, required this.name, required this.description, required this.ingredients, required this.preparation});

  Receita.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        description = map["description"],
        ingredients = map["ingredients"],
        preparation = map["preparation"]
    ;

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "ingredients": ingredients,
      "preparation": preparation
    };
  }
}
