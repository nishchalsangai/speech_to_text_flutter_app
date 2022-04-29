class Restaurant {
  String _bot;
  String _human;

  Restaurant(this._bot, this._human);

  factory Restaurant.fromJSON(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return Restaurant("....", ".....");
    } else {
      return Restaurant(json["bot"], json["human"]);
    }
  }

  String get bot => _bot;
  String get human => _human;
}
