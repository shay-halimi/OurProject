import 'package:meta/meta.dart';

@immutable
class Tag {
  const Tag({this.title});

  factory Tag.fromJson(Map<String, Object> map) {
    return Tag(
      title: map['title'] as String,
    );
  }

  final String title;

  @override
  String toString() {
    return '$Tag{title: $title}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tag && runtimeType == other.runtimeType && title == other.title;

  @override
  int get hashCode => title.hashCode;

  Map<String, Object> toJson() {
    return {'title': title};
  }

  static const empty = Tag(title: '');

  static const vegan = Tag(title: 'טבעוני');
  static const vegetarian = Tag(title: 'צמחוני');
  static const glutenFree = Tag(title: 'ללא גלוטן');
  static const kosher = Tag(title: 'כשר');

  bool get isEmpty => this == empty;

  bool get isNotEmpty => !isEmpty;
}
