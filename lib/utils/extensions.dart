import 'package:fanga/models/chapter.dart';

extension UnifyList on List<Chapter>{
  List unique(){
    final ids = this.map((e) => e.url).toSet();
    this.retainWhere((x) => ids.remove(x.url));
    return this;
  }
}
