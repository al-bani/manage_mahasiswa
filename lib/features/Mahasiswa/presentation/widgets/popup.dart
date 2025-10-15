import 'package:flutter/material.dart';
import 'package:manage_mahasiswa/features/Auth/presentation/widgets/components.dart';

class PopupWidget {
  /// Popup dengan button OK saja
  static void showOkOnly({
    required BuildContext context,
    required String title,
    required String message,
    String okText = 'OK',
    VoidCallback? onOkPressed,
    Color? backgroundColor,
    Color? okButtonColor,
    Color? okTextColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon atau emoji
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.primary,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // OK Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onOkPressed?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: okButtonColor ?? Colors.blue,
                      foregroundColor: okTextColor ?? Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      okText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Popup dengan button OK dan Cancel
  static void showOkCancel({
    required BuildContext context,
    required String title,
    required String message,
    String okText = 'OK',
    String cancelText = 'Cancel',
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? okButtonColor,
    Color? cancelButtonColor,
    Color? okTextColor,
    Color? cancelTextColor,
    bool isDestructive = false, // Untuk konfirmasi delete dll
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon berdasarkan tipe popup
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDestructive
                        ? Colors.red.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDestructive ? Icons.warning_outlined : Icons.help_outline,
                    color: isDestructive ? Colors.red : Colors.orange,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: titleColor ?? Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Message
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: messageColor ?? Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Button Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onCancelPressed?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: cancelTextColor ?? Colors.grey[600],
                          side: BorderSide(
                            color: cancelButtonColor ?? Colors.grey[300]!,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // OK Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          onOkPressed?.call();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDestructive
                              ? Colors.red
                              : (okButtonColor ?? Colors.blue),
                          foregroundColor: okTextColor ?? Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          okText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Popup Loading
  static void showLoading({
    required BuildContext context,
    String message = 'Loading...',
    Color? backgroundColor,
    Color? messageColor,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 14,
                    color: messageColor ?? Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Close popup
  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }
}

/// Extension untuk memudahkan penggunaan
extension PopupExtension on BuildContext {
  void showOkPopup({
    required String title,
    required String message,
    String okText = 'OK',
    VoidCallback? onOkPressed,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? okButtonColor,
    Color? okTextColor,
  }) {
    PopupWidget.showOkOnly(
      context: this,
      title: title,
      message: message,
      okText: okText,
      onOkPressed: onOkPressed,
      backgroundColor: backgroundColor,
      okButtonColor: okButtonColor,
      okTextColor: okTextColor,
    );
  }

  void showOkCancelPopup({
    required String title,
    required String message,
    String okText = 'OK',
    String cancelText = 'Cancel',
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
    Color? backgroundColor,
    Color? titleColor,
    Color? messageColor,
    Color? okButtonColor,
    Color? cancelButtonColor,
    Color? okTextColor,
    Color? cancelTextColor,
    bool isDestructive = false,
  }) {
    PopupWidget.showOkCancel(
      context: this,
      title: title,
      message: message,
      okText: okText,
      cancelText: cancelText,
      onOkPressed: onOkPressed,
      onCancelPressed: onCancelPressed,
      backgroundColor: backgroundColor,
      titleColor: titleColor,
      messageColor: messageColor,
      okButtonColor: okButtonColor,
      cancelButtonColor: cancelButtonColor,
      okTextColor: okTextColor,
      cancelTextColor: cancelTextColor,
      isDestructive: isDestructive,
    );
  }

  void showLoadingPopup({
    String message = 'Loading...',
    Color? backgroundColor,
    Color? messageColor,
  }) {
    PopupWidget.showLoading(
      context: this,
      message: message,
      backgroundColor: backgroundColor,
      messageColor: messageColor,
    );
  }

  void closePopup() {
    PopupWidget.close(this);
  }
}
