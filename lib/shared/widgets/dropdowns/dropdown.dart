import 'package:flutter/material.dart';

class SharedDropdownWidget<T> extends StatelessWidget {
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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              label!,
              style: TextStyle(
                color: isSuccess
                    ? Colors.green
                    : isError
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ),
        Row(
          children: [
            if (showLeftIcon && leftIcon != null)
              Icon(
                leftIcon,
                color: isSuccess
                    ? Colors.green
                    : isError
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
                    color: isSuccess
                        ? Colors.green
                        : isError
                            ? Colors.red
                            : Colors.black,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<T>(
                    value: value,
                    isExpanded: true,
                    icon: showRightIcon && rightIcon != null
                        ? Icon(
                            rightIcon,
                            color: isSuccess
                                ? Colors.green
                                : isError
                                    ? Colors.red
                                    : Colors.black,
                          )
                        : null,
                    items: items.map<DropdownMenuItem<T>>((T item) {
                      return DropdownMenuItem<T>(
                        value: item,
                        child: Text(
                          item.toString().split('.').last,
                          style: const TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: label,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (isError && errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (isSuccess && successMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              successMessage!,
              style: const TextStyle(color: Colors.green),
            ),
          ),
      ],
    );
  }
}
