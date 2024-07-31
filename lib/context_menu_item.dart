import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class ContextMenuItem {
  final String label;
  final VoidCallback callback;

  ContextMenuItem({
    required this.label,
    required this.callback,
  });
}

extension ContextMenuList on List<ContextMenuItem> {
  /// If any custom actions have already been added,
  /// overwriting this map with an empty one or null
  /// does not remove them in the Semantics widget.
  /// You need to overwrite the default action.
  Map<CustomSemanticsAction, VoidCallback>? toCustomSemanticAction({
    bool overrideDefaultAction = false,
  }) {
    Map<CustomSemanticsAction, VoidCallback> actions = {};

    for (var item in this) {
      actions[CustomSemanticsAction(label: item.label)] = item.callback;
    }

    if (actions.isEmpty) {
      if (overrideDefaultAction) {
        return {
          const CustomSemanticsAction.overridingAction(
            hint: 'Activate',
            action: SemanticsAction.tap,
          ): () {}
        };
      } else {
        return null;
      }
    }

    return actions;
  }

  List<PopupMenuEntry>? toPopupMenuItems() {
    List<PopupMenuEntry> items = [];

    for (var item in this) {
      items.add(PopupMenuItem(onTap: item.callback, child: Text(item.label)));
    }

    if (items.isEmpty) return null;

    return items;
  }
}

void showContextMenu(BuildContext context, List<ContextMenuItem>? items) {
  if (items != null && items.isNotEmpty) {
    if (items.length == 1) {
      items.first.callback.call();
    } else {
      showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(0, 0, 0, 0),
        items: items.toPopupMenuItems()!,
      );
    }
  }
}
