import 'package:goals_keeper_app/model/goal.dart';

abstract class IRepository {
  int getGoalsCount();
  void insert(Goal goal);
  void delete(Goal goal);
  void update(Goal goal);
  Goal find(int goalId);
  int getNextId();
  Future<List<Goal>> getGoalsList();
}