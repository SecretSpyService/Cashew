import 'package:budget/functions.dart';
import 'package:budget/widgets/tappable.dart';
import 'package:budget/widgets/textWidgets.dart';
import 'package:flutter/material.dart';

class RadioItems<T> extends StatefulWidget {
  final T initial;
  final List<T> items;
  final List<String>? descriptions;
  final Function(T item) onChanged;
  final String Function(T item)? displayFilter;
  final Color? Function(T item)? colorFilter;
  final Function(T item)? onLongPress;
  final bool ifNullSelectNone;

  const RadioItems({
    Key? key,
    required this.initial,
    required this.items,
    this.descriptions,
    required this.onChanged,
    this.onLongPress,
    this.displayFilter,
    this.colorFilter,
    this.ifNullSelectNone = false,
  }) : super(key: key);

  @override
  State<RadioItems<T>> createState() => _RadioItemsState<T>();
}

class _RadioItemsState<T> extends State<RadioItems<T>> {
  T? currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    int index = -1;
    for (T item in widget.items) {
      index += 1;
      bool selected = false;
      if (currentValue == item) selected = true;
      if (item == null && widget.ifNullSelectNone == true) selected = false;
      bool hasDescription = widget.descriptions == null ||
          widget.descriptions!.length <= index ||
          widget.descriptions![index] == "";
      children.add(
        AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          child: Tappable(
            key: ValueKey((currentValue == item).toString()),
            onLongPress: widget.onLongPress != null
                ? () => widget.onLongPress!(item)
                : null,
            borderRadius: getPlatform() == PlatformOS.isIOS ? 10 : 20,
            color: selected
                ? Theme.of(context).colorScheme.secondaryContainer
                : Colors.transparent,
            onTap: () {
              setState(() {
                currentValue = item;
              });
              widget.onChanged(item);
            },
            child: ListTile(
              title: Transform.translate(
                offset: Offset(-12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                      fontSize: hasDescription ? 16 : 18,
                      text: widget.displayFilter == null
                          ? item.toString()
                          : widget.displayFilter!(item),
                      maxLines: 3,
                    ),
                    hasDescription
                        ? SizedBox.shrink()
                        : TextFont(
                            fontSize: 14,
                            text: widget.descriptions![index],
                            maxLines: 3,
                          ),
                  ],
                ),
              ),
              dense: true,
              leading: Radio<String>(
                visualDensity: VisualDensity.compact,
                value: selected ? "true" : "false",
                groupValue: "true",
                onChanged: (_) {
                  setState(() {
                    currentValue = item;
                  });
                  widget.onChanged(item);
                },
                fillColor: widget.colorFilter != null &&
                        widget.colorFilter!(item) != null
                    ? MaterialStateColor.resolveWith(
                        (states) => widget.colorFilter!(item)!)
                    : null,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }
    return Column(
      children: children,
    );
  }
}
