import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:goals_keeper_app/model/goal.dart';
import 'package:goals_keeper_app/service/interfaces/irepository.dart';
import 'package:goals_keeper_app/service/notification_center.dart';
import 'package:goals_keeper_app/utils/colors.dart';
import 'package:goals_keeper_app/utils/helper_utils.dart';
import 'package:goals_keeper_app/utils/pickers.dart';
import 'package:goals_keeper_app/utils/theme_utils.dart';

class EditGoal extends StatefulWidget {
  final Goal goal;
  final NotificationCenter notificationCenter;
  final IRepository repository;

  EditGoal(this.goal,
      {@required this.repository,
        @required this.notificationCenter}); //constructor

  @override
  State<StatefulWidget> createState() {
    return EditGoalState(this.goal, this.notificationCenter, this.repository);
  }
}

class EditGoalState extends State<EditGoal> {
  final IRepository repository;
  final NotificationCenter notificationCenter;

  Goal goal;
  Color invertColor;

  TextEditingController _bodyTextController;
  TextEditingController _titleTextController;

  EditGoalState(this.goal, this.notificationCenter, this.repository) {
    this._titleTextController =
    new TextEditingController(text: this.goal.title);
    this._bodyTextController = new TextEditingController(text: this.goal.body);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.invertColor = invertColors(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Colors.green,
        title: Text(
          "Изменить цель",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20.0),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Hero(
                  tag: "dartIcon${goal.id}",
                  child: Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/goals.png"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: this._titleTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    color: this.invertColor,
                  ),
                  onChanged: this.updateTitle,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: this.invertColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.green),
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Название",
                    hintStyle: TextStyle(
                      color: this.invertColor,
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: this._bodyTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  style: TextStyle(
                    color: this.invertColor,
                  ),
                  onChanged: this.updateBody,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: this.invertColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyColors.green),
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Описание",
                    hintStyle: TextStyle(
                      color: this.invertColor,
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: MyColors.purple,
                      accentColor: MyColors.yellow),
                  child: Builder(
                    builder: (context) =>
                        FlatButton(
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.date_range),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    goal.deadLine == null
                                        ? "Добавить дедлайн"
                                        : "Изменить дедлайн",
                                    style: TextStyle(
                                      color: this.invertColor,
                                      fontWeight: FontWeight.w500, fontSize: 17
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          onPressed: () {
                            this.editDeadLine(context);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
//                          borderSide: BorderSide(color: MyColors.purple),
//                          highlightedBorderColor: MyColors.yellow,
                          splashColor: MyColors.yellow,
                        ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        heroTag: "fab",
        closeManually: false,
        foregroundColor: MyColors.light,
        backgroundColor: MyColors.pink,
        elevation: 3.0,
        children: [
          SpeedDialChild(
            child: Icon(Icons.save),
            foregroundColor: MyColors.light,
            backgroundColor: MyColors.blue,
            label: "Сохранить",
            labelStyle:
            TextStyle(color: MyColors.dark, fontWeight: FontWeight.w500),
            onTap: this.saveGoal,
          ),
          SpeedDialChild(
            child: Icon(Icons.delete_forever),
            foregroundColor: MyColors.light,
            backgroundColor: MyColors.red,
            label: "Удалить",
            labelStyle:
            TextStyle(color: MyColors.dark, fontWeight: FontWeight.w500),
            onTap: this.deleteGoal,
          ),
        ],
      ),
    );
  }

  void updateTitle(String newTitle) {
    this.setState(() {
      goal.title = newTitle;
    });
  }

  void updateBody(String newBody) {
    this.setState(() {
      goal.body = newBody;
    });
  }

  void saveGoal() async {
    Navigator.pop(context);

    if (goal.title
        .trim()
        .isNotEmpty) {
      if (goal.id == null) {
        repository.insert(goal);
      } else {
        repository.update(goal);
      }
    }

    notificationCenter.updateGoalNotification(goal);
  }

  void deleteGoal() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Удалить \'${goal.title}\'?",
            style:
            TextStyle(color: this.invertColor, fontWeight: FontWeight.w600),
          ),
          content: Text(
            "Эта цель будет удалена!",
            style: TextStyle(
              color: this.invertColor,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Отменить',
                style: TextStyle(
                    color: this.invertColor, fontWeight: FontWeight.w500),
              ),
              onPressed: Navigator
                  .of(context)
                  .pop,
            ),
            FlatButton(
              child: Text(
                'Удалить',
                style:
                TextStyle(color: MyColors.red, fontWeight: FontWeight.w500),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                repository.delete(goal);
              },
            ),
          ],
        );
      },
    );
  }

  void editDeadLine(context) async {
    DateTime dueDate = await pickDate(context);
    if (dueDate == null) return;

    TimeOfDay dueTime = await pickTime(context);
    if (dueTime == null) return;

    DateTime deadLine = DateTime(
        dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute);

    setState(() {
      goal.deadLine = deadLine;
    });

    showSnackBar(context, "Дедлайн установлен на ${getFormattedDate(deadLine)}!");
  }
}