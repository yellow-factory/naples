
//TODO: Segurament sobra si tenim el collection editor

///Receives a list and edits it's data on the side through an edit component
///It provides a way to add new elements to the list
// class ListSideEdit<T> extends StatefulWidget {
//   final FunctionOf0<Stream<T>> getStream;
//   final FunctionOf1<int, String> title;
//   final FunctionOf1<T, String> itemTitle;
//   final FunctionOf1<T, String> itemSubtitle;
//   final FunctionOf1<T, Widget> itemLeading;
//   final FunctionOf1<T, Widget> itemTrailing;
//   //final Widget header;

//   ListSideEdit({
//     @required this.getStream,
//     @required this.itemTitle,
//     this.itemSubtitle,
//     this.itemLeading,
//     this.itemTrailing,
//     this.title,
//     Key key,
//   }) : super(key: key);

//   @override
//   _ListSideEditState<T> createState() => _ListSideEditState<T>();
// }

// class _ListSideEditState<T> extends State<ListSideEdit<T>> {
//   GlobalKey<NaplesListViewState<T>> _listViewKey;

//   @override
//   void initState() {
//     super.initState();
//     _listViewKey = GlobalKey();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Loading(
//       child: DynamicList<T>(
//         key: _listViewKey,
//         getStream: widget.getStream,
//         itemTitle: widget.itemTitle,
//         itemSubtitle: widget.itemSubtitle,
//         itemLeading: widget.itemLeading,
//         itemTrailing: widget.itemTrailing,
//         header: ListTile(title: Text(widget.title(3))), //TODO: 3
//         //select: widget.select,
//         //header: widget.header,
//       ),
//     );
//   }
// }
