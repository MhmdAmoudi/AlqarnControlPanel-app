import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:manage/api/response_error.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../utilities/appearance/style.dart';

class InfiniteList<T> extends StatefulWidget {
  const InfiniteList({
    required this.getItems,
    required this.child,
    required this.items,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.initialIds = const [],
    this.doneText = 'نهاية القائمة',
    this.allInOnce = false,
    Key? key,
  }) : super(key: key);

  final Widget Function(int) child;
  final List<String> initialIds;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Future<List<T>> Function(List<String> sentItemsIds) getItems;
  final void Function()? onRefresh;
  final String doneText;
  final bool allInOnce;
  final List<T> items;

  @override
  State<InfiniteList> createState() => _InfiniteListState<T>();
}

class _InfiniteListState<T> extends State<InfiniteList<T>> {
  List<String> sentItemsIds = [];

  String noMoreItems = '';

  bool hasMore = true;
  bool isLoading = false;
  bool completed = false;

  RxBool isVisible = RxBool(true);

  final Key key = GlobalKey();
  List<T> items = [];

  @override
  void initState() {
    if (widget.initialIds.isNotEmpty) {
      sentItemsIds.addAll(widget.initialIds);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: AppColors.darkSubColor,
      onRefresh: () async {
        noMoreItems = '';
        hasMore = true;
        isLoading = false;
        completed = false;
        sentItemsIds.clear();
        if (widget.onRefresh != null) widget.onRefresh!();
        widget.items.clear();
        return getMoreItems();
      },
      child: Padding(
        padding: widget.margin,
        child: ListView(
          padding: widget.padding,
          children: [
            Column(
              children: List.generate(
                widget.items.length,
                (index) => widget.child(index),
              ),
            ),
            VisibilityDetector(
              key: key,
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction == 1) getMoreItems();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 30),
                child: Center(
                  child: hasMore
                      ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: AppColors.mainColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          noMoreItems,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getMoreItems() async {
    if (isLoading || completed) return;
    isLoading = true;
    hasMore = true;
    try {
      items = await widget.getItems(sentItemsIds);
      widget.items.addAll(items);
      if (items.isEmpty || widget.allInOnce) {
        completed = true;
        hasMore = false;
        noMoreItems = widget.doneText;
      } else {
        for (dynamic item in items) {
          sentItemsIds.add(item.id);
        }
      }
    } on ResponseError catch (e) {
      completed = false;
      hasMore = false;
      noMoreItems = e.message;
    }
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
