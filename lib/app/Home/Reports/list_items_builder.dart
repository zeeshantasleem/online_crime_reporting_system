
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlinecrimereportingsystem/app/Home/Reports/empty_container.dart';

typedef ItemWidgetBuilder<T>= Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({Key key,@required this.snapshot,@required this
      .itemBuilder}) : super
      (key:key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
  if(snapshot.hasData){
   final List<T> items = snapshot.data;
   if(items.isNotEmpty){
     return _buildList(items);
   } else {
     return EmptyContainer();
   }
  }else if(snapshot.hasError){
    return EmptyContainer(
      title: 'Something went wrong',
      message: 'Can\t load data right now',
    );
  }
  return Center(child: CircularProgressIndicator(),);
  }
  Widget _buildList(List<T> items){
    return ListView.separated(
      itemCount: items.length +2,
        separatorBuilder: (context, index) => Divider(height: 1.0,),
        itemBuilder: (context,index){
        if(index==0 || index == items.length+1){
          return Container();
    }
        return itemBuilder(context, items[index-1]);
        }
    );
  }
}
