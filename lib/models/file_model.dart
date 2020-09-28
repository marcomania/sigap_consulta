class FilesRec {
  List<FilesRec> items = new List();
  FilesRec();
  FilesRec.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final fileRec = new FileRec.fromJsonMap(item);
      item.add(fileRec);
    }
  }
}

class FileRec {
  String url;

  FileRec({
    this.url,
  });

  FileRec.fromJsonMap(Map<String, dynamic> json) {
    url = json['url'];
  }
}
