import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_state.freezed.dart';

@freezed
class PageState with _$PageState {
  const factory PageState.success() = PageStateSuccess;
  const factory PageState.loading() = PageStateLoading;
}
