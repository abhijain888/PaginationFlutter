import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'network_api.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const _pageSize = 10;

  final PagingController _pagingController = PagingController(firstPageKey: 1);

  void getData(int pageKey) async {
    try {
      var response = await NetworkApi.getResponse(
        url: "https://picsum.photos/v2/list?page=$pageKey&limit=$_pageSize",
      );

      // print(response);

      final List newItems = response;
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
        print(isLastPage);
      } else {
        final nextPageKey = pageKey + 1;

        _pagingController.appendPage(newItems, nextPageKey);
      }
    } on Exception {
      _pagingController.retryLastFailedRequest();
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      getData(pageKey);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _pagingController.refresh();
      },
      child: PagedGridView(
        pagingController: _pagingController,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, item, index) {
            final data = item as dynamic;
            final url = data["download_url"];
            return CachedNetworkImage(
              imageUrl: url,
              imageBuilder: (context, imageProvider) {
                return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                );
              },
              placeholder: (context, url) => const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6)),
                child: Image(
                  image: AssetImage("assets/images/placeholder-course.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
