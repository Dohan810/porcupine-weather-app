import 'package:flutter/material.dart';

class SharedDropdownWidget<T> extends StatefulWidget {
  final String? label;
  final List<T> items;
  final T? value;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final String? errorMessage;
  final String? successMessage;
  final ValueChanged<T?> onChanged;
  final bool showLeftIcon;
  final bool showRightIcon;
  final bool isSuccess;
  final bool isError;
  final String Function(T)? displayValue;

  const SharedDropdownWidget({
    super.key,
    this.label,
    required this.items,
    this.value,
    this.leftIcon,
    this.rightIcon,
    this.errorMessage,
    this.successMessage,
    required this.onChanged,
    this.showLeftIcon = false,
    this.showRightIcon = false,
    this.isSuccess = false,
    this.isError = false,
    this.displayValue,
  });

  @override
  _SharedDropdownWidgetState<T> createState() =>
      _SharedDropdownWidgetState<T>();
}

class _SharedDropdownWidgetState<T> extends State<SharedDropdownWidget<T>> {
  bool _showSuccessMessage = false;

  void _handleChange(T? newValue) {
    if (newValue != widget.value) {
      widget.onChanged(newValue);
      setState(() {
        _showSuccessMessage = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showSuccessMessage = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              widget.label!,
              style: TextStyle(
                color: widget.isSuccess
                    ? Colors.green
                    : widget.isError
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ),
        Row(
          children: [
            if (widget.showLeftIcon && widget.leftIcon != null)
              Icon(
                widget.leftIcon,
                color: widget.isSuccess
                    ? Colors.green
                    : widget.isError
                        ? Colors.red
                        : Colors.black,
              ),
            Expanded(
              child: Container(
                height: 60,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isSuccess
                        ? Colors.green
                        : widget.isError
                            ? Colors.red
                            : Colors.black,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<T>(
                    value: widget.value,
                    isExpanded: true,
                    icon: widget.showRightIcon && widget.rightIcon != null
                        ? Icon(
                            widget.rightIcon,
                            color: widget.isSuccess
                                ? Colors.green
                                : widget.isError
                                    ? Colors.red
                                    : Colors.black,
                          )
                        : null,
                    items: widget.items.map<DropdownMenuItem<T>>((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          widget.displayValue != null
                              ? widget.displayValue!(item)
                              : item.toString().split('.').last,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: _handleChange,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.label,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (widget.isError && widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (_showSuccessMessage && widget.successMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.successMessage!,
              style: const TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }
}
