import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/repositories/contact_repository.dart';

class EditContactPage extends StatefulWidget {
  const EditContactPage(
      {super.key,
      required this.title,
      this.contact,
      required this.contactRepository,
      required this.isNewContact});
  final String title;
  final Contact? contact;
  final ContactRepository contactRepository;
  final bool isNewContact;

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  var nameInputController = TextEditingController(text: '');
  var surnameInputController = TextEditingController(text: '');
  var phoneInputController = TextEditingController(text: '');
  XFile? tempAvatarFile;

  late Contact _contact;
  late ContactRepository _contactRepository;
  bool _isNewContact = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _contact = Contact.empty();
    } else {
      _contact = widget.contact!;
    }
    _contactRepository = widget.contactRepository;
    nameInputController.text = _contact.getName;
    surnameInputController.text = _contact.getSurname;
    phoneInputController.text = _contact.getPhone;
    _isNewContact = widget.isNewContact;
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
                  bool success = await _contactRepository.delete(_contact);
                  if (success) {
                    nameInputController.text = '';
                    surnameInputController.text = '';
                    phoneInputController.text = '';
                    _contact = Contact.empty();
                    setState(() {});
                  }
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete))),
          ],
        ),
        body: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height),
                    child: Column(children: [
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                          onTap: () async {
                            final ImagePicker _picker = ImagePicker();
                            tempAvatarFile = await _picker.pickImage(
                                source: ImageSource.camera);
                            if (tempAvatarFile != null) {
                              debugPrint('image is ${tempAvatarFile?.path}');
                            }
                          },
                          child: Column(children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    // if contact has image setup else use below
                                    //Image.file(File(tempAvatarFile?.path ?? '')).image,
                                    Image.network(
                                            'https://gerarmemes.s3.us-east-2.amazonaws.com/memes/66178707.webp')
                                        .image),
                            const Text(
                                'Toque na imagem para escolher uma foto.'),
                          ])),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: nameInputController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          icon: Icon(Icons.person),
                        ),
                      ),
                      TextFormField(
                        controller: surnameInputController,
                        decoration: const InputDecoration(
                          labelText: 'Sobrenome',
                          icon: Icon(Icons.person),
                        ),
                      ),
                      TextFormField(
                        controller: phoneInputController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [TelefoneInputFormatter()],
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          icon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () async {
                            debugPrint('will save...');
                            _contact.setName(nameInputController.text);
                            _contact.setSurname(surnameInputController.text);
                            _contact.setPhone(phoneInputController.text);
                            //if insert else update
                            bool success = _isNewContact
                                ? await _contactRepository.insert(_contact)
                                : await _contactRepository.update(_contact);
                            if (success) {
                              setState(() {});
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: const SizedBox(
                              width: 100,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Salvar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ])))
                    ])))));
  }
}
