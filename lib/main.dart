import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/bottombar/bottomnavigationbar.dart';
import 'package:music_player/controller/controller.dart';
import 'package:music_player/database/songmodel_adapter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'database/box.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongsAdapter());

  await Hive.openBox<List>(boxname);
  final box = Boxes.getInstance();

  List<dynamic> libraryKeys = box.keys.toList();

  if (!libraryKeys.contains("favorites")) {
    List<dynamic> likedSongs = [];
    await box.put("favorites", likedSongs);
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
final statecontroller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.quandoTextTheme(
            ThemeData.light().textTheme,
          ),
        ),
        // getPages: [
        //   GetPage(
        //     name: "/main",
        //     page: () => Gridsong(audiosongs: audiosongs),
        //     binding: SongBinding(),
        //   )
        // ],
        debugShowCheckedModeBanner: false,
        // initialRoute: "/main",
        home: GetBuilder<Controller>(
          builder: (_controller) {
            return AnimatedSplashScreen(
              backgroundColor: Color(0xFF091B46),
              duration: 3000,
              splash: Padding(
                padding: const EdgeInsets.symmetric(vertical: 120),
                child: Column(children: [
                  Image.asset("assets/images/musiclogo.png"),
                  Text(
                    "Euphonia",
                    style: TextStyle(
                        color: Colors.pink,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
              splashIconSize: double.infinity,
              nextScreen: BottomBar(allsong: _controller.audiosongs),
              splashTransition: SplashTransition.fadeTransition,
            );
          }
        ));
  }
}
