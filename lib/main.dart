import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/login_page.dart';
import 'authentication/login_view.dart';
import 'bank/transaction_detail_view.dart';
import 'chores/chore_detail_view.dart';
import 'dependency_injection_container.dart' as di;
import 'families/family_detail_view.dart';
import 'families/family_list_view.dart';
import 'family_member/family_member_detail_view.dart';
import 'theme/base_theme.dart';
import 'theme/chore_app_theme.dart';
import 'utils/log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.init();
  final logger = Logger();
  setLogger(logger.d);
  GetIt.I.isReady<SharedPreferences>().then(
    (_) {
      runApp(
        BaseTheme(
          appTheme: choresAppTheme,
          child: Builder(
            builder: (context) {
              return MyApp(
                theme: BaseTheme.of(context),
              );
            },
          ),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final BaseTheme theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chores App',
      theme: ThemeData(
        primaryColor: theme.colors.primary,
        iconTheme: theme.iconThemeData,
        colorScheme: theme.colorScheme.colorScheme,
        inputDecorationTheme: theme.inputDecorationTheme,
        brightness: Brightness.light,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colors(context).secondary,
          selectionColor: colors(context).secondary,
          selectionHandleColor: colors(context).secondary,
        ),
        fontFamily: theme.font,
        appBarTheme: theme.appBarTheme,
      ),
      initialRoute: LoginView.routeName,
      routes: {
        LoginView.routeName: (context) => LoginPage(),
        FamilyListView.routeName: (context) => FamilyListView(),
        FamilyDetailView.routeName: (context) => FamilyDetailView(),
        FamilyMemberDetailView.routeName: (context) => FamilyMemberDetailView(),
        ChoreDetailView.routeName: (context) => ChoreDetailView(),
        TransactionDetailView.routeName: (context) => TransactionDetailView(),
      },
    );
  }
}
