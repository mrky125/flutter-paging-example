import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paging_example/data/page_state.dart';

part 'post_list_state.freezed.dart';

@freezed
class PostListState with _$PostListState {
  const factory PostListState({
    @Default(<String>[]) List<String> posts,
    @Default(false) bool hasNext,
    @Default(1) int page,
    String? query,
    @Default(PageStateLoading()) PageState pageState,
  }) = _PostListState;
}
