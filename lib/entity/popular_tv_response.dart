import 'package:json_annotation/json_annotation.dart';
import 'package:the_movie_db/entity/tv.dart';

part 'popular_tv_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularTVResponse {
  final int page;
  @JsonKey(name: 'results')
  final List<TV> tvs;
  final int totalResults;
  final int totalPages;

  PopularTVResponse({
    required this.page,
    required this.tvs,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularTVResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularTVResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularTVResponseToJson(this);
}
