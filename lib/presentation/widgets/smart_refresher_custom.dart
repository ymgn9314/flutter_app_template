import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmartRefreshHeader extends StatelessWidget {
  const SmartRefreshHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomHeader(
      builder: (context, mode) {
        if (mode == RefreshStatus.idle) {
          return const SizedBox.shrink();
        }
        return const SizedBox(
          height: 55,
          child: Center(child: CupertinoActivityIndicator()),
        );
      },
    );
  }
}

class SmartRefreshFooter extends StatelessWidget {
  const SmartRefreshFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (context, mode) {
        return SizedBox(
          height: 55,
          child: mode == LoadStatus.idle
              ? const SizedBox.shrink()
              : const Center(child: CupertinoActivityIndicator()),
        );
      },
    );
  }
}
