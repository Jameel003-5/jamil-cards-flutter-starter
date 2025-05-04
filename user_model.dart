class UserModel {
  String? email, userName, phone,title,img,bio,id,cover;
  List? links;
  List? connections;

  UserModel({this.userName,this.id, this.email, this.title,  this.phone,this.bio,this.img,this.links,this.connections,this.cover});

  UserModel.fromJson(map){
    if (map == null) {
      return;
    }
    email = map ['email'];
    id = map['id'];
    bio = map['bio'];
    userName = map ['userName'];
    phone = map ['phone'];
    title = map['title'];
    img = map['photo'];
    links = map['links'];
    connections = map['connections'];
    cover = map['cover'];
  }

  toJson() {
    return {
      'email': email,
      'userName': userName,
      'id' : id,
      'photo':"https://www.clipartkey.com/view/xmmbTT_user-profile-default-image-png-clipart-png-download/",
      'links':[],
      'title': title,
      'connections' : [],
      'phone': phone,
      'bio': bio,
      'cover' : cover,
    };
  }

}