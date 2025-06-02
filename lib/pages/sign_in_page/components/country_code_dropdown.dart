import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CountryCodeDropdown extends StatelessWidget {
  final String selectedCountryCode;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final TextEditingController _searchController = TextEditingController();

  CountryCodeDropdown({
    super.key,
    required this.selectedCountryCode,
    required this.onChanged, required this.enabled,
  });

  final List<({String emoji, String code, String countryName})> _countryCodes = [
    (emoji: '🇮🇳', code: '+91', countryName: 'India'),
    (emoji: '🇺🇸', code: '+1', countryName: 'United States'),
    (emoji: '🇬🇧', code: '+44', countryName: 'United Kingdom'),
    (emoji: '🇦🇺', code: '+61', countryName: 'Australia'),
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
          isDense: true,
          selectedItemBuilder: (BuildContext context) {
            return _countryCodes.map<Widget>((({String emoji, String code, String countryName}) country) {
              return Container(
                alignment: Alignment.center,
                width: 80,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(country.emoji), // Display the flag
                    const SizedBox(width: 8),
                    Text(country.code), // Display country code
                  ],
                ),
              );
            }).toList();
          },
          items:
              _countryCodes.map<DropdownMenuItem<String>>((({String emoji, String code, String countryName}) country) {
            return DropdownMenuItem<String>(
              value: country.code,
              child: Row(
                children: [
                  Text(country.emoji, style: GoogleFonts.poppins(fontSize: 30)),
                  const SizedBox(width: 8),
                  Text(country.code, style: GoogleFonts.poppins(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text('(${country.countryName})', style: GoogleFonts.poppins(fontSize: 22)),
                ],
              ),
            );
          }).toList(),
          value: selectedCountryCode,
          onChanged: enabled ? onChanged : null,
          buttonStyleData: const ButtonStyleData(
            height: 50,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 400,
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all(6),
              thumbVisibility: WidgetStateProperty.all(true),
            ),
          ),
          iconStyleData: const IconStyleData(icon: Icon(null), iconSize: 0),
          menuItemStyleData: const MenuItemStyleData(
            height: 70,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: _searchController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: _searchController,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  hintText: 'Search for a country...',
                  hintStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onChanged: (searchValue) {
                },
              ),
            ),
            searchMatchFn: (item, searchValue) {
              final country = _countryCodes.where(
                (({String emoji, String code, String countryName}) country) =>
                    country.code == item.value! &&
                    country.countryName.toLowerCase().contains(searchValue.toLowerCase()),
              );
              return country.isNotEmpty;
            },
          )),
    );
  }
}
