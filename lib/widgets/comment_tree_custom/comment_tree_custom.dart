import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:EngKid/widgets/comment_tree_custom/comment_child_widget_custom.dart';
import 'package:EngKid/widgets/comment_tree_custom/root_comment_widget_custom.dart';
import 'package:EngKid/widgets/comment_tree_custom/tree_theme_data_custom.dart';

typedef AvatarWidgetBuilder<T> = PreferredSize Function(
  BuildContext context,
  T value,
);
typedef ContentBuilder<T> = Widget Function(BuildContext context, T value);

class CommentTreeWidgetCustom<R, C> extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ROUTE_NAME = 'CommentTreeWidgetCustom';

  final R root;
  final List<C> replies;

  final AvatarWidgetBuilder<R>? avatarRoot;
  final ContentBuilder<R>? contentRoot;

  final AvatarWidgetBuilder<C>? avatarChild;
  final ContentBuilder<C>? contentChild;
  final TreeThemeDataCustom treeThemeData;

  const CommentTreeWidgetCustom(
    this.root,
    this.replies, {
    super.key,
    this.treeThemeData = const TreeThemeDataCustom(lineWidth: 1),
    this.avatarRoot,
    this.contentRoot,
    this.avatarChild,
    this.contentChild,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CommentTreeWidgetState<R, C> createState() =>
      _CommentTreeWidgetState<R, C>();
}

class _CommentTreeWidgetState<R, C>
    extends State<CommentTreeWidgetCustom<R, C>> {
  @override
  Widget build(BuildContext context) {
    final PreferredSize avatarRoot = widget.avatarRoot!(context, widget.root);
    return Provider<TreeThemeDataCustom>.value(
      value: widget.treeThemeData,
      child: Column(
        children: [
          RootCommentWidgetCustom(
            avatarRoot,
            widget.contentRoot!(context, widget.root),
          ),
          ...widget.replies.map(
            (e) => CommentChildWidgetCustom(
              isLast: widget.replies.indexOf(e) == (widget.replies.length - 1),
              avatar: widget.avatarChild!(context, e),
              avatarRoot: avatarRoot.preferredSize,
              content: widget.contentChild!(context, e),
            ),
          )
        ],
      ),
    );
  }
}
