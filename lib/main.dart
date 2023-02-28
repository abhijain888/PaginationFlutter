import 'package:flutter/material.dart';
import 'package:flutter_pagination/rest_api_page.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql_page.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  await initHiveForFlutter();
  await Hive.openBox('my-box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Pagination"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Rest API",
                ),
                Tab(
                  text: "GraphQL",
                ),
              ],
            ),
          ),
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              MyHomePage(),
              GraphqlPage(),
            ],
          ),
        ),
      ),
    );
  }
}
