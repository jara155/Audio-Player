
class Strings {
  Map<String, dynamic> slovnik = {
    "cs-CZ": {
      "days": ["Pon", "Ute", "Stř", "Čtv", "Pát", "Sob", "Ned",],
      "month": ["Led", "Úno", "Bře", "Dub", "Kvě", "Čvn", "Čvc", "Srp", "Zář", "Říj", "Lis", "Pro"],
    },

    "en-US": {
      "days": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sun",],
      "month": ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
    },
  };

  static String stringToJson(String input) {
    input = input.replaceAll(":", ":");

    input = input.replaceAllMapped(RegExp(r'([a-zA-Z]+)\s*(:)\s*([a-zA-Z0-9---/-=]+)'), (match) => '"${match[1]}"${match[2]} "${match[3]}"');

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
    text = capitalize(text);

    for (var entry in slovnik.entries) {
      if(entry.key == text) return entry.value;
    }

    if(slovnik.entries.where((element) => element.key == "cs-CZ").isEmpty) return "Lang didn't found";

    for (var entry in slovnik["cs-CZ"].entries) {
      text = text.toLowerCase();
      if(entry.key == text) return entry.value;
    }

    return text;
  }

  static String capitalize(String text){
    text = text.toLowerCase();
    return text[0].toUpperCase() + text.substring(1);
  }
}