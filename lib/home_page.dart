import 'package:flutter/material.dart';
import 'package:kontaktlista/contact_card.dart';
import 'package:kontaktlista/edit_contact.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/repositories/contact_repository.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> _contacts = List.empty(growable: true);
  final ContactRepository _contactRepository = ContactRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    setState(() {
      _isLoading = true;
    });
    debugPrint('fetching contacts...');
    _contacts = await _contactRepository.fetch();
    setState(() {
      _isLoading = false;
    });
    debugPrint('fetching ok...');
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
                                contactRepository: ContactRepository())))
                    .then((value) => _loadData());
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
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
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
                                                builder: (context) =>
                                                    EditContactPage(
                                                        title: 'Editar contato',
                                                        contact: contact,
                                                        isNewContact: false,
                                                        contactRepository:
                                                            ContactRepository())))
                                        .then((value) => _loadData());
                                  },
                                  child: ContactCard(contact: contact));
                            },
                          )))
          ])),
    );
  }
}
