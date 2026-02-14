
/* ProductService class */
class ProductService {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  /* Constructer */
  ProductService({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  /* Convert JSON to ProductService */
  ProductService.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = (json['price'] as num).toDouble();
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  /* Convert ProductService to JSON */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

/* Rating class */
class Rating {
  double? rate;
  int? count;

  /* Constructer */
  Rating({this.rate, this.count});

    /* Convert JSON to Rating */
  Rating.fromJson(Map<String, dynamic> json) {
    rate = (json['rate'] as num).toDouble();
    count = json['count'];
  }

  /* Convert Rating to JSON */
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}
