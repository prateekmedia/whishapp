import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

class ContactTab extends StatefulHookWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  @override
  Widget build(BuildContext context) {
    final phoneNumberController = TextEditingController();
    final messageController = TextEditingController();
    final selectedDialogCountry =
        useState(CountryPickerUtils.getCountryByPhoneCode('91'));

    void launchWhatsapp() {
      launchUrlString(WhatsAppUnilink(
        phoneNumber:
            selectedDialogCountry.value.phoneCode + phoneNumberController.text,
        text: messageController.text,
      ).toString());
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Contact unsaved number"),
            ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => Theme(
                  data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                  child: CountryPickerDialog(
                    titlePadding: const EdgeInsets.all(8.0),
                    searchCursorColor: Colors.pinkAccent,
                    searchInputDecoration:
                        const InputDecoration(hintText: 'Search...'),
                    isSearchable: true,
                    title: const Text('Select your phone code'),
                    onValuePicked: (Country country) =>
                        selectedDialogCountry.value = country,
                    itemBuilder: _buildDialogItem,
                    priorityList: [
                      CountryPickerUtils.getCountryByIsoCode('IN'),
                      CountryPickerUtils.getCountryByIsoCode('US'),
                    ],
                  ),
                ),
              ),
              title: _buildDialogItem(selectedDialogCountry.value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  TextField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => launchWhatsapp(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(hintText: "Phone number"),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: messageController,
                    maxLines: null,
                    decoration:
                        const InputDecoration(hintText: "Message (optional)"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: launchWhatsapp,
                child: const Text("Open in Whatsapp"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogItem(Country selectedDialogCountry) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 8.0),
        CountryPickerUtils.getDefaultFlagImage(selectedDialogCountry),
        const SizedBox(width: 8.0),
        Text("+${selectedDialogCountry.phoneCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(selectedDialogCountry.name))
      ],
    );
  }
}
