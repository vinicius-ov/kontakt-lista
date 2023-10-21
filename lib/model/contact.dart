class Contact {
  String? _objectId;
  String? _createdAt;
  String? _updatedAt;
  String _name;
  String _surname;
  String _phone;
  String _photo;

  Contact(String name, String surname, String phone, String photo)
      : _name = name,
        _surname = surname,
        _phone = phone,
        _photo = photo;

  Contact.empty()
      : _name = '',
        _surname = '',
        _phone = ' ',
        _photo = '';

  String get getObjectId => _objectId ?? '';
  String get getName => _name;
  String get getSurname => _surname;
  String get getPhone => _phone;
  String get getPhoto => _photo;

  void setName(String name) => _name = name;
  void setSurname(String surname) => _surname = surname;
  void setPhone(String phone) => _phone = phone;
  void setPhoto(String photo) => _photo = photo;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = _objectId;
    data['name'] = _name;
    data['surname'] = _surname;
    data['phone'] = _phone;
    data['photo'] = _photo;
    return data;
  }

  static Contact fromJson(Map<String, dynamic> result) {
    Contact contact = Contact(
        result['name'], result['surname'], result['phone'], result['photo']);
    contact._createdAt = result['createdAt'];
    contact._objectId = result['objectId'];
    contact._updatedAt = result['updatedAt'];
    return contact;
  }
}
