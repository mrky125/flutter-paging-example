import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

// ConsumerWidgetを使うとbuild()からデータを受け取る事ができる
class _InfinityScrollPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 値が更新されたら自動的に反映される
    final count = ref.watch(countProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("paging example"),
        ),
        body: Column(
          children: [
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  "count $count",
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
              onTap: () {
                ref.read(countProvider.notifier).state += 1;
              },
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 100,
                itemBuilder: (BuildContext context, int index) {
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
              ),
            ),
          ],
        ));
  }
}
