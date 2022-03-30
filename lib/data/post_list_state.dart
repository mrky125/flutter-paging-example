import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'post_list_state.freezed.dart';

@freezed
class PostListState with _$PostListState {
  const factory PostListState({
    @Default(<String>[]) List<String> posts,
    @Default(false) bool hasNext,
    @Default(1) int page,
    String? query,
    @Default(AsyncLoading()) AsyncValue pageState,
  }) = _PostListState;
}
