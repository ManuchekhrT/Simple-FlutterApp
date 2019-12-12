import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:goals_keeper_app/utils/helper_utils.dart';
import 'package:goals_keeper_app/utils/theme_utils.dart';
import 'package:goals_keeper_app/widgets/build_tile.dart';
import 'package:share/share.dart';


Widget buildAboutPage(BuildContext context) {
  double _width = MediaQuery.of(context).size.width * 0.75;
  Color invertColor = invertColors(context);

  return Container(
    child: ListView(
      padding: EdgeInsets.only(left: 6.0, right: 6.0),
      children: <Widget>[
        BuildTile(
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text(
                    "О приложении",
                    style: TextStyle(
                        color: invertColor, fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: _width,
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Простое и удобное приложение для отслеживания ваших "
                                  "целей. Вы легко сможете сделать заметки и установить дедлайн для достижения планированных целей. "
                                  "Когда закончится дедлайн вам придет уведомление.",
                              textAlign: TextAlign.left,
                              style:
                              TextStyle(color: invertColor, fontSize: 16.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(EvaIcons.share),
                                  color: invertColor,
                                  onPressed: () =>
                                      Share.share(
                                          "Рекомендую установить это приложение для достижения целей - перейдите по ссылке чтобы скачать приложение: https://play.google.com/store/apps/details?id=tj.mobidev.avera.goals_keeper_app")
                                ),
                                IconButton(
                                  icon: Icon(EvaIcons.star),
                                  color: invertColor,
                                  onPressed: () => launchURL(
                                      'https://play.google.com/store/apps/details?id=tj.mobidev.avera.goals_keeper_app'),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
      ],
    ),
  );
}