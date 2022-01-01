import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum routeDirection { up, down, left, right }

Route DirecteRoute(Widget page, routeDirection dir) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      Offset begin = _begin(dir);
      Offset end = _end(dir);
      const curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Offset _begin(routeDirection dir) {
  Offset result;
  switch (dir) {
    case routeDirection.up:
      {
        result = const Offset(0.0, 1.0);
      }
      break;
    case routeDirection.down:
      {
        result = Offset.zero;
      }
      break;
    case routeDirection.left:
      result = Offset.zero;
      break;
    case routeDirection.right:
      result = const Offset(0.1, 0.0);
      break;
  }
  return result;
}

Offset _end(routeDirection dir) {
  Offset result;
  switch (dir) {
    case routeDirection.up:
      {
        result = Offset.zero;
      }
      break;
    case routeDirection.down:
      {
        result = const Offset(0.0, 1.0);
      }
      break;
    case routeDirection.left:
      result = const Offset(1.0, 0.0);
      break;
    case routeDirection.right:
      result = Offset.zero;
      break;
  }
  return result;
}
