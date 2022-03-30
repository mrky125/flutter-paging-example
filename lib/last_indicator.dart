import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LastIndicator extends StatelessWidget {
  const LastIndicator(this.onVisible, {Key? key}) : super(key: key);

  final VoidCallback onVisible;

  @override
  Widget build(BuildContext context) {
    print("build progress");
    return VisibilityDetector(
      key: const Key('for detect visibility'),
      onVisibilityChanged: (info) {
        print("progress visibility changed: ${info.visibleFraction}");
        if (info.visibleFraction > 0.9) {
          onVisible();
        }
      },
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
