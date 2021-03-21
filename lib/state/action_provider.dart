import 'package:manga_reader/models/Chapter.dart';
import 'package:manga_reader/state/base_provider.dart';

class ActionProvider extends BaseProvider{
  List<Chapter>  selectedItems = List<Chapter>();

  selectItems(Chapter value){
    selectedItems.add(value);
    notifyListeners();
  }
  emptyItems(){
    selectedItems.clear();
    notifyListeners();
  }
  removeItem(Chapter value){
    selectedItems.remove(value);
    notifyListeners();
  }
}