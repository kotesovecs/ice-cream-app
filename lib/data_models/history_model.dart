class HistoryModel {
  int count;
  List<Map<dynamic, dynamic>> objednavky;

  HistoryModel({required this.count, this.objednavky = const [{}]});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      count: json['count'] as int,
      objednavky: List<Map<dynamic, dynamic>>.from(json['objednavky']),
    );
  }
}
