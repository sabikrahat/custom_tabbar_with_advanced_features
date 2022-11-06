import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'main.dart';

class StickyReorderableListView extends StatelessWidget {
  const StickyReorderableListView({super.key});

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
    return SizedBox(
      height: 45.0,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          Section(
            title: 'Category #1',
            headerColor: Colors.red,
            itemsShow: widget.items,
            itemsPinned: widget.pins,
            items: List.generate(
              20,
              (index) => KContainer(
                text: 'Item #${index + 1}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Section extends MultiSliver {
  Section({
    Key? key,
    required String title,
    required List<String> itemsShow,
    required List<String> itemsPinned,
    Color headerColor = Colors.white,
    Color titleColor = Colors.black,
    required List<Widget> items,
  }) : super(
          key: key,
          pushPinnedChildren: true,
          children: [
            SliverPinnedHeader(
              child: KContainer(text: title, color: headerColor),
              // child: ReorderableListView.builder(
              //   buildDefaultDragHandles: false,
              //   scrollDirection: Axis.horizontal,
              //   itemCount: itemsPinned.length,
              //   onReorder: (_, __) {},
              //   itemBuilder: (context, index) {
              //     return ReorderableDragStartListener(
              //       key: ValueKey('sticky-${itemsPinned[index]}'),
              //       index: index,
              //       child: InkWell(
              //         onLongPress: () {
              //           // pins = [...pins, items[index]];
              //           // items.removeAt(index);
              //           // setState(() {});
              //         },
              //         onTap: () {
              //           // setState(() => currentIndex = index);
              //           // debugPrint('Item $index');
              //           // _scrollController.animateTo(
              //           //   index * 50.0,
              //           //   duration: const Duration(seconds: 1),
              //           //   curve: Curves.easeInOut,
              //           // );
              //         },
              //         child: KContainer(text: itemsPinned[index]),
              //       ),
              //     );
              //   },
              // ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(items),
            ),
          ],
        );
}

class KContainer extends StatelessWidget {
  const KContainer({
    super.key,
    required this.text,
    this.isPinned = false,
    this.color = const Color.fromARGB(255, 224, 224, 224),
  });

  final String text;
  final bool isPinned;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      height: 40.0,
      width: 100.0,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
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
