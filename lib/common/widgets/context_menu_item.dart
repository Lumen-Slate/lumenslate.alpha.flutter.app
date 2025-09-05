import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final class CustomContextMenuItem extends ContextMenuItem<String> {
  final String label;
  final String? subtitle;
  final IconData? icon;

  const CustomContextMenuItem({required this.label, super.value, super.onSelected, this.subtitle, this.icon});

  const CustomContextMenuItem.submenu({required this.label, required super.items, this.subtitle, this.icon})
    : super.submenu();

  @override
  bool get autoHandleFocus => false;

  @override
  Widget builder(BuildContext context, ContextMenuState menuState, [FocusNode? focusNode]) {
    return ListTile(
      focusNode: focusNode,
      title: SizedBox(
        width: double.maxFinite,
        child: Text(label, style: GoogleFonts.poppins()),
      ),
      subtitle: subtitle != null ? Text(subtitle!, style: GoogleFonts.poppins()) : null,
      onTap: () => handleItemSelection(context),
      trailing: Icon(isSubmenuItem ? Icons.arrow_right : null),
      leading: Icon(icon),
      dense: false,
      selected: menuState.isOpened(this),
      selectedColor: Colors.white,
      selectedTileColor: Colors.white,
    );
  }

  @override
  String get debugLabel => "[${hashCode.toString().substring(0, 5)}] $label";
}
