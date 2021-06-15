import 'package:app/public/strings.dart' as Strings;

formatDate(DateTime date) {
  String res = '${date.month}${Strings.month} ${date.day}${Strings.day}';
  if (date.year != DateTime.now().year)
    res = '${date.year}${Strings.year} ' + res;
  return res;
}
