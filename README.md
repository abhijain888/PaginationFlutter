# flutter_pagination
##### This project shows pagination in flutter app using GraphQl api and REST api. This project also shows how to implement GraphQl api and REST api in flutter app.

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Pagination is implemented using a plugin : infinite_scroll_pagination
Also important packages to intsall : 
    1. http
    2. graphql_flutter
This project also uses cached_network_image package to cache network images
##### Reason behind using infinite_scroll_pagination plugin
- Reduces boilerplate code 
- Handles pagination smoothly
- Highly customizable
- List view and grid view can be used with lazy loading
- Flutter favorite


## Let's breakdown into code now:

1. Initialize paging controller from infinite_scroll_pagination
```
final PagingController _pagingController = PagingController(firstPageKey: 1);
```
2. Bind a listener to this controller to listen to scroll changes and fetch new data accordingly. This should happen in initState method.
```
_pagingController.addPageRequestListener((pageKey) {
//getData method is implementin api requesting code and pageKey variable of type int is passed to it.
      getData(pageKey);
});
```
3. Fetch data using apis and append result list to this controller
```
//response is result after hitting api
final List newItems = response;
final isLastPage = newItems.length < _pageSize;
if (isLastPage) {
_pagingController.appendLastPage(newItems);
print(isLastPage);
} 
else 
{
final nextPageKey = pageKey + 1;
_pagingController.appendPage(newItems, nextPageKey);
}
```
4. Connect  _pagingController to PagedListView or PagedGridView where UI will be built.
```
PagedListView(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {
         ...
        },
      ),
    )
```
5. Don't forget to dispose _pagingController in dispose method.
```
_pagingController.dispose();
```



## Developers
MIT License

Copyright (c) 2019 TecOrb Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
