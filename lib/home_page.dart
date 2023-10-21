import 'package:flutter/material.dart';
import 'package:kontaktlista/add_contact_alert.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Contact> _contacts = List.empty(growable: true);

  void _loadData() async {
    debugPrint('fetching addresses...');
    //_history = await _addressRepository.fetchRemote();
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
              onTap: () {
                debugPrint('show alert...');
                AddContactAlert.getAlert(context).show;
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
                    ? Column(children: [
                        const Text(
                            'Lista de contatos vazia. Toque no + acima para inserir.'),
                        ElevatedButton(
                            child: Text('Basic Waiting Alert'),
                            onPressed: () => showShow()),
                      ])
                    : Scrollbar(
                        child: ListView.builder(
                        itemCount: _contacts.length,
                        itemBuilder: (BuildContext bc, int index) {
                          Contact contact = _contacts[index];
                          return Column(children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('CEP: {contact.getZipCode}'),
                                  Text('Logradouro: {contact.getDistrict}'),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('Bairro: {contact.getDistrict}'),
                                  Text('Cidade: {contact.getCity}'),
                                ]),
                            const Divider(
                              thickness: 3.0,
                            ),
                            ElevatedButton(
                                child: Text('Basic Waiting Alert'),
                                onPressed: () =>
                                    AddContactAlert.getAlert(context).show),
                          ]);
                        },
                      )))
          ])),
    );
  }

  void showShow() {
    Alert(
      context: context,
      type: AlertType.info,
      title: "RFLUTTER ALERT",
      desc: "Flutter is more awesome with RFlutter Alert.",
      buttons: [
        DialogButton(
          child: Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(0.0),
        ),
      ],
    ).show();
  }
}
