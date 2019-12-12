

import 'package:goals_keeper_app/model/goal.dart';

abstract class IDatabase {
  Future<int> createGoal(Goal goal);
  Future<int> updateGoal(Goal goal);
  Future<int> deleteGoal(Goal goal);
  Future<int> getCount(Goal goal);
  Future<List<Goal>> getGoalsList();
}