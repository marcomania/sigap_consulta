class Files_rec {
  List<Files_rec> items = new List();
  Files_rec();
  Files_rec.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final file_rec = new File_rec.fromJsonMap(item);
      item.add(file_rec);
    }
  }
}

class File_rec {
  String url;

  File_rec({
    this.url,
  });

  File_rec.fromJsonMap(Map<String, dynamic> json) {
    url = json['url'];
  }
}
