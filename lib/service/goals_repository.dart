

import 'package:flutter/cupertino.dart';
import 'package:goals_keeper_app/model/goal.dart';
import 'package:goals_keeper_app/service/interfaces/icache.dart';
import 'package:goals_keeper_app/service/interfaces/irepository.dart';

import 'interfaces/idatabase.dart';

class GoalsRepository implements IRepository, ICache<Goal> {
  List<Goal> _cache = new List<Goal>();
  IDatabase database;
  GoalsRepository({@required this.database});

  bool shouldSyncCache = true;

  @override
  void delete(Goal goal) {
    database.deleteGoal(goal);
    _cache.removeWhere((Goal _goal) => _goal.id == goal.id);
  }

  @override
  Goal find(int goalId) {
    return _cache.firstWhere((Goal goal) => goal.id == goalId,
        orElse: () => null);
  }

  int getGoalsCount() => _cache.length;

  @override
  Future<List<Goal>> getGoalsList() async {
    if (shouldSyncCache) {
      await syncCache();
    }
    return _cache;
  }

  @override
  int getNextId() {
    // since the id is auto-generated in predictable way, we can read the future ! :D
    return _cache.isNotEmpty ? _cache.last.id + 1 : 1;
  }

  @override
  void insert(Goal goal) {
    if (goal.id == null) goal.id = this.getNextId();
    database.createGoal(goal);
    _cache.add(goal);
  }

  @override
  Future<void> syncCache() async {
    if (_cache.isNotEmpty) _cache.clear();
    var goalsList = await database.getGoalsList();
    _cache.addAll(goalsList);
    shouldSyncCache = false;
  }

  @override
  void update(Goal goal) {
    database.updateGoal(goal);
    var itemIndex = _cache.indexWhere((Goal _g) => _g.id == goal.id);
    if (itemIndex == -1) return;

    if (_cache.length == 1) {
      _cache.clear();
      _cache.add(goal);
    } else {
      _cache.replaceRange(itemIndex, itemIndex + 1, [goal]);
    }
  }






}