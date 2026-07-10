import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:country_picker/country_picker.dart';

void showCustomCountryPicker({
  required BuildContext context,
  required ValueChanged<Country> onSelect,
}) {
  final service = CountryService();
  List<Country> countries = service.getAll();
  final ids = <String>{};
  countries.retainWhere((c) => ids.add(c.countryCode));

  final searchController = TextEditingController();
  ValueNotifier<List<Country>> filteredNotifier =
      ValueNotifier<List<Country>>(List.from(countries));

  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: searchController,
                  onChanged: (query) {
                    if (query.isEmpty) {
                      filteredNotifier.value = List.from(countries);
                    } else {
                      final q = query.toLowerCase();
                      filteredNotifier.value = countries.where((c) {
                        return c.name.toLowerCase().contains(q) ||
                            c.countryCode.toLowerCase().contains(q) ||
                            c.phoneCode.startsWith(q.replaceAll('+', ''));
                      }).toList();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'search_country'.tr(),
                    prefixIcon: const Icon(Icons.search, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ValueListenableBuilder<List<Country>>(
                  valueListenable: filteredNotifier,
                  builder: (context, list, _) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: list.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, indent: 56, endIndent: 16),
                      itemBuilder: (context, index) {
                        final country = list[index];
                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              onSelect(country);
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: Row(
                                children: [
                                  Text(country.flagEmoji,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      country.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+${country.phoneCode}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF94A3B8),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  ).whenComplete(() => searchController.dispose());
}
