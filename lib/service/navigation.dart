import 'package:flutter/cupertino.dart';
import 'package:goals_keeper_app/model/goal.dart';
import 'package:goals_keeper_app/pages/create_goal.dart';
import 'package:goals_keeper_app/pages/edit_goal.dart';

import 'factory.dart';


void goToCreateGoal(context) async {
  await Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) {
        return CreateGoal(
          repository: Factory().repository,
          notificationCenter: Factory().notificationCenter,
        );
      },
    ),
  );
}

void goToEditGoal(context, Goal goal) async {
  await Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) {
        return EditGoal(goal,
            notificationCenter: Factory().notificationCenter,
            repository: Factory().repository);
      },
    ),
  );
}