import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScrollListViewModel extends StateNotifier<List<String>> {
  ScrollListViewModel() : super([]) {
    fetchList();
  }

  // once page size
  static const _addCount = 10;

  Future<void> fetchList() async {
    // dummy fetch
    final newList = await fetchNextListByDummyRepository();
    // set data
    state = state + newList;
  }

  Future<List<String>> fetchNextListByDummyRepository() async =>
      Future.delayed(const Duration(seconds: 2), () {
        final List<String> items = [];
        for (var i = 0; i < _addCount; i++) {
          final id = state.length + i + 1;
          items.add('item $id');
        }
        return items;
      });
}
