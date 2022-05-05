class blogmodel{
  int _blogid=0;
  String _title="";
  String _content="";
  String _authorname="";
  String _authorurl="";
  String _pubdate="";
  int? _likes;
  int? _report;
  blogmodel(this._blogid, this._title, this._content,this._pubdate,this._authorname,this._authorurl,this._likes,this._report);
  blogmodel.empty();


  int? get report => _report;

  set report(int? value) {
    _report = value;
  }

  String get authorname => _authorname;

  set authorname(String value) {
    _authorname = value;
  }

  int get blogid => _blogid;

  set blogid(int value) {
    _blogid = value;
  }

  String get title => _title;

  String get pubdate => _pubdate;

  set pubdate(String value) {
    _pubdate = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  set title(String value) {
    _title = value;
  }

  int? get likes => _likes;

  set likes(int? value) {
    _likes = value;
  }

  factory blogmodel.fromJson(Map<String, dynamic> json) {
    return blogmodel(json["_id"]!, json["title"]!, json["content"]!, json["date"]!,json["author_id"]["name"]!,json["author_id"]["profile_color"]!, json["likes"]!,json["report"]!);
  }

  String get authorurl => _authorurl;

  set authorurl(String value) {
    _authorurl = value;
  }
}