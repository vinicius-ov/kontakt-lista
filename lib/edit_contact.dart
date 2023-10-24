import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/repositories/contact_repository.dart';
import 'package:kontaktlista/service/base64_service.dart';
import 'package:kontaktlista/service/image_service.dart';

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
  //String _imagePath = '';
  String _imageEncoded = '';

  late Contact _contact;
  late ContactRepository _contactRepository;
  bool _isNewContact = false;
  bool _isSaving = false;

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
    _imageEncoded = _contact.getPhoto;

    _isNewContact = widget.isNewContact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: _isNewContact
              ? []
              : [
                  GestureDetector(
                      onTap: () async {
                        if (!_isSaving) {
                          setState(() {
                            _isSaving = true;
                          });
                          bool success =
                              await _contactRepository.delete(_contact);
                          if (success) {
                            nameInputController.text = '';
                            surnameInputController.text = '';
                            phoneInputController.text = '';
                            _contact = Contact.empty();

                            await _showDialog('Contato apagado com sucesso.');

                            await Future.delayed(const Duration(seconds: 1));
                            if (!context.mounted) return;
                            setState(() {
                              _isSaving = false;
                            });
                            Navigator.of(context).pop();
                          } else {
                            _showDialog('Erro. Contato não foi apagado.');
                            setState(() {
                              _isSaving = false;
                            });
                          }
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
                            final ImagePicker picker = ImagePicker();
                            XFile? tempAvatarFile = await picker.pickImage(
                                source: ImageSource.camera);
                            CroppedFile? cropped = await ImageCropper()
                                .cropImage(
                                    sourcePath: tempAvatarFile!.path,
                                    aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio4x3,
                                  CropAspectRatioPreset.ratio3x2
                                ]);

                            if (cropped != null) {
                              setState(() {
                                String imagePath = cropped.path;
                                _imageEncoded =
                                    Base64Service.imagePathToBase64String(
                                        imagePath);
                              });
                            }
                          },
                          child: Column(children: [
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: Image.memory(
                                        ImageService.imageFromBase64String(
                                            _imageEncoded))
                                    .image),
                            const Text(
                                'Toque na imagem para escolher uma foto.'),
                          ])),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: nameInputController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          icon: Icon(Icons.person),
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        controller: surnameInputController,
                        decoration: const InputDecoration(
                          labelText: 'Sobrenome',
                          icon: Icon(Icons.person),
                        ),
                      ),
                      TextFormField(
                        controller: phoneInputController,
                        keyboardType: TextInputType.number,
                        //inputFormatters: [TelefoneInputFormatter()],
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
                            if (!_isSaving) {
                              debugPrint('will save...');
                              _contact.setName(nameInputController.text);
                              _contact.setSurname(surnameInputController.text);
                              _contact.setPhone(phoneInputController.text);
                              _contact.setPhoto(_imageEncoded);

                              setState(() {
                                _isSaving = true;
                              });

                              if (_contact.getName.isNotEmpty &&
                                  _contact.getSurname.isNotEmpty &&
                                  _contact.getPhone.isNotEmpty) {
                                bool success = _isNewContact
                                    ? await _contactRepository.insert(_contact)
                                    : await _contactRepository.update(_contact);
                                if (success) {
                                  await _showDialog(
                                      'Contato criado com sucesso.');
                                  await Future.delayed(
                                      const Duration(seconds: 1));
                                  if (!context.mounted) return;
                                  setState(() {
                                    _isSaving = false;
                                  });
                                  Navigator.of(context).pop();
                                } else {
                                  _showDialog(
                                      'Erro ao criar contato. Não foi possível adicionar ao banco de dados.');
                                  setState(() {
                                    _isSaving = false;
                                  });
                                }
                              } else {
                                _showDialog(
                                    'Contato não criado. Verifique os campos.');
                                setState(() {
                                  _isSaving = false;
                                });
                              }
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: _isSaving
                              ? const CircularProgressIndicator()
                              : const SizedBox(
                                  width: 100,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'Salvar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )
                                      ])))
                    ])))));
  }

  Future _showDialog(String message, {String title = 'Alerta'}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            // define os botões na base do dialogo
            TextButton(
              child: const Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
