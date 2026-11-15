import 'package:aivsol_solo_travel/core/extensions/theme_extensions.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/date_select_widget.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/from_to_input_widget.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/generate_trip_plan_button_widget.dart';
import 'package:aivsol_solo_travel/feature/home/presentation/widgets/travel_style_select_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const .only(left: 10, bottom: 7, top: 7),
          padding: const .all(10),
          decoration: BoxDecoration(
            borderRadius: .circular(6),
            color: context.themeData.primaryColor,
          ),
          child: Icon(
            CupertinoIcons.location_fill,
            color: context.themeData.scaffoldBackgroundColor,
          ),
        ),
        title: const Text('Solo Travler'),
      ),
      body: SingleChildScrollView(
        padding: const .all(12),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Where would you like to go?',
              style: context.textTheme.headlineMedium,
              maxLines: 2,
              textAlign: .start,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                'Plan your next adventure effortlessly.',
                style: context.textTheme.bodyMedium,
                maxLines: 1,
                textAlign: .start,
              ),
            ),
            const FromToInputWidget(),
            const DateSelectWidget(),
            const TravelStyleSelectWidget(),
            const GenerateTripPlanButtonWidget(),
          ],
        ),
      ),
    );
  }
}
