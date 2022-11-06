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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Sliver Draggable List'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40.0,
            child: NestedScrollView(
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
                              int newIndex = headers.indexOf(headers[index]);
                              print('oldIndex: $oldIndex, newIndex: $newIndex');
                              //
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
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
                                    headers[index],
                                    Colors.red[300]!,
                                  ),
                                ),
                                childWhenDragging: KContainer(
                                  headers[index],
                                  Colors.red[300]!,
                                ),
                                child: KContainer(
                                  headers[index],
                                  Colors.green[300]!,
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
              body: CustomScrollView(
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
                              int newIndex = items.indexOf(items[index]);
                              print('oldIndex: $oldIndex, newIndex: $newIndex');
                              //
                              setState(() {
                                if (newIndex > oldIndex) {
                                  newIndex -= 1;
                                }
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
                                    items[index],
                                    Colors.red[300]!,
                                  ),
                                ),
                                childWhenDragging: KContainer(
                                  items[index],
                                  Colors.red[300]!,
                                ),
                                child: KContainer(
                                  items[index],
                                  Colors.grey[300]!,
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
        ],
      ),
    );
  }
}

class KContainer extends StatelessWidget {
  const KContainer(
    this.text,
    this.color, {
    super.key,
  });

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
