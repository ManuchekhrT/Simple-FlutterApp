import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goals_keeper_app/pages/home.dart';
import 'package:goals_keeper_app/service/db.dart';
import 'package:goals_keeper_app/service/factory.dart';
import 'package:goals_keeper_app/service/goals_repository.dart';
import 'package:goals_keeper_app/service/interfaces/irepository.dart';
import 'package:goals_keeper_app/service/notification_center.dart';
import 'package:goals_keeper_app/utils/colors.dart';

void main() {
  prepareDependencies();
  runApp(MyApp(
    repository: Factory().repository,
  ));
}

// Composition root for our dependencies !
void prepareDependencies() {
  var factory = Factory();
  factory.registerDatabase(Db());
  factory.registerRepository(GoalsRepository(database: factory.database));
  factory.registerNotificationCenter(
      NotificationCenter(repository: factory.repository));
}

class MyApp extends StatelessWidget {
  final IRepository repository;

  MyApp({@required this.repository});

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) =>
      new ThemeData(
        primaryColor: MyColors.primaryColor,
        accentColor: MyColors.accentColor,
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Достигай целей",
          theme: theme,
          home: Home(repository: this.repository),
        );
      },
    );
  }
}