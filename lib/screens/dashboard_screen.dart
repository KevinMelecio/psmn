import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:pmsn20232/assets/global_values.dart';
import 'package:pmsn20232/assets/styles_app.dart';
import 'package:pmsn20232/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _disableRememberMe(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove('rememberMe');
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

class DashboardScreen extends StatefulWidget {
  DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkModeEnabled = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              iconTheme: value
                  ? StyleApp.darkIcon(context)
                  : StyleApp.lightIcon(context),
              leading: Builder(
                  builder: (context) => IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.settings))),
            ),
            drawer: createDrawer(),
          );
        });
  }

  Widget createDrawer() {
    return ValueListenableBuilder(
        valueListenable: GlobalValues.flagTheme,
        builder: (context, value, _) {
          return Drawer(
            child: ListView(
              children: [
                const UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage('http://i.pravatar.cc/300'),
                    ),
                    accountName: Text('Kevin Melecio'),
                    accountEmail: Text('kevin123@gmail.com')),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: DayNightSwitcher(
                    isDarkModeEnabled: GlobalValues.flagTheme.value,
                    onStateChanged: (isDarkModeEnabled) {
                      GlobalValues().getTheme(isDarkModeEnabled);
                      GlobalValues.flagTheme.value = isDarkModeEnabled;
                    },
                  ),
                ),
                ListTile(
                  iconColor: value
                  ? StyleApp.darkIconDrawer(context)
                  : StyleApp.lightIconDrawer(context),
                  leading: Image.asset('assets/strawberry.png'),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('FruitApp'),
                  subtitle: Text('Carusel'),
                  onTap: () {},
                ),
                ListTile(
                  iconColor: value
                      ? StyleApp.darkIconDrawer(context)
                      : StyleApp.lightIconDrawer(context),
                  leading: Icon(Icons.task_alt_outlined),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Task Manager'),
                  onTap: () => Navigator.pushNamed(context, '/task'),
                ),
                ListTile(
                  iconColor: value
                      ? StyleApp.darkIconDrawer(context)
                      : StyleApp.lightIconDrawer(context),
                  leading: Icon(Icons.task_alt_outlined),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Popular'),
                  onTap: () => Navigator.pushNamed(context, '/popular'),
                ),
                ListTile(
                  iconColor: value
                      ? StyleApp.darkIconDrawer(context)
                      : StyleApp.lightIconDrawer(context),
                  leading: Icon(Icons.task_alt_outlined),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Tareas'),
                  onTap: () => Navigator.pushNamed(context, '/tareas'),
                ),
                ListTile(
                  iconColor: value
                      ? StyleApp.darkIconDrawer(context)
                      : StyleApp.lightIconDrawer(context),
                  leading: Icon(Icons.task_alt_outlined),
                  trailing: Icon(Icons.chevron_right),
                  title: Text('Carrera'),
                  onTap: () => Navigator.pushNamed(context, '/carrera'),
                ),
                ListTile(
                    iconColor: value
                        ? StyleApp.darkIconDrawer(context)
                        : StyleApp.lightIconDrawer(context),
                    leading: Icon(Icons.logout),
                    trailing: Icon(Icons.chevron_right),
                    title: Text('LogOut'),
                    onTap: () {
                      _disableRememberMe(context);
                    }),
              ],
            ),
          );
        });
  }
}
