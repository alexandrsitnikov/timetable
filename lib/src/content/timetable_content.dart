import 'package:black_hole_flutter/black_hole_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:time_machine/time_machine.dart';

import '../controller.dart';
import '../event.dart';
import '../theme.dart';
import '../timetable.dart';
import '../utils/vertical_zoom.dart';
import 'date_hours_painter.dart';
import 'multi_date_content.dart';

class TimetableContent<E extends Event> extends StatelessWidget {
  const TimetableContent({
    Key? key,
    required this.controller,
    required this.eventBuilder,
    this.onEventBackgroundTap,
    this.theme,
    this.dateHoursWidgetBuilder,
    this.backgroundPainter,
  }) : super(key: key);

  final TimetableController<E> controller;
  final EventBuilder<E> eventBuilder;
  final OnEventBackgroundTapCallback? onEventBackgroundTap;
  final TimetableThemeData? theme;
  final WidgetBuilder? dateHoursWidgetBuilder;
  final CustomPainter? backgroundPainter;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final timetableTheme = context.timetableTheme;

    return VerticalZoom(
      initialZoom: controller.initialTimeRange.asInitialZoom(),
      minChildHeight:
          (timetableTheme?.minimumHourHeight ?? 16) * TimeConstants.hoursPerDay,
      maxChildHeight:
          (timetableTheme?.maximumHourHeight ?? 64) * TimeConstants.hoursPerDay,
      child: Row(
        children: <Widget>[
          dateHoursWidgetBuilder != null
              ? Container(
                  width: timetableTheme?.hourColumnWidth ?? hourColumnWidth,
                  child: dateHoursWidgetBuilder!(context))
              : Container(
                  width: timetableTheme?.hourColumnWidth ?? hourColumnWidth,
                  padding: EdgeInsets.only(right: 12),
                  child: CustomPaint(
                    painter: DateHoursPainter(
                      textStyle: timetableTheme?.hourTextStyle ??
                          theme.textTheme.caption?.copyWith(
                            color: context.theme.disabledOnBackground,
                          ) ??
                          TextStyle(),
                      textDirection: context.directionality,
                    ),
                    size: Size.infinite,
                  ),
                  decoration: BoxDecoration(
                      color: this.theme?.hourBackgroundColor,
                      border: Border(
                          right:
                              BorderSide(color: Color(0xFFe2e2e2), width: 1))),
                ),
          Expanded(
            child: MultiDateContent<E>(
              controller: controller,
              eventBuilder: eventBuilder,
              onEventBackgroundTap: onEventBackgroundTap,
              backgroundPainter: backgroundPainter,
            ),
          ),
        ],
      ),
    );
  }
}
