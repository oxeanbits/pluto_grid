import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../helper/column_helper.dart';
import '../../helper/row_helper.dart';

void main() {
  late PlutoGridStateManager stateManager;
  late List<PlutoColumn> columns;

  Future<void> pumpGrid(WidgetTester tester, {required bool frozen}) async {
    columns = ColumnHelper.textColumn('header', count: 3);
    if (frozen) columns.first.frozen = PlutoColumnFrozen.start;

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: SizedBox(
            width: 800,
            height: 600,
            child: PlutoGrid(
              columns: columns,
              rows: RowHelper.count(5, columns),
              onLoaded: (event) => stateManager = event.stateManager,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Map<String, Element> mountedRows(WidgetTester tester, String keyPrefix) {
    final finder = find.byWidgetPredicate((widget) {
      final key = widget.key;
      return key is ValueKey<String> && key.value.startsWith(keyPrefix);
    });

    return {
      for (final element in tester.elementList(finder))
        (element.widget.key as ValueKey<String>).value: element,
    };
  }

  Future<List<String>> insertRowAndListRecreated(
    WidgetTester tester,
    String keyPrefix,
  ) async {
    final before = mountedRows(tester, keyPrefix);

    stateManager.insertRows(1, RowHelper.count(1, columns, start: 100));
    await tester.pumpAndSettle();

    final after = mountedRows(tester, keyPrefix);

    return before.keys
        .where((key) => !identical(before[key], after[key]))
        .toList();
  }

  group('PlutoGrid', () {
    group('when a row is inserted in the middle of the list', () {
      testWidgets('keeps the body rows below it mounted', (tester) async {
        await pumpGrid(tester, frozen: false);

        final recreated = await insertRowAndListRecreated(tester, 'body_row_');

        expect(recreated, isEmpty);
      });

      testWidgets('keeps the left frozen rows below it mounted', (
        tester,
      ) async {
        await pumpGrid(tester, frozen: true);

        final recreated = await insertRowAndListRecreated(
          tester,
          'left_frozen_row_',
        );

        expect(recreated, isEmpty);
      });
    });
  });
}
