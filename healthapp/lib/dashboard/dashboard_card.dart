import 'package:flutter/material.dart';
import 'package:healthapp/dashboard/gradientColor.dart';

class DashboardCard extends StatefulWidget {
  const DashboardCard(
      {Key? key,
      this.flex = 1,
      this.color = Colors.white,
      this.height = 120,
      this.child, this.onTap})
      : super(key: key);
  final int? flex;
  final Color? color;
  final double? height;
  final Widget? child;
  final Function()? onTap;

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> {
  Widget circle(double size, int dir){
    Color c2 = Color.fromRGBO(widget.color!.red, widget.color!.green, widget.color!.blue, 0);
    return Opacity(
      opacity: 1,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: dir == 1 ? Alignment.bottomLeft : Alignment.topRight,
            end: dir == 0 ? Alignment.bottomLeft : Alignment.topRight,
            colors: [GradientColor.lightenColor(widget.color!.value), c2],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.flex!,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.all(10),
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: GradientColor.getGradient(widget.color!.value),
              ),
              color: widget.color!,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            //child: widget.child!,
            child: Stack(
              children: [
                Positioned.fill(child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: widget.child!,
                ))
              ],
            ),
          ),
        ));
  }
}
