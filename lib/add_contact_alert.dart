import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddContactAlert {
  static Alert getAlert(BuildContext context) {
    return Alert(
        context: context,
        title: "Novo contato",
        content: const Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                labelText: 'Nome',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle_outlined),
                labelText: 'Sobrenome',
              ),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.account_circle_rounded),
                labelText: 'Telefone',
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Adicionar foto",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cadastrar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]);
  }

  static Future show2(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Novo contato'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    IconButton(
                        onPressed: () async {
                          debugPrint('asdasd');
                          final ImagePicker _picker = ImagePicker();
                          XFile? image = await _picker.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            debugPrint('image is ${image.path}');
                          }
                        },
                        icon: Image.network(
                            'https://lh3.googleusercontent.com/a-/ALV-UjXU_-UZDBZpa--y6Q73cIeVnnbSPr1gmTD8CkTi57HoZXc=s45-c'),
                        iconSize: 100),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.account_box),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Message',
                        icon: Icon(Icons.message),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    // your code
                  }),
            ],
          );
        });
  }
}
