import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/post_list_state.dart';

final postListControllerProvider =
    StateNotifierProvider.autoDispose<PostListController, PostListState>(
        (ref) => PostListController(ref.read));

class PostListController extends StateNotifier<PostListState> {
  PostListController(this._read) : super(const PostListState()) {
    fetch();
  }

  @visibleForTesting
  PostListController.withDefaultValue(
    PostListState state,
    this._read,
  ) : super(state);

  final Reader _read;

  // PostRepository get _repo => _read(postRepositoryProvider);

  static const perPage = 10;

  @visibleForTesting
  Future<void> fetch({
    bool loadMore = false,
  }) async {
    print("fetch, loadMore: $loadMore");
    state = state.copyWith(pageState: const AsyncValue.loading());

    // final newItems = await _repo.fetch(
    //   page: state.page,
    //   perPage: perPage,
    //   query: state.query,
    // );
    final newItems = await fetchNextListByDummyRepository();
    print("new size: ${newItems.length}");
    state = state.copyWith(
      posts: [if (loadMore) ...state.posts, ...newItems],
      hasNext: newItems.length >= perPage,
      pageState: const AsyncValue.data(0),
    );
    print("updated size: ${state.posts.length}");
  }

  Future<List<String>> fetchNextListByDummyRepository() async =>
      Future.delayed(const Duration(seconds: 2), () {
        final List<String> items = [];
        for (var i = 0; i < perPage; i++) {
          final id = state.posts.length + i + 1;
          items.add('item $id');
        }
        return items;
      });

  void refresh() {
    setPage(1);
    fetch();
  }

  void loadMore() {
    print("loadMore, state: ${state.pageState}");
    if (state.pageState is! AsyncLoading) {
      setPage(state.page + 1);
      fetch(loadMore: true);
    }
  }

  void setQuery(String? value) async {
    if (state.query == value) {
      return;
    }

    state = state.copyWith(query: value);
    fetch();
  }

  void setPage(int page) {
    state = state.copyWith(page: page);
  }
}
