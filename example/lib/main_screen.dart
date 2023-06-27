import 'package:flutter/material.dart';
import 'package:jumpers/jumpers.dart';

import 'constants/colors.dart';
import 'layouts/detailed_layout.dart';
import 'layouts/main_layout.dart';
import 'models/color_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<ColorItem> _items;
  late final List<ColorItem> _initialItems;

  ColorItem? _pickedItem;
  int _columnsCount = 2;

  void _pickItem(ColorItem item) {
    setState(() {
      _pickedItem = item;
    });
  }

  void _resetSelection() {
    setState(() {
      _pickedItem = null;
    });
  }

  @override
  void initState() {
    _initialItems = List.generate(
      colorItems.length,
      (i) => ColorItem(colorItems[i], i + 1),
    );
    _items = [..._initialItems];
    super.initState();
  }

  void _deleteItem(ColorItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  void _resetItems() {
    setState(() {
      _items = [..._initialItems];
    });
  }

  void _setColumnsCount(int count) {
    setState(() {
      _columnsCount = count;
    });
  }

  void _decreaseColums() {
    if (_columnsCount < 2) return;
    _setColumnsCount(_columnsCount - 1);
  }

  void _increaseColums() {
    if (_columnsCount > 4) return;
    _setColumnsCount(_columnsCount + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jumpers'),
        actions: [
          IconButton(
            onPressed: _resetItems,
            icon: const Icon(Icons.restart_alt),
          ),
          IconButton(
            onPressed: _decreaseColums,
            icon: const Icon(Icons.remove),
          ),
          IconButton(
            onPressed: _increaseColums,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: JumpersScope(
        // duration: Duration(seconds: 4),
        triggerObjects: [_pickedItem, _items.length, _columnsCount],
        child: _pickedItem != null
            ? DetailedLayout(
                colorItems: _items,
                pickedItem: _pickedItem!,
                pickCallback: _pickItem,
                resetPickCallback: _resetSelection,
              )
            : MainLayout(
                items: _items,
                pickCallback: _pickItem,
                deleteCallback: _deleteItem,
                columnsCount: _columnsCount,
              ),
      ),
    );
  }
}
