import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({super.key, required this.items, this.selectedValue, this.onChanged, this.backgroundColor = Colors.white});

  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?>? onChanged;
  final Color backgroundColor;

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  String? selectedValue;
  final dropdownKey = GlobalKey<DropdownButton2State>();
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        key: dropdownKey,
        customButton: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          elevation: 2,
          child: InkWell(
            onTap: () {
              dropdownKey.currentState?.callTap();
            },
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Text(
                      selectedValue ?? widget.items.first,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
        isExpanded: true,
        items: widget.items
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Text(
                    item,
                    style: GoogleFonts.poppins(
                      fontSize: 21,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
            .toList(),
        dropdownSearchData: DropdownSearchData(
          searchController: searchController,
          searchInnerWidgetHeight: 50,
          searchInnerWidget: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            height: 78,
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              expands: true,
              maxLines: null,
              controller: searchController,
              style: GoogleFonts.jost(
                fontSize: 18,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                hintText: 'Search for an item...',
                hintStyle: GoogleFonts.jost(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          searchMatchFn: (item, searchValue) {
            return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
          },
        ),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Colors.redAccent,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Colors.yellow,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 500,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.white
          ),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 70,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
