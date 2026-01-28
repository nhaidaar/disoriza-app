import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import 'colors.dart';
import 'fontstyles.dart';

class CustomDropdown<K, V> extends StatefulWidget {
  final List<MapEntry<K, V>> items;
  final MapEntry<K, V> initialValue;
  final Function(MapEntry<K, V>) onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<CustomDropdown<K, V>> createState() => _CustomDropdownState<K, V>();
}

class _CustomDropdownState<K, V> extends State<CustomDropdown<K, V>> {
  late MapEntry<K, V> selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MapEntry<K, V>>(
      initialValue: selectedValue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: context.neutral30),
      ),
      elevation: 0,
      position: PopupMenuPosition.under,
      color: context.backgroundComponent,

      // Handle selection change
      onSelected: (value) {
        setState(() => selectedValue = value);
        widget.onChanged(value);
      },

      itemBuilder: (context) {
        return widget.items.map((item) {
          return PopupMenuItem<MapEntry<K, V>>(
            value: item,
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.key.toString(),
                  style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
                ),
                if (selectedValue == item) const Icon(Icons.check, size: 20),
              ],
            ),
          );
        }).toList();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Text(
              selectedValue.key.toString(),
              style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
            ),
            const SizedBox(width: 4),
            const Icon(IconsaxPlusLinear.arrow_down, size: 20),
          ],
        ),
      ),
    );
  }
}
