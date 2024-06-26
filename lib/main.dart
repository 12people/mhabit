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

import 'package:flutter/material.dart';

import 'common/app_info.dart';
import 'logging/logger_manager.dart';
import 'reminders/notification_service.dart';
import 'utils/local_timezone.dart';
import 'view/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLoggerMananger(t: AppLoggerHandlerType.debugging).init();
  await AppInfo().init();
  await NotificationService().init();
  await LocalTimeZoneManager().init();

  runApp(const App());
}
