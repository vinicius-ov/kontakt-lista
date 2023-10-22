import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kontaktlista/add_contact_alert.dart';
import 'package:kontaktlista/edit_contact.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/repositories/contact_repository.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> _contacts = List.empty(growable: true);
  final ContactRepository _contactRepository = ContactRepository();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    debugPrint('fetching contacts...');
    _contacts = await _contactRepository.fetch();
    setState(() {});
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
                _loadData();
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.refresh))),
          GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditContactPage(
                            title: 'Novo contato',
                            isNewContact: true,
                            contactRepository: ContactRepository())));
              },
              child: Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.add))),
        ],
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Expanded(
                child: _contacts.isEmpty
                    ? const Text(
                        'Lista de contatos vazia. Toque no + acima para inserir.')
                    : Scrollbar(
                        child: ListView.builder(
                        itemCount: _contacts.length,
                        itemBuilder: (BuildContext bc, int index) {
                          Contact contact = _contacts[index];
                          return GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditContactPage(
                                            title: 'Novo contato',
                                            contact: contact,
                                            isNewContact: false,
                                            contactRepository:
                                                ContactRepository())));
                              },
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const SizedBox(height: 100),
                                      CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              // if contact has image setup else use below
                                              //Image.file(File(tempAvatarFile?.path ?? '')).image,
                                              Image.network(
                                                      'https://gerarmemes.s3.us-east-2.amazonaws.com/memes/66178707.webp')
                                                  .image),
                                      Text(
                                          'Nome: ${contact.getName} ${contact.getSurname}'),
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('Phone: ${contact.getPhone}'),
                                      Text('Photo: ${contact.getPhoto}'),
                                    ]),
                                const Divider(
                                  thickness: 3.0,
                                )
                              ]));
                        },
                      )))
          ])),
    );
  }
}
