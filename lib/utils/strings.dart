import 'package:audioplayer/utils/settings.dart';

class Strings {
  Map<String, dynamic> dictionary = {
    "cs-CZ": {
      "music": "Hudba",
      "local": "Lokální",
      "local-musics": "Lokální hudby",
      "player": "Přehrávač",
      "search": "Vyhledat",
      "settings": "Nastavení",
      "customisation": "Přizpůsobení",
      "customisation-desc": "Vzhled aplikace",
      "language": "Jazyk",
      "language-desc": "Překlad",
      "info-music": "Informace o hudbě",
      "size": "Velikost",
      "album": "Album",
      "extension": "Koncovka",
      "<unknown>": "Neuveden",
      "favorite-music": "Oblíbené",
      "last-played": "Naposledy hráno",
    },
    "en-US": {
      "music": "Music",
      "local": "Local",
      "local-musics": "Local music",
      "player": "Player",
      "search": "Search",
      "settings": "Settings",
      "customisation": "Customisation",
      "customisation-desc": "Visualization",
      "language": "Language",
      "language-desc": "Translate",
      "info-music": "Info about music",
      "size": "Size",
      "album": "Album",
      "extension": "Extension",
      "<unknown>": "Unknown",
      "favorite-music": "Favorite",
      "last-played": "Last played"
    },
    "pl-PL": {
      "music": "Muzyka",
      "local": "Lokalny",
      "local-musics": "Lokalna muzyka",
      "player": "Player",
      "search": "Wyszukaj",
      "settings": "Ustawienia",
      "customisation": "Dostosowywanie",
      "customisation-desc": "Wygląd aplikacji",
      "language": "Język",
      "language-desc": "Tłumaczenie",
      "info-music": "Informacje o muzyce",
      "size": "Wielkość",
      "album": "Album",
      "extension": "Przedłużenie",
      "<unknown>": "Nieznany",
      "favorite-music": "Ulubione",
      "last-played": "Ostatnio grał",
    }
  };

  static String stringToJson(String input) {
    input = input.replaceAll(":", ":");

    input = input.replaceAllMapped(
        RegExp(r'([a-zA-Z]+)\s*(:)\s*([a-zA-Z0-9---/-=]+)'),
        (match) => '"${match[1]}"${match[2]} "${match[3]}"');

    input = removeSpecialCharacters(input);

    return input;
  }

  static DateTime fixDate(DateTime date) {
    return DateTime.parse(date.toString().replaceAll("Z", ""));
  }

  static String removeSpecialCharacters(String input) {
    input = input.replaceAll("-", " ");
    input = input.replaceAll("/", ":");

    return input;
  }

  static String formatTime(Duration duration) {
    return "${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  static String reverse(String text, String splitter) {
    return text.split(splitter).reversed.join(splitter);
  }

  String translate(String text) {
    for (var entry in dictionary.entries) {
      if (entry.key == text) return entry.value;
    }

    if (dictionary.entries
        .where((element) => element.key == Settings().defaultLanguage())
        .isEmpty) return "Lang didn't found";

    for (var entry in dictionary[Settings().defaultLanguage()].entries) {
      text = text.toLowerCase();
      if (entry.key == text) return entry.value;
    }

    return capitalize(text);
  }

  static String capitalize(String text) {
    text = text.toLowerCase();
    return text[0].toUpperCase() + text.substring(1);
  }
}
