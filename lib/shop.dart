class Shop {
  List<Shops>? shops;

  Shop({this.shops});

  Shop.fromJson(Map<String, dynamic> json) {
    if (json['shops'] != null) {
      shops = <Shops>[];
      json['shops'].forEach((v) {
        shops!.add(new Shops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shops != null) {
      data['shops'] = this.shops!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  int? id;
  String? idShopGroup;
  String? idCategory;
  String? active;
  String? deleted;
  String? name;
  String? themeName;

  Shops(
      {this.id,
      this.idShopGroup,
      this.idCategory,
      this.active,
      this.deleted,
      this.name,
      this.themeName});

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idShopGroup = json['id_shop_group'];
    idCategory = json['id_category'];
    active = json['active'];
    deleted = json['deleted'];
    name = json['name'];
    themeName = json['theme_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_shop_group'] = this.idShopGroup;
    data['id_category'] = this.idCategory;
    data['active'] = this.active;
    data['deleted'] = this.deleted;
    data['name'] = this.name;
    data['theme_name'] = this.themeName;
    return data;
  }
}
