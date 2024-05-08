import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:pluto_grid/pluto_grid.dart';

/// Class for setting shortcut actions.
///
/// Defaults to [PlutoGridShortcut.defaultActions] if not passing [actions].
class PlutoGridShortcut {
  const PlutoGridShortcut({
    Map<ShortcutActivator, PlutoGridShortcutAction>? actions,
  }) : _actions = actions;

  /// Custom shortcuts and actions.
  ///
  /// When the shortcut set in [ShortcutActivator] is input,
  /// the [PlutoGridShortcutAction.execute] method is executed.
  Map<ShortcutActivator, PlutoGridShortcutAction> get actions =>
      _actions ?? defaultActions;

  final Map<ShortcutActivator, PlutoGridShortcutAction>? _actions;

  /// If the shortcut registered in [actions] matches,
  /// the action for the shortcut is executed.
  ///
  /// If there is no matching shortcut and returns false ,
  /// the default shortcut behavior is processed.
  bool handle({
    required PlutoKeyManagerEvent keyEvent,
    required PlutoGridStateManager stateManager,
    required HardwareKeyboard state,
  }) {
    if (keyEvent.event is! KeyRepeatEvent && keyEvent.event is! KeyDownEvent) {
      return false;
    }

    List<LogicalKeyboardKey> lista = [];

    for (final key in keyEvent.instance.logicalKeysPressed) {
      if (notHasModifiers(key.debugName)) {
        lista.add(key);
      }
    }

    for (final action in actions.entries) {
      if (_listsAreEqual(action.key.triggers, lista)) {
        action.value.execute(keyEvent: keyEvent, stateManager: stateManager);
        return true;
      }
    }
    return false;
  }

  bool _listsAreEqual(Iterable<LogicalKeyboardKey>? list1,
      Iterable<LogicalKeyboardKey>? list2) {
    if (list1 == null || list2 == null || list1.length != list2.length) {
      return false;
    }

    for (int i = 0; i < list1.length; i++) {
      if (list1.elementAt(i) != list2.elementAt(i)) {
        return false;
      }
    }
    return true;
  }

  bool notHasModifiers(String? debugName) {
    return debugName != LogicalKeyboardKey.numLock.debugName;
  }

  static final Map<ShortcutActivator, PlutoGridShortcutAction> defaultActions =
      {
    // Move cell focus
    LogicalKeySet(LogicalKeyboardKey.arrowLeft):
        const PlutoGridActionMoveCellFocus(PlutoMoveDirection.left),
    LogicalKeySet(LogicalKeyboardKey.arrowRight):
        const PlutoGridActionMoveCellFocus(PlutoMoveDirection.right),
    LogicalKeySet(LogicalKeyboardKey.arrowUp):
        const PlutoGridActionMoveCellFocus(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.arrowDown):
        const PlutoGridActionMoveCellFocus(PlutoMoveDirection.down),
    // Move selected cell focus
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.arrowLeft):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.left),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.arrowRight):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.right),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.arrowUp):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.arrowDown):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.down),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.arrowLeft):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.left),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.arrowRight):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.right),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.arrowUp):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.arrowDown):
        const PlutoGridActionMoveSelectedCellFocus(PlutoMoveDirection.down),
    // Move cell focus by page vertically
    LogicalKeySet(LogicalKeyboardKey.pageUp):
        const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.pageDown):
        const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.down),
    // Move cell focus by page vertically
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.pageUp):
        const PlutoGridActionMoveSelectedCellFocusByPage(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.pageDown):
        const PlutoGridActionMoveSelectedCellFocusByPage(
            PlutoMoveDirection.down),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.pageUp):
        const PlutoGridActionMoveSelectedCellFocusByPage(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.pageDown):
        const PlutoGridActionMoveSelectedCellFocusByPage(
            PlutoMoveDirection.down),
    // Move page when pagination is enabled
    LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.pageUp):
        const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.left),
    LogicalKeySet(LogicalKeyboardKey.alt, LogicalKeyboardKey.pageDown):
        const PlutoGridActionMoveCellFocusByPage(PlutoMoveDirection.right),
    // Default tab key action
    LogicalKeySet(LogicalKeyboardKey.tab): const PlutoGridActionDefaultTab(),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.tab):
        const PlutoGridActionDefaultTab(),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.tab):
        const PlutoGridActionDefaultTab(),
    // Default enter key action
    LogicalKeySet(LogicalKeyboardKey.enter):
        const PlutoGridActionDefaultEnterKey(),
    LogicalKeySet(LogicalKeyboardKey.numpadEnter):
        const PlutoGridActionDefaultEnterKey(),
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.enter):
        const PlutoGridActionDefaultEnterKey(),
    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.enter):
        const PlutoGridActionDefaultEnterKey(),
    // Default escape key action
    LogicalKeySet(LogicalKeyboardKey.escape):
        const PlutoGridActionDefaultEscapeKey(),
    // Move cell focus to edge
    LogicalKeySet(LogicalKeyboardKey.home):
        const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.left),
    LogicalKeySet(LogicalKeyboardKey.end):
        const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.right),
    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.home):
        const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.end):
        const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.down),
    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.home):
        const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.end):
        const PlutoGridActionMoveCellFocusToEdge(PlutoMoveDirection.down),
    // Move selected cell focus to edge
    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.left),

    LogicalKeySet(LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.right),

    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.left),

    LogicalKeySet(LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.right),

    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),

    LogicalKeySet(LogicalKeyboardKey.controlRight,
            LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.right),

    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftRight,
            LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),

    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.right),

    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.controlRight,
            LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftRight,
            LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),
    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.home):
        const PlutoGridActionMoveSelectedCellFocusToEdge(PlutoMoveDirection.up),

    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.down),

    LogicalKeySet(LogicalKeyboardKey.controlRight,
            LogicalKeyboardKey.shiftRight, LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.down),

    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.shiftRight,
            LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.down),

    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.shiftLeft,
            LogicalKeyboardKey.end):
        const PlutoGridActionMoveSelectedCellFocusToEdge(
            PlutoMoveDirection.down),

    // Set editing
    LogicalKeySet(LogicalKeyboardKey.f2): const PlutoGridActionSetEditing(),
    // Focus to column filter
    LogicalKeySet(LogicalKeyboardKey.f3):
        const PlutoGridActionFocusToColumnFilter(),
    // Toggle column sort
    LogicalKeySet(LogicalKeyboardKey.f4):
        const PlutoGridActionToggleColumnSort(),
    // Copy the values of cells
    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyC):
        const PlutoGridActionCopyValues(),
    // Paste values from clipboard
    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyV):
        const PlutoGridActionPasteValues(),
    // Select all cells or rows
    LogicalKeySet(LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyA):
        const PlutoGridActionSelectAll(),
    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.keyC):
        const PlutoGridActionCopyValues(),
    // Paste values from clipboard
    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.keyV):
        const PlutoGridActionPasteValues(),
    // Select all cells or rows
    LogicalKeySet(LogicalKeyboardKey.controlRight, LogicalKeyboardKey.keyA):
        const PlutoGridActionSelectAll(),
  };
}
