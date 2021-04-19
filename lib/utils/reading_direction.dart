enum ReadingDirection{
  HORIZONTAL,
  VERTICAL
}
class ReadingDirectionModel{
  const ReadingDirectionModel(this.readingDirection,this.text);
  final ReadingDirection readingDirection;
  final String text;
}
List<ReadingDirectionModel> directions = [
  ReadingDirectionModel(ReadingDirection.HORIZONTAL, "Horizontal"),
  ReadingDirectionModel(ReadingDirection.VERTICAL, "Vertical"),
];