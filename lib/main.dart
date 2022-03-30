import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paging_example/scroll_list_view_model.dart';

import 'last_indicator.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _InfinityScrollPage(),
    );
  }
}

// StateProviderを使い受け渡すデータを定義する
// ※ Providerの種類は複数あるが、ここではデータを更新できるStateProviderを使う
final countProvider = StateProvider((ref) {
  return 0;
});

final postListScrollControllerProvider = Provider((ref) => ScrollController());

// ConsumerWidgetを使うとbuild()からデータを受け取る事ができる
class _InfinityScrollPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 値が更新されたら自動的に反映される
    final state = ref.watch(postListControllerProvider);
    final posts = state.posts;
    final controller = ref.read(postListControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white70,
      body: PrimaryScrollController(
        controller: ref.watch(postListScrollControllerProvider),
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              const SliverAppBar(
                floating: true,
                elevation: 0.5,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  // todo: searchBar
                  child: Text(
                    "search bar",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              // todo: refresh
              // CupertinoSliverRefreshControl(
              //   onRefresh: () async => controller.refresh(),
              // ),
              if (posts.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: Text('Not Found')),
                ),
              if (posts.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == posts.length && state.hasNext) {
                          return LastIndicator(controller.loadMore);
                        }
                        return Card(
                          child: Padding(
                            child: Text(
                              index.toString(),
                              style: const TextStyle(fontSize: 20.0),
                            ),
                            padding: const EdgeInsets.all(20.0),
                          ),
                        );
                      },
                      childCount: posts.length + (state.hasNext ? 1 : 0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
