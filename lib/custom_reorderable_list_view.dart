import 'package:flutter/material.dart';

import 'main.dart';

class CustomReorderableListView extends StatelessWidget {
  const CustomReorderableListView({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Body(
        items: List.generate(30, (index) => 'Item $index'),
        pins: const ['Item 11', 'Item 22'],
        pages: List.generate(100, (index) {
          return Container(
            color: Colors.primaries[index % Colors.primaries.length],
            alignment: Alignment.center,
            child: Text('Page $index'),
          );
        }),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.items,
    required this.pins,
    required this.pages,
  }) : super(key: key);

  final List<String> items;
  final List<String> pins;
  final List<Widget> pages;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _scrollController = ScrollController();
  //
  int currentIndex = 0;
  late List<String> items;
  late List<String> pins;
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    //
    items = widget.items;
    pins = widget.pins;
    pages = widget.pages;
  }

  void _reorderData(int oldindex, int newindex) {
    setState(() {
      if (newindex > oldindex) {
        newindex -= 1;
      }
      final itemss = widget.items.removeAt(oldindex);
      widget.items.insert(newindex, itemss);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('items: $items');
    print('pins: $pins');
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(2.0),
                alignment: Alignment.centerLeft,
                height: 40.0,
                width: double.infinity,
                child: ReorderableListView.builder(
                  scrollController: _scrollController,
                  buildDefaultDragHandles: false,
                  // header: kContainer('Header'),
                  // footer: kContainer('Footer'),
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  onReorder: _reorderData,
                  itemBuilder: (context, index) {
                    return ReorderableDragStartListener(
                      key: ValueKey(widget.items[index]),
                      index: index,
                      child: InkWell(
                        onLongPress: () {
                          pins = [...pins, items[index]];
                          items.removeAt(index);
                          setState(() {});
                        },
                        onTap: () {
                          setState(() => currentIndex = index);
                          debugPrint('Item $index');
                          _scrollController.animateTo(
                            index * 50.0,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: kContainer(widget.items[index],
                            pins.any((e) => e == items[index])),
                      ),
                    );
                  },
                ),
              ),
              Expanded(child: pages[currentIndex]),
            ],
          ));
    });
  }

  Widget kContainer(String text, [bool isPinned = false]) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      height: 40.0,
      width: 100.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPinned)
            const Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(Icons.push_pin_outlined, size: 16.0),
            ),
          Text(text),
          const SizedBox(width: 4.0),
          const Icon(Icons.close, size: 18.0),
        ],
      ),
    );
  }
}
