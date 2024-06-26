// Copyright 2023 Fries_I23
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/consts.dart';
import '../common/exceptions.dart';
import '../common/utils.dart';
import '../model/habit_date.dart';
import '../model/habit_detail_chart.dart';
import '../utils/habit_date.dart';
import 'utils.dart';

class HabitDetailScoreChartViewModel extends ChangeNotifier {
  late final UniqueKey _parentVersion;
  late final HabitDetailScoreChartCombine _chartCombine;
  late final SplayTreeMap<HabitDate, HabitDetailScoreChartDate> _data;
  late final bool _reversedData;
  bool _inited = false;
  AxisDirection? _cachedScrollDirection;
  // sync from settings
  int _firstday = defaultFirstDay;

  HabitDetailScoreChartViewModel();

  UniqueKey get parentVersion => _parentVersion;

  bool get isInited => _inited;

  HabitDetailScoreChartCombine get chartCombine => _chartCombine;

  int get offset => 0;

  int get firstday => _firstday;

  void updateFirstday(int newFirstDay) {
    final day = standardizeFirstDay(newFirstDay);
    if (kDebugMode && newFirstDay != day) {
      throw UnknownWeekdayNumber(newFirstDay);
    }
    _firstday = day;
  }

  void initState({
    required UniqueKey parentVersion,
    required HabitDetailScoreChartCombine chartCombine,
    Iterable<MapEntry<HabitDate, HabitDetailScoreChartDate>>? iter,
    bool reversedData = true,
    int? firstday,
  }) {
    if (_inited) return;
    _parentVersion = parentVersion;
    _chartCombine = chartCombine;
    _data = SplayTreeMap(
        reversedData ? (a, b) => b.compareTo(a) : (a, b) => a.compareTo(b));
    if (iter != null) _data.addEntries(iter);
    _reversedData = reversedData;
    if (firstday != null) updateFirstday(firstday);
    _inited = true;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _data.clear();
  }

  AxisDirection? consumeCachedAnimateDirection() {
    final tmp = _cachedScrollDirection;
    _cachedScrollDirection = null;
    return tmp;
  }

  HabitDate getCurrentChartLastDate(
          HabitDate? initDate, int limit) =>
      _reversedData
          ? scoreChartHelp.getFirstDate(initDate ?? HabitDate.now(), offset,
              limit, firstday, chartCombine: chartCombine)
          : scoreChartHelp.getLastDate(initDate ?? HabitDate.now(), offset,
              limit, firstday,
              chartCombine: chartCombine);

  HabitDate getCurrentChartFirstDate(HabitDate? initDate, int limit) =>
      _reversedData
          ? scoreChartHelp.getLastDate(
              initDate ?? HabitDate.now(), offset, limit, firstday,
              chartCombine: chartCombine)
          : scoreChartHelp.getFirstDate(
              initDate ?? HabitDate.now(), offset, limit, firstday,
              chartCombine: chartCombine);

  List<MapEntry<HabitDate, HabitDetailScoreChartDate>>
      getCurrentOffsetChartData({
    HabitDate? initDate,
    HabitDate? firstDate,
    HabitDate? lastDate,
    int? limit,
  }) {
    assert(!(firstDate == null && limit == null));
    assert(!(lastDate == null && limit == null));

    initDate ??= HabitDate.now();
    firstDate ??= getCurrentChartFirstDate(initDate, limit!);
    lastDate ??= getCurrentChartLastDate(initDate, limit!);

    final existMap = Map.fromEntries(filterWithDateRange(
      firstDate: firstDate,
      lastDate: lastDate,
      data: _data.entries,
      reversed: _reversedData,
    ));
    return scoreChartHelp
        .fetchDataByOffset(
          firstDate,
          lastDate,
          reversed: _reversedData,
          chartCombine: chartCombine,
          dataBuilder: (date) => existMap[date] ?? HabitDetailScoreChartDate(),
        )
        .toList();
  }
}
