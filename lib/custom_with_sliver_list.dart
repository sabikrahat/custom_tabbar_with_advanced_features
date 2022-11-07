import 'package:flutter/material.dart';

class CustomSliverDraggableList extends StatefulWidget {
  const CustomSliverDraggableList({super.key});

  @override
  State<CustomSliverDraggableList> createState() =>
      _CustomSliverDraggableListState();
}

class _CustomSliverDraggableListState extends State<CustomSliverDraggableList> {
  List<String> headers = List.generate(5, (index) => 'Header $index');
  List<String> items = List.generate(100, (index) => 'Item $index');
  final ScrollController _scrollControllerFull = ScrollController();
  final ScrollController _scrollControllerUnpinned = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Sliver Draggable List'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          SizedBox(
            height: 40.0,
            child: RawScrollbar(
              key: const PageStorageKey('full'),
              controller: _scrollControllerFull,
              thumbVisibility: true,
              radius: const Radius.circular(8.0),
              thickness: 5.0,
              thumbColor: Colors.blue.withOpacity(0.8),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: NestedScrollView(
                  controller: _scrollControllerFull,
                  scrollDirection: Axis.horizontal,
                  floatHeaderSlivers: true,
                  headerSliverBuilder: (context, scroll) {
                    return [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          List.generate(
                            headers.length,
                            (index) {
                              return DragTarget(
                                onWillAccept: (String? data) =>
                                    data?.split('-').last == 'pinned',
                                onAccept: (String data) {
                                  int oldIndex =
                                      headers.indexOf(data.split('-').first);
                                  int newIndex =
                                      headers.indexOf(headers[index]);
                                  print(
                                      'oldIndex: $oldIndex, newIndex: $newIndex');
                                  //
                                  setState(() {
                                    // if (newIndex > oldIndex) {
                                    //   newIndex -= 1;
                                    // }
                                    final val = headers.removeAt(oldIndex);
                                    headers.insert(newIndex, val);
                                  });
                                  //
                                },
                                builder: (context, _, __) {
                                  return Draggable(
                                    data: '${headers[index]}-pinned',
                                    feedback: Material(
                                      child: KContainer(
                                        text: headers[index],
                                        color: Colors.red[300]!,
                                      ),
                                    ),
                                    childWhenDragging: KContainer(
                                      text: headers[index],
                                      color: Colors.red[300]!,
                                    ),
                                    child: KContainer(
                                      text: headers[index],
                                      color: Colors.green[300]!,
                                      onTap: () => print(
                                          '>>> Tapped on Pinned ${headers[index]}'),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ];
                  },
                  body: RawScrollbar(
                    key: const PageStorageKey('unpinned'),
                    controller: _scrollControllerUnpinned,
                    thumbVisibility: true,
                    radius: const Radius.circular(8.0),
                    scrollbarOrientation: ScrollbarOrientation.top,
                    thickness: 5.0,
                    thumbColor: Colors.blue.withOpacity(0.8),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context)
                          .copyWith(scrollbars: false),
                      child: CustomScrollView(
                        controller: _scrollControllerUnpinned,
                        scrollDirection: Axis.horizontal,
                        slivers: [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              List.generate(
                                items.length,
                                (index) {
                                  return DragTarget(
                                    onWillAccept: (String? data) =>
                                        data?.split('-').last == 'unpinned',
                                    onAccept: (String data) {
                                      int oldIndex =
                                          items.indexOf(data.split('-').first);
                                      int newIndex =
                                          items.indexOf(items[index]);
                                      print(
                                          'oldIndex: $oldIndex, newIndex: $newIndex');
                                      //
                                      setState(() {
                                        // if (newIndex > oldIndex) {
                                        //   newIndex -= 1;
                                        // }
                                        final val = items.removeAt(oldIndex);
                                        items.insert(newIndex, val);
                                      });
                                      //
                                    },
                                    builder: (context, _, __) {
                                      return Draggable(
                                        data: '${items[index]}-unpinned',
                                        feedback: Material(
                                          child: KContainer(
                                            text: items[index],
                                            color: Colors.red[300]!,
                                          ),
                                        ),
                                        childWhenDragging: KContainer(
                                          text: items[index],
                                          color: Colors.red[300]!,
                                        ),
                                        child: KContainer(
                                          text: items[index],
                                          color: Colors.grey[300]!,
                                          onTap: () => print(
                                              '>>> Tapped on Unpinned ${items[index]}'),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KContainer extends StatelessWidget {
  const KContainer({
    super.key,
    required this.text,
    required this.color,
    this.onTap,
  });

  final String text;
  final Color color;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        height: 40.0,
        width: 80.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Text(text),
      ),
    );
  }
}
