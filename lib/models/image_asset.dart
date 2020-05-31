class ImageAsset {
  Collection collection;

  ImageAsset({this.collection});

  ImageAsset.fromJson(Map<String, dynamic> json) {
    collection = json['collection'] != null
        ? new Collection.fromJson(json['collection'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.collection != null) {
      data['collection'] = this.collection.toJson();
    }
    return data;
  }
}

class Collection {
  List<Items> items;
  String version;
  String href;

  Collection({this.items, this.version, this.href});

  Collection.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    version = json['version'];
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    data['href'] = this.href;
    return data;
  }
}

class Items {
  String href;

  Items({this.href});

  Items.fromJson(Map<String, dynamic> json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    return data;
  }
}
