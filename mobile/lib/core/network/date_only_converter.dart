import 'package:freezed_annotation/freezed_annotation.dart';

/// Maps .NET's `DateOnly` — serialized by System.Text.Json as `"yyyy-MM-dd"`
/// — to a plain [DateTime] at midnight local-agnostic (the API never attaches
/// a time or offset to these fields, so neither does this converter).
class DateOnlyConverter implements JsonConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
