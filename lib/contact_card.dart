import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kontaktlista/model/contact.dart';
import 'package:kontaktlista/service/image_service.dart';

class ContactCard extends StatelessWidget {
  final Contact contact;

  const ContactCard({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Row(children: [
                const SizedBox(height: 100),
                CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        // if contact has image setup else use below
                        //Image.file(File(tempAvatarFile?.path ?? '')).image,
                        Image.memory(ImageService.imageFromBase64String(
                                contact.getPhoto))
                            .image),
                const SizedBox(width: 30),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    'Nome: ${contact.getName} ${contact.getSurname}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Phone: ${contact.getPhone}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ]),
              ]),
            ])));
  }
}
