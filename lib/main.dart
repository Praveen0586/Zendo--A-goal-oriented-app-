import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_learn/constants.dart';
import 'package:hive_learn/hiv_/hive_cre.dart';
import 'package:hive_learn/hiv_/obj_hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(HiveObjAdapter());
  hiveBox = await Hive.openBox<HiveObj>('Todo Box');
  themeBox = await Hive.openBox("Theme Box");

  runApp(CupertinoMaterial());
}

class CupertinoMaterial extends StatefulWidget {
  const CupertinoMaterial({super.key});

  @override
  State<CupertinoMaterial> createState() => _CupertinoMaterialState();
}

class _CupertinoMaterialState extends State<CupertinoMaterial> {
  @override
  Widget build(BuildContext context) {
    systemBrightness = MediaQuery.of(context).platformBrightness;
    bool systemIsDark = systemBrightness == Brightness.dark;

    if (isDarkModeNotifier.value != systemIsDark) {
      updateBrightness(systemIsDark);
    }
    print("Brightness" + systemBrightness.toString());
    setState(() {
      isDarkModeNotifier.value = themeBox.get("theme", defaultValue: false);
    });
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, _) {
        return CupertinoApp(
          theme: CupertinoThemeData(
            brightness: isDarkMode ? Brightness.dark : Brightness.light,
          ),
          title: 'Flutter App',
          home: MyCupertinoApp(),
          //     darkTheme: ThemeData.dark(),
          //    theme: ThemeData.dark(),
          //  themeMode: ThemeMode.dark,
        );
      },
    );
  }
}

class MyCupertinoApp extends StatefulWidget {
  const MyCupertinoApp({super.key});

  @override
  State<MyCupertinoApp> createState() => _MyCupertinoAppState();
}

class _MyCupertinoAppState extends State<MyCupertinoApp> {
  final _controller = TextEditingController();
  ShowPreview(String content) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Center(
          child: CupertinoActionSheet(
            message: Text('Preview'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  content,
                  style: CupertinoTheme.of(
                    context,
                  ).textTheme.textStyle.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    //   color: CupertinoColors.label,
                  ),
                ),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text('Close'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: CupertinoActionSheet(
              title: Text('Crush a New Task'),
              message: Text('Type your next goal here...'),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: CupertinoTextField(controller: _controller),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: CupertinoButton.filled(
                    child: Text("Make it Count"),
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        await hiveBox.add(
                          HiveObj(
                            id: DateTime.now().microsecondsSinceEpoch,
                            message: _controller.text,
                            isEnabled: false,
                          ),
                        );
                        _controller.clear();
                        Navigator.pop(context);
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('Cancel'),
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            // isDarkModeNotifier.value = !isDarkModeNotifier.value;
            updateBrightness(!isDarkModeNotifier.value);
            setState(() {});
          },
          child: Icon(
            isDarkModeNotifier.value
                ? CupertinoIcons.sun_max
                : CupertinoIcons.moon_stars,
            size: 26,
          ),
        ),
        middle: Text(' Goals to Conquer'),
        trailing: GestureDetector(
          onTap: () {
            _showBottomSheet(context);
          },

          child: Icon(CupertinoIcons.add, size: 26),
        ),
      ),
      child: FutureBuilder(
        future: loadHiveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CupertinoActivityIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No Data Found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final currentdata = snapshot.data![index];
              bool isen = currentdata.isEnabled;
              return GestureDetector(
                onTap: () {
                  ShowPreview(currentdata.message);
                },
                onLongPress: () async {
                  HapticFeedback.mediumImpact();
                  final key = hiveBox.keyAt(index);
                  setState(() {
                    hiveBox.delete(key);
                  });
                },
                child: CupertinoListTile(
                  title: Text(
                    currentdata.message,
                    style: CupertinoTheme.of(
                      context,
                    ).textTheme.textStyle.copyWith(
                      decoration: isen ? TextDecoration.lineThrough : null,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      decorationThickness: 2,
                    ),
                  ),
                  leading: CupertinoCheckbox(
                    value: isen,
                    onChanged: (value) {
                      isen = value!;
                      // updateBoolean(index);
                      setState(() {
                        updateBoolean(index);
                      });
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

