import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'custom_reorderable_list_view.dart';
import 'package_example.dart';
import 'reorderable_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CustomReorderableListView(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? min;
  int? max;

  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();

    itemPositionsListener.itemPositions.addListener(() {
      //
      var positions = itemPositionsListener.itemPositions.value;
      //
      if (positions.isNotEmpty) {
        min = positions
            .where((ItemPosition position) => position.itemTrailingEdge > 0)
            .reduce((ItemPosition min, ItemPosition position) =>
                position.itemTrailingEdge < min.itemTrailingEdge
                    ? position
                    : min)
            .index;
        max = positions
            .where((ItemPosition position) => position.itemLeadingEdge < 1)
            .reduce((ItemPosition max, ItemPosition position) =>
                position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
            .index;
      }

      // setState(() {});
      print('item First: $min');
      print('item Last: $max');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizontal ListView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize_outlined),
            tooltip: "Custom Reorderable ListView",
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CustomReorderableListView())),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 5.0),
            alignment: Alignment.centerLeft,
            height: 40.0,
            width: double.infinity,
            child: ScrollablePositionedList.builder(
              scrollDirection: Axis.horizontal,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemCount: 100,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  itemScrollController.scrollTo(
                    index: index,
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    alignment: 0.3,
                  );
                  setState(() {});
                },
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  height: 40.0,
                  width: 80.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text('Item $index'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Scorable Positioned List Test\n\nFirst Item Index: $min\nLast Item Index: $max',
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              child: const Text('Reorderable View Page'),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReorderableViewPage())),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ScrollablePositionedListPage())),
        child: const Icon(Icons.info_outline),
      ),
    );
  }
}
