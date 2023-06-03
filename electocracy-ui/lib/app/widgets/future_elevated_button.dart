import 'package:flutter/material.dart';

class FutureElevatedButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final Widget child;

  const FutureElevatedButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  State<FutureElevatedButton> createState() => _FutureElevatedButtonState();
}

class _FutureElevatedButtonState extends State<FutureElevatedButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await widget.onPressed();
              } catch (e) {
                // Handle error.
                print(e);
              } finally {
                setState(() {
                  _isLoading = false;
                });
              }
            },
      child: _isLoading ? const CircularProgressIndicator() : widget.child,
    );
  }
}
