import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goals_keeper_app/model/goal.dart';
import 'package:goals_keeper_app/service/interfaces/irepository.dart';
import 'package:goals_keeper_app/service/navigation.dart';
import 'package:goals_keeper_app/utils/colors.dart';
import 'package:goals_keeper_app/utils/helper_utils.dart';
import 'package:goals_keeper_app/utils/theme_utils.dart';
import 'package:goals_keeper_app/widgets/build_tile.dart';
import 'package:goals_keeper_app/widgets/empty_page.dart';
import 'package:share/share.dart';

import 'about.dart';

class Home extends StatefulWidget {
  final IRepository repository;

  Home({@required this.repository});

  @override
  _HomeState createState() => _HomeState(repository: this.repository);
}

class _HomeState extends State<Home> {
  final IRepository repository;
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);
  PageController _myPage = PageController(initialPage: 0);
  Future<List<Goal>> goalListPromise;

  _HomeState({@required this.repository});

  @override
  void initState() {
    super.initState();
    this.goalListPromise = repository.getGoalsList();
  }

  void toggleBrightness() {
    DynamicTheme.of(context).setBrightness(
      getInvertTheme(context),
    );
  }

  Widget buildGoalsListPage() {
    return FutureBuilder(
      future: this.goalListPromise,
      builder: (BuildContext context, AsyncSnapshot<List<Goal>> goals) {
        if (goals.hasError)
          showSnackBar(context, goals.error.toString());
        else if (goals.connectionState == ConnectionState.done)
          return (goals.hasData && goals.data.isNotEmpty
              ? buildGoalsList(goals.data)
              : EmptyPage());
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Tween<Rect> heroRectTween(Rect begin, Rect end) =>
      RectTween(begin: begin, end: end);

  Widget buildGoalsList(List<Goal> goals) {
    double _width = MediaQuery.of(context).size.width * 0.75;

    return Container(
      child: ListView.builder(
        itemCount: goals.length,
        controller: this._scrollController,
        itemBuilder: (BuildContext context, int index) {
          var goal = goals[index];

          return BuildTile(
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Hero(
                        createRectTween: this.heroRectTween,
                        tag: "dartIcon${goal.id}",
                        child: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/goals.png"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(left: 16.0)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: _width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Цель @${goal.id}",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            goal.deadLine != null
                                ? Row(
                                    children: <Widget>[
                                      Icon(
                                        EvaIcons.clock,
                                        size: 17,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        getFormattedDate(goal.deadLine),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Container(
                        width: _width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              goal.title,
                              style: TextStyle(
                                  color: invertColors(context),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21.0),
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              goal.body,
                              style: TextStyle(
                                  color: invertColors(context), fontSize: 15.0),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
            onTap: () => goToEditGoal(context, goal),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = isThemeCurrentlyDark(context);
    Icon actionIcon = isDarkTheme ? Icon(EvaIcons.sun) : Icon(EvaIcons.moon);
    String toolTip = isDarkTheme ? "BURN YOUR EYES" : "SAVE YOUR EYES";

    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text(
          "Мои цели",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22.0),
        ),
        actions: <Widget>[
          IconButton(
            icon: actionIcon,
            tooltip: toolTip,
            onPressed: toggleBrightness,
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () => launchURL(
                'https://play.google.com/store/apps/details?id=tj.mobidev.avera.goals_keeper_app')
          ),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () => Share.share(
                  "Рекомендую установить это приложение для достижения целей - перейдите по ссылке чтобы скачать приложение: https://play.google.com/store/apps/details?id=tj.mobidev.avera.goals_keeper_app")
              )
        ],
      ),
      body: PageView(
        controller: _myPage,
        children: <Widget>[
          buildGoalsListPage(),
          buildAboutPage(context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          goToCreateGoal(context);
        },
        child: Icon(Icons.add, size: 28,),
        foregroundColor: Colors.white,
        backgroundColor: MyColors.pink,
        elevation: 3.0,
        heroTag: "fab",
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 15.0,
        shape: CircularNotchedRectangle(),
        notchMargin: 9.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                size: 26,
              ),
              color: invertColors(context),
              onPressed: () {
                _myPage.animateToPage(
                  0,
                  curve: Curves.easeInQuart,
                  duration: Duration(milliseconds: 300),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.info,
                size: 26,
              ),
              color: invertColors(context),
              onPressed: () {
                _myPage.animateToPage(
                  1,
                  curve: Curves.bounceInOut,
                  duration: Duration(milliseconds: 300),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
