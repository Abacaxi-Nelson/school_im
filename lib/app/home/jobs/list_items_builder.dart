import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_im/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  ListItemsBuilder({Key key, @required this.data, @required this.itemBuilder, this.title, this.message})
      : super(key: key);
  final AsyncValue<List<T>> data;
  final ItemWidgetBuilder<T> itemBuilder;
  String title;
  String message;

  @override
  Widget build(BuildContext context) {
    print(title.isEmpty ? 'Something went wrong' : title);
    return data.when(
      data: (items) => items.isNotEmpty
          ? _buildList(items)
          : EmptyContent(
              title: title.isEmpty ? 'Something went wrong' : title,
              message: message.isEmpty ? 'Can\'t load items right now' : message,
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => EmptyContent(
        title: title.isEmpty ? 'Something went wrong' : title,
        message: message.isEmpty ? 'Can\'t load items right now' : message,
      ),
    );
  }

  Widget _buildList(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => const Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container(); // zero height: not visible
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
