import 'package:EzLish/presentation/register/register_binding.dart';
import 'package:EzLish/presentation/register/register_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:EzLish/di/injection.dart';
import 'package:EzLish/presentation/core/app_binding.dart';
import 'package:EzLish/presentation/login/login_binding.dart';
import 'package:EzLish/presentation/login/login_ui.dart';
import 'package:EzLish/utils/app_color.dart';
import 'package:EzLish/utils/app_config.dart';
import 'package:EzLish/utils/app_route.dart';
import 'package:EzLish/utils/localization/localization_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock/wakelock.dart';

Future<void> mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.inject(config.baseUrl);

  //keep the screen on
  Wakelock.enable();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) => OKToast(
        child: GetMaterialApp(
          initialBinding: AppBinding(),
          debugShowCheckedModeBanner: false,
          locale: LocalizationService.locale,
          translations: LocalizationService(),
          initialRoute: AppRoute.login,
          theme: ThemeData.light().copyWith(
            scrollbarTheme: ScrollbarThemeData(
              thumbVisibility: MaterialStateProperty.all(false),
              thickness: MaterialStateProperty.all(10),
              thumbColor: MaterialStateProperty.all(AppColor.red),
              trackColor: MaterialStateProperty.all(AppColor.gray),
              trackBorderColor: MaterialStateProperty.all(AppColor.gray),
              trackVisibility: MaterialStateProperty.all(true),
              radius: const Radius.circular(10),
              minThumbLength: 100,
              interactive: true,
            ),
          ),
          getPages: [
            GetPage(
              name: AppRoute.login,
              page: () => const LoginScreen(),
              binding: LoginBinding(),
            ),
            GetPage(
              name: AppRoute.register,
              page: () => const RegisterScreen(),
              binding: RegisterBinding(),
            )
          ],
        ),
      ),
    );
  }
}
