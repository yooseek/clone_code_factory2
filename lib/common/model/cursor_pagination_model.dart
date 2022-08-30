import 'package:json_annotation/json_annotation.dart';

part 'cursor_pagination_model.g.dart';

// 임의의 타입을 받아서 serializable 가능하게 함
@JsonSerializable(
  genericArgumentFactories: true,
)
class CursorPagination<T> {
  final CursorPaginationMeta meta;
  final List<T> data;

  CursorPagination({
    required this.meta,
    required this.data,
  });
  
  factory CursorPagination.fromJson(Map<String,dynamic> json, T Function(Object? json) fromJsonT) =>
  _$CursorPaginationFromJson(json, fromJsonT);
}

@JsonSerializable()
class CursorPaginationMeta {
  final int count;
  final bool hasMore;

  const CursorPaginationMeta({
    required this.count,
    required this.hasMore,
  });

  factory CursorPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CursorPaginationMetaFromJson(json);
}
