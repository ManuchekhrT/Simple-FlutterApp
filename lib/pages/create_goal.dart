import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:goals_keeper_app/model/goal.dart';
import 'package:goals_keeper_app/service/interfaces/irepository.dart';
import 'package:goals_keeper_app/service/notification_center.dart';
import 'package:goals_keeper_app/utils/colors.dart';
import 'package:goals_keeper_app/utils/helper_utils.dart';
import 'package:goals_keeper_app/utils/pickers.dart';
import 'package:goals_keeper_app/utils/theme_utils.dart';


class CreateGoal extends StatefulWidget {
  final IRepository repository;
  final NotificationCenter notificationCenter;

  CreateGoal({@required this.repository, @required this.notificationCenter});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CreateGoalState(
        repository: this.repository,
        notificationCenter: this.notificationCenter
    );
  }
}

class CreateGoalState extends State<CreateGoal>{
  final IRepository repository;
  final NotificationCenter notificationCenter;

  Goal goal = new Goal("", "");
  Color invertColor;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();

  CreateGoalState(
      {@required this.repository, @required this.notificationCenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        backgroundColor: Colors.green,
        title: Text(
          "Добавить новую цель",
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
                  tag: "",
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
                      borderSide: BorderSide(color: MyColors.purple),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Название",
                    hintText: "Твоя цель на сегодня?",
                    labelStyle: TextStyle(
                      color: this.invertColor,
                    ),
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
                      borderSide: BorderSide(color: MyColors.purple),
                    ),
                    border: OutlineInputBorder(),
                    labelText: "Описание",
                    hintText: "Объясните",
                    labelStyle: TextStyle(
                      color: this.invertColor,
                    ),
                    hintStyle: TextStyle(
                      color: this.invertColor,
                    ),
                    contentPadding: const EdgeInsets.all(15.0),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                      primaryColor: MyColors.purple,
                      accentColor: MyColors.yellow),
                  child: Builder(
                    builder: (context) => FlatButton(
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
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      onPressed: () {
                        createNewDeadline(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
//                      borderSide: BorderSide(color: MyColors.purple),
//                      highlightedBorderColor: MyColors.yellow,
                      splashColor: MyColors.yellow
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveGoal();
        },
        child: Icon(Icons.check),
        foregroundColor: MyColors.light,
        backgroundColor: MyColors.pink,
        elevation: 3.0,
        heroTag: "fab",
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
    if (goal.title.trim().isNotEmpty) {
      if (goal.id == null) {
        repository.insert(goal);
      } else {
        repository.update(goal);
      }
      notificationCenter.scheduleNotification(goal);
    }
  }

  void createNewDeadline(context) async {
    DateTime dueDate = await pickDate(context);
    if (dueDate == null) return;

    TimeOfDay dueTime = await pickTime(context);
    if (dueTime == null) return;

    DateTime deadLine = DateTime(
        dueDate.year, dueDate.month, dueDate.day, dueTime.hour, dueTime.minute);

    showSnackBar(context, "Дедлайн установлен ${getFormattedDate(deadLine)}!");

    setState(() {
      goal.deadLine = deadLine;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this.invertColor = invertColors(context);
  }
}