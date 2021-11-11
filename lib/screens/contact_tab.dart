import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactTab extends StatefulHookWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  @override
  Widget build(BuildContext context) {
    final _phoneNumberController = TextEditingController();
    final _selectedDialogCountry = useState(CountryPickerUtils.getCountryByPhoneCode('91'));

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
                    searchInputDecoration: const InputDecoration(hintText: 'Search...'),
                    isSearchable: true,
                    title: const Text('Select your phone code'),
                    onValuePicked: (Country country) => _selectedDialogCountry.value = country,
                    itemBuilder: _buildDialogItem,
                    priorityList: [
                      CountryPickerUtils.getCountryByIsoCode('IN'),
                      CountryPickerUtils.getCountryByIsoCode('US'),
                    ],
                  ),
                ),
              ),
              title: _buildDialogItem(_selectedDialogCountry.value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: "Enter phone number",
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () =>
                    launch("https://wa.me/+${_selectedDialogCountry.value.phoneCode}${_phoneNumberController.text}"),
                child: const Text("Open in Whatsapp"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogItem(Country _selectedDialogCountry) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 8.0),
        CountryPickerUtils.getDefaultFlagImage(_selectedDialogCountry),
        const SizedBox(width: 8.0),
        Text("+${_selectedDialogCountry.phoneCode}"),
        const SizedBox(width: 8.0),
        Flexible(child: Text(_selectedDialogCountry.name))
      ],
    );
  }
}
