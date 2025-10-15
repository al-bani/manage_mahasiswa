import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

class DropdownForm<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemBuilder;
  final String? hint;
  final String? label;
  final void Function(T?)? onChanged;
  final bool enabled;
  final bool isLoading;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double? fontSize;

  const DropdownForm({
    super.key,
    this.value,
    required this.items,
    required this.itemBuilder,
    this.hint,
    this.label,
    this.onChanged,
    this.enabled = true,
    this.isLoading = false,
    this.suffixIcon,
    this.contentPadding,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTextStyles.openSansBold(fontSize: fontSize ?? 12),
          ),
          const SizedBox(height: 4),
        ],
        if (isLoading)
          _buildLoadingWidget()
        else
          DropdownButtonFormField<T>(
            decoration: _buildDecoration(),
            value: value,
            hint: hint != null
                ? Text(
                    hint!,
                    style:
                        AppTextStyles.openSansItalic(fontSize: fontSize ?? 12),
                  )
                : null,
            items: items.map((item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemBuilder(item),
                  style: AppTextStyles.openSansBold(fontSize: fontSize ?? 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              );
            }).toList(),
            onChanged: enabled ? onChanged : null,
          ),
      ],
    );
  }

  InputDecoration _buildDecoration() {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2.0,
        ),
      ),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
      suffixIcon: suffixIcon,
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

// Specialized dropdown for Map<String, dynamic> items
class DropdownMap extends StatelessWidget {
  final String? value;
  final List<Map<String, dynamic>> items;
  final String valueKey;
  final String displayKey;
  final String? hint;
  final String? label;
  final void Function(String?)? onChanged;
  final bool enabled;
  final bool isLoading;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final double? fontSize;

  const DropdownMap({
    super.key,
    this.value,
    required this.items,
    this.valueKey = 'code',
    this.displayKey = 'name',
    this.hint,
    this.label,
    this.onChanged,
    this.enabled = true,
    this.isLoading = false,
    this.suffixIcon,
    this.contentPadding,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownForm<String>(
      value: value,
      items: items.map((item) => item[valueKey] as String).toList(),
      itemBuilder: (code) {
        final item = items.firstWhere(
          (item) => item[valueKey] == code,
          orElse: () => {displayKey: ''},
        );
        return item[displayKey] as String;
      },
      hint: hint,
      label: label,
      onChanged: onChanged,
      enabled: enabled,
      isLoading: isLoading,
      suffixIcon: suffixIcon,
      contentPadding: contentPadding,
      fontSize: fontSize,
    );
  }
}
