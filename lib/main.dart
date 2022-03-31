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
    const _threshold = 0.7;

    // 値が更新されたら自動的に反映される
    final state = ref.watch(postListControllerProvider);
    final posts = state.posts;
    final controller = ref.read(postListControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white70,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          // when scrolled
          final scrollProportion =
              scrollInfo.metrics.pixels / scrollInfo.metrics.maxScrollExtent;
          print("state: ${state.pageState}, proportion: $scrollProportion");
          if (state.pageState is! AsyncLoading &&
              scrollProportion > _threshold) {
            controller.loadMore();
          }
          return false;
        },
        child: posts.isNotEmpty
            // if items exist
            ? ListView.builder(
                itemCount: posts.length + (state.hasNext ? 1 : 0),
                itemBuilder: (BuildContext _context, int index) {
                  if (index == posts.length && state.hasNext) {
                    print("index: $index, length: ${posts.length}");
                    // アイテム数が少なくて画面内に収まった場合、onNotificationで通知されないので
                    // プログレスの表示を契機にして次ページを読み込む
                    // hack: しかし次ページ表示後にもアイテム数少なくてプログレスが表示する場合、
                    //  onVisibilityChangedが通知されないのでさらに次ページを読み込めない
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
              )
            // if items empty
            : ListView.builder(
                itemCount: 1,
                itemBuilder: (BuildContext _context, int index) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
      ),
    );

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
