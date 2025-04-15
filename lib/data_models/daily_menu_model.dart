class DailyMenuModel {
  final String day;
  final String opening;
  final String orderBy;
  final String closing;
  final Items items;

  DailyMenuModel({
    required this.day,
    required this.opening,
    required this.orderBy,
    required this.closing,
    required this.items,
  });

  factory DailyMenuModel.fromJson(Map<String, dynamic> json) {
    return DailyMenuModel(
      day: json['day'] ?? '',
      opening: json['opening'] ?? '',
      orderBy: json['orderBy'] ?? '',
      closing: json['closing'] ?? '',
      items: Items.fromJson(json['items']),
    );
  }
}

class Items {
  final List<MenuItem> zmrzlina;
  final List<MenuItem> trist;
  final List<MenuItem> ostatni;

  Items({
    required this.zmrzlina,
    required this.trist,
    required this.ostatni,
  });

  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      zmrzlina: (json['zmrzlina'] as List<dynamic>?)?.map((item) => MenuItem.fromJson(item)).toList() ?? [],
      trist: (json['trist'] as List<dynamic>?)?.map((item) => MenuItem.fromJson(item)).toList() ?? [],
      ostatni: (json['ostatni'] as List<dynamic>?)?.map((item) => MenuItem.fromJson(item)).toList() ?? [],
    );
  }
}

class MenuItem {
  final bool active;
  final String name;
  final List<SizeOption> sizes;

  MenuItem({
    required this.active,
    required this.name,
    required this.sizes,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      active: json['active'] ?? false,
      name: json['name'] ?? '',
      sizes: (json['sizes'] as List<dynamic>?)?.map((size) => SizeOption.fromJson(size)).toList() ?? [],
    );
  }
}

class SizeOption {
  final int id;
  final double price;
  final Velikost velikost;

  SizeOption({
    required this.id,
    required this.price,
    required this.velikost,
  });

  factory SizeOption.fromJson(Map<String, dynamic> json) {
    return SizeOption(
      id: json['id'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      velikost: Velikost.fromJson(json['velikost']),
    );
  }
}

class Velikost {
  final String name;
  final int grams;

  Velikost({
    required this.name,
    required this.grams,
  });

  factory Velikost.fromJson(Map<String, dynamic> json) {
    return Velikost(
      name: json['name'] ?? '',
      grams: json['grams'] ?? 0,
    );
  }
}
