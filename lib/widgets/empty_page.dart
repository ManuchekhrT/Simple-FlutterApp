import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:goals_keeper_app/utils/theme_utils.dart';



class EmptyPage extends StatelessWidget {
  EmptyPage({color});

  @override
  Widget build(BuildContext context) {
    Color invertColor = invertColors(context);
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              EvaIcons.trendingUp,
              size: 67.0,
              color: invertColor,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Пока нет целей",
                style: TextStyle(
                  color: invertColor,
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}