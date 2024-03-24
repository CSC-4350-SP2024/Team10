import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const darkTop = Color.fromARGB(255, 31, 48, 66);
const darkBottom = Color.fromARGB(255, 26, 33, 41);
const lightTop = Color.fromARGB(255, 226, 226, 226);
const lightBottom = Color.fromARGB(255, 204, 204, 204);
const fontColor = Color.fromARGB(255, 255, 255, 255);

class AppThemes {
  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: darkTop,
      canvasColor: Colors.transparent,
    );
  }

  static ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: lightTop,
      canvasColor: Colors.transparent,
    );
  }
}

Decoration gradientBackground(ThemeData theme) {
  List<Color> currentColors;
  if (theme.brightness == Brightness.dark) {
    currentColors = [darkTop, darkBottom];
  } else {
    currentColors = [lightTop, lightBottom];
  }
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: currentColors,
    ),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isReturnable;
  final Icon? icon;
  final Widget? navigateTo;
  final Function? onReturn;

  CustomAppBar({
    Key? key,
    required this.title,
    this.isReturnable = false,
    this.icon,
    this.navigateTo,
    this.onReturn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: fontColor)),
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0.0,
      iconTheme: const IconThemeData(color: fontColor),
      automaticallyImplyLeading: isReturnable,
      centerTitle: true,
      actions: [
        if (!isReturnable && icon != null)
          IconButton(
            icon: icon!,
            onPressed: () {
              if (navigateTo != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => navigateTo!),
                );
              }
            },
          ),
        if (isReturnable && onReturn != null)
          IconButton(
            icon: icon!,
            onPressed: () {
              onReturn!();
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
