import 'package:flutter/material.dart';
import '../tokens/spacing.dart';

class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const BaseCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(Spacing.m),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Spacing.borderRadius),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
