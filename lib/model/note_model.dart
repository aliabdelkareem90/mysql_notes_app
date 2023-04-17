class NoteModel {
  String? id;
  String? title;
  String? content;
  String? image;
  String? user;

  NoteModel({this.id, this.title, this.content, this.image, this.user});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    image = json['image'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['image'] = content;
    data['user'] = user;
    return data;
  }
}
