import 'package:flutter/material.dart';
import 'package:goals_keeper_app/utils/colors.dart';


class BuildTile extends StatelessWidget {

  BuildTile(this.widgetContent, {this.onTap});
  final Function onTap;
  final Widget widgetContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12, left: 5, right: 5),
      child: Material(
        color: Theme.of(context).brightness == Brightness.dark
            ? MyColors.black
            : MyColors.white,
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: onTap ?? this.defaultOnTap,
          child: widgetContent,
          splashColor: MyColors.accentColor,
        ),
      ),
    );
  }

  void defaultOnTap() {}

}