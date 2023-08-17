import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
  Widget buildSearchList(
    List<String> items,
    String value,
    String hint,
    ValueChanged<String> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          decoration: InputDecoration(
            labelText: hint,
          ),
          controller: TextEditingController(text: value),
        ),
        suggestionsCallback: (pattern) {
          return items
              .where((item) => item.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, String itemData) {
          return ListTile(
            title: Text(itemData),
          );
        },
        onSuggestionSelected: (String? selectedItem) {
          onChanged(selectedItem!);
        },
      ),
    );
  }


Widget buildTextField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
    ),
  );
}
