class usermodel{
  String _name="";
  String _photourl="";
  String _uid="";
  String _email="";


  usermodel(this._name, this._photourl, this._uid, this._email);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  String get photourl => _photourl;

  set photourl(String value) {
    _photourl = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }
}