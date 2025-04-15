import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';
import 'day_card_model.dart';

class DayCard extends StackedView<DayCardModel> {
  const DayCard({super.key, required this.data});
  final DailyMenuDto? data;

  @override
  Widget builder(
    BuildContext context,
    DayCardModel viewModel,
    Widget? child,
  ) {
    // Format time to display only HH:mm
    String formatTime(String? time) {
      if (time == null || time.isEmpty) return 'Neznámý čas';
      try {
        return DateFormat('HH:mm').format(DateFormat('HH:mm:ss').parse(time));
      } catch (e) {
        return 'Neplatný čas';
      }
    }

    return FutureBuilder(
        future: viewModel.initDateFormatting(),
        builder: (context, snapshot) {
          return Skeletonizer(
            enabled: data == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1.0),
                child: Text(
                  data!.day != null
                      ? (() {
                          try {
                            DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(data?.day ?? '');
                            return '${DateFormat('EEEE', 'cs').format(parsedDate)} ${DateFormat('dd.MM.').format(parsedDate)}';
                          } catch (e) {
                            return 'Neznámé datum';
                          }
                        })()
                      : 'Neznámé datum',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 1.0),
                child: Text(
                  "otevřeno: ${formatTime(data!.opening)} - ${formatTime(data!.closing)}",
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                child: Text(
                  "objednávat lze do ${formatTime(data!.orderBy)}",
                  style: const TextStyle(color: Color(0xFF666666), fontSize: 20),
                ),
              )
            ]),
          );
        });
  }

  @override
  DayCardModel viewModelBuilder(
    BuildContext context,
  ) =>
      DayCardModel();
}
