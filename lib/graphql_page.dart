import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GraphqlPage extends StatefulWidget {
  const GraphqlPage({super.key});

  @override
  State<GraphqlPage> createState() => _GraphqlPageState();
}

class _GraphqlPageState extends State<GraphqlPage> {
  static const _pageSize = 10;

  final PagingController _pagingController = PagingController(firstPageKey: 1);

  GraphQLClient qlClient = GraphQLClient(
    link: HttpLink("https://graphqlzero.almansi.me/api"),
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );

  void fetchData(int pageKey) async {
    QueryResult queryResult = await qlClient.query(
      QueryOptions(
        variables: {
          "options": {
            "paginate": {"page": pageKey, "limit": _pageSize}
          }
        },
        document: gql(
          """
query (
  \$options: PageQueryOptions
) {
  posts(options: \$options) {
    data {
      id
      title
    }
    meta {
      totalCount
    }
  }
}
""",
        ),
      ),
    );

    final List newItems = queryResult.data?["posts"]["data"];
    final isLastPage = newItems.length < _pageSize;
    if (isLastPage) {
      _pagingController.appendLastPage(newItems);
      print(isLastPage);
    } else {
      final nextPageKey = pageKey + 1;

      _pagingController.appendPage(newItems, nextPageKey);
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView(
      pagingController: _pagingController,
      padding: const EdgeInsets.all(12),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
          var data = item as dynamic;
          String id = data["id"];
          String title = data["title"];
          return ListTile(
            leading: CircleAvatar(
              child: Text(id),
            ),
            title: Text(title),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
