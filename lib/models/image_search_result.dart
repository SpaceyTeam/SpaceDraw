class ImageSearchResult {
  Collection collection;

  ImageSearchResult({this.collection});

  ImageSearchResult.fromJson(Map<String, dynamic> json) {
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
  String href;
  List<Links> links;
  List<Items> items;
  String version;
  Metadata metadata;

  Collection({this.href, this.links, this.items, this.version, this.metadata});

  Collection.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['links'] != null) {
      links = new List<Links>();
      json['links'].forEach((v) {
        links.add(new Links.fromJson(v));
      });
    }
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    version = json['version'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['version'] = this.version;
    if (this.metadata != null) {
      data['metadata'] = this.metadata.toJson();
    }
    return data;
  }
}

class Links {
  String prompt;
  String href;
  String rel;

  Links({this.prompt, this.href, this.rel});

  Links.fromJson(Map<String, dynamic> json) {
    prompt = json['prompt'];
    href = json['href'];
    rel = json['rel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['prompt'] = this.prompt;
    data['href'] = this.href;
    data['rel'] = this.rel;
    return data;
  }
}

class Items {
  String href;
  List<Data> data;
  List<Links2> links;

  Items({this.href, this.data, this.links});

  Items.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    if (json['links'] != null) {
      links = new List<Links2>();
      json['links'].forEach((v) {
        links.add(new Links2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.links != null) {
      data['links'] = this.links.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String mediaType;
  String nasaId;
  String secondaryCreator;
  List<String> keywords;
  String description508;
  String description;
  String dateCreated;
  String center;
  String title;
  String location;
  List<String> album;
  String photographer;

  Data(
      {this.mediaType,
      this.nasaId,
      this.secondaryCreator,
      this.keywords,
      this.description508,
      this.description,
      this.dateCreated,
      this.center,
      this.title,
      this.location,
      this.album,
      this.photographer});

  Data.fromJson(Map<String, dynamic> json) {
    mediaType = json['media_type'];
    nasaId = json['nasa_id'];
    secondaryCreator = json['secondary_creator'];
    keywords = json['keywords']?.cast<String>();
    description508 = json['description_508'];
    description = json['description'];
    dateCreated = json['date_created'];
    center = json['center'];
    title = json['title'];
    location = json['location'];
    album = json['album']?.cast<String>();
    photographer = json['photographer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_type'] = this.mediaType;
    data['nasa_id'] = this.nasaId;
    data['secondary_creator'] = this.secondaryCreator;
    data['keywords'] = this.keywords;
    data['description_508'] = this.description508;
    data['description'] = this.description;
    data['date_created'] = this.dateCreated;
    data['center'] = this.center;
    data['title'] = this.title;
    data['location'] = this.location;
    data['album'] = this.album;
    data['photographer'] = this.photographer;
    return data;
  }
}

class Links2 {
  String href;
  String rel;
  String render;

  Links2({this.href, this.rel, this.render});

  Links2.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    rel = json['rel'];
    render = json['render'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['rel'] = this.rel;
    data['render'] = this.render;
    return data;
  }
}

class Metadata {
  int totalHits;

  Metadata({this.totalHits});

  Metadata.fromJson(Map<String, dynamic> json) {
    totalHits = json['total_hits'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_hits'] = this.totalHits;
    return data;
  }
}
