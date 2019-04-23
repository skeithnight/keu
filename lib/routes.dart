import 'package:flutter/material.dart';
import 'package:keu/screen/main_screen.dart';
import 'package:keu/screen/authentication/login_page.dart';

final routes = {
  '/main':         (BuildContext context) => new MainScreen(),
  '/login':         (BuildContext context) => new LoginPage(),
  '/' :          (BuildContext context) => new MainScreen(),
};