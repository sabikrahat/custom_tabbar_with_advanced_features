import 'package:flutter/material.dart';

class ReorderableViewPage extends StatefulWidget {
  const ReorderableViewPage({Key? key}) : super(key: key);

  @override
  ReorderableViewPageState createState() => ReorderableViewPageState();
}

class ReorderableViewPageState extends State<ReorderableViewPage> {
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
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Reorderable ListView In Flutter"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort_by_alpha),
            tooltip: "Sort",
            onPressed: sorting,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 5.0),
            alignment: Alignment.centerLeft,
            height: 40.0,
            width: double.infinity,
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              header: kContainer('Header'),
              footer: kContainer('Footer'),
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
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Reorderable List Test',
                textScaleFactor: 1.5,
                textAlign: TextAlign.center,
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
