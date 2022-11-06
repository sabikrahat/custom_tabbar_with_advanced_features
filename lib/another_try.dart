import 'package:flutter/material.dart';

import 'main.dart';

class AnotherTry extends StatelessWidget {
  const AnotherTry({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Reorderable ListView'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard_customize_outlined),
            tooltip: "Custom Reorderable ListView",
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage())),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50.0,
            color: Colors.green[100],
            child: Row(
              children: const [
                PinnedReorderableView(),
                // Container(
                //   height: 50.0,
                //   width: size.width / 3,
                //   color: Colors.blue[100],
                //   child: const PinnedReorderableView(),
                // ),
                Expanded(
                  child: ReorderableView(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PinnedReorderableView extends StatefulWidget {
  const PinnedReorderableView({Key? key}) : super(key: key);

  @override
  PinnedReorderableViewState createState() => PinnedReorderableViewState();
}

class PinnedReorderableViewState extends State<PinnedReorderableView> {
  List<String> items = List.generate(5, (index) => 'Item $index');
  //
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final itemss = items.removeAt(oldindex);
      items.insert(newindex, itemss);
    });
  }

  void sorting() => setState(() => items.sort());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 5.0),
      alignment: Alignment.centerLeft,
      height: 40.0,
      // width: double.infinity,
      child: ReorderableListView(
        // physics: const NeverScrollableScrollPhysics(),
        onReorder: reorderData,
        scrollDirection: Axis.horizontal,
        buildDefaultDragHandles: false,
        children: [
          ...List.generate(
            items.length,
            (index) => ReorderableDragStartListener(
              key: ValueKey(items[index]),
              index: index,
              child: InkWell(
                onTap: () => print('Item $index'),
                child: kContainer(items[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget kContainer(String text) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      height: 40.0,
      width: 80.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(text),
    );
  }
}

class ReorderableView extends StatefulWidget {
  const ReorderableView({Key? key}) : super(key: key);

  @override
  ReorderableViewState createState() => ReorderableViewState();
}

class ReorderableViewState extends State<ReorderableView> {
  List<String> items = List.generate(100, (index) => 'Item $index');
  //
  void reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final itemss = items.removeAt(oldindex);
      items.insert(newindex, itemss);
    });
  }

  void sorting() => setState(() => items.sort());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 5.0),
      alignment: Alignment.centerLeft,
      height: 40.0,
      width: double.infinity,
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        // header: kContainer('Header'),
        // footer: kContainer('Footer'),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        onReorder: reorderData,
        itemBuilder: (context, index) {
          return ReorderableDragStartListener(
            key: ValueKey(items[index]),
            index: index,
            child: InkWell(
              onTap: () => print('Item $index'),
              child: kContainer(items[index]),
            ),
          );
        },
      ),
    );
  }

  Widget kContainer(String text) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      height: 40.0,
      width: 80.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Text(text),
    );
  }
}
