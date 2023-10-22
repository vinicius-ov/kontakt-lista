import 'package:flutter/material.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/repositories/contact_repository.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage(
      {super.key,
      required this.title,
      required this.contact,
      required this.contactRepository});
  final String title;
  final Contact contact;
  final ContactRepository contactRepository;

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  var nameInputController = TextEditingController(text: '');
  var surnameInputController = TextEditingController(text: '');
  var phoneInputController = TextEditingController(text: '');
  var photoInputController = TextEditingController(text: '');

  late Contact _contact;
  late ContactRepository _contactRepository;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
    debugPrint('address ${_contact.toMap()}');
    _contactRepository = widget.contactRepository;
    nameInputController.text = _contact.getName;
    surnameInputController.text = _contact.getSurname;
    phoneInputController.text = _contact.getPhone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            GestureDetector(
                onTap: () async {
                  debugPrint('will edit...');
                  _contact.setName(nameInputController.text);
                  _contact.setSurname(surnameInputController.text);
                  _contact.setPhone(phoneInputController.text);
                  bool success = await _contactRepository.update(_contact);
                  if (success) {
                    setState(() {});
                  }
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.save_alt))),
          ],
        ),
        body: Column(children: [
          const Text('Editar contato'),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: nameInputController,
          ),
          TextField(
            controller: surnameInputController,
          ),
          TextField(
            controller: phoneInputController,
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () async {
                bool success = await _contactRepository.delete(_contact);
                if (success) {
                  nameInputController.text = '';
                  surnameInputController.text = '';
                  phoneInputController.text = '';
                  _contact = Contact.empty();
                  setState(() {});
                }
              },
              child: const Text('Deletar'))
        ]));
  }
}
