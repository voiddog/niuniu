import 'card.dart';

List<CardValue> sortByNiu(List<CardValue> cardList) {
  List<CardValue> ret;
  int total = cardList.fold(0, (s, item) => s + item.value);
  int maxResult = -1;
  for (int i = 0; i < cardList.length; ++i) {
    for (int j = i + 1; j < cardList.length; ++j) {
      for (int k = j + 1; k < cardList.length; ++k) {
        int result = cardList[i].value + cardList[j].value + cardList[k].value;
        if (result % 10 == 0) {
          result = total - result;
          result %= 10;
          if (result == 0) {
            result = 10;
          }
          if (result > maxResult) {
            maxResult = result;
            ret = [];
            ret.addAll(cardList);
            ret.remove(cardList[i]);
            ret.remove(cardList[j]);
            ret.remove(cardList[k]);
            ret.insert(0, cardList[i]);
            ret.insert(0, cardList[j]);
            ret.insert(0, cardList[k]);
          }
        }
      }
    }
  }
  return ret;
}
