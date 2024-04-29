class ContactModel {
  String name;
  String? imagePath;
  String phoneNumber;
  String lastConnecting;
  String path;

  ContactModel({
    required this.name,
    this.imagePath,
    required this.phoneNumber,
    required this.lastConnecting,
    required this.path
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'imagePath': imagePath,
    'phoneNumber': phoneNumber,
    'lastConnecting': lastConnecting,
    'path': path
  };

  factory ContactModel.fromJson(Map<String, dynamic> map, String path){
    return ContactModel(
      name: map['name'],
      imagePath: map['imagePath'],
      phoneNumber: map['phoneNumber'],
      lastConnecting: map['lastConnecting'],
      path: path
    );
  }
}



List<ContactModel> contacts = [];
List<ContactModel> lastContacts = [];
