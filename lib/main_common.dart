import 'package:EngKid/domain/core/entities/app_setting/entities/entities.dart';
import 'package:EngKid/presentation/add_child_account/add_child_account_binding.dart';
import 'package:EngKid/presentation/add_child_account/add_child_account_ui.dart';
import 'package:EngKid/presentation/declare_parent_code/declare_parent_code_binding.dart';
import 'package:EngKid/presentation/declare_parent_code/declare_parent_code_ui.dart';
import 'package:EngKid/presentation/e_library/e_library_binding.dart';
import 'package:EngKid/presentation/e_library/e_library_ui.dart';
import 'package:EngKid/presentation/e_library/e_library_video_binding.dart';
import 'package:EngKid/presentation/e_library/e_library_video_ui.dart';
import 'package:EngKid/presentation/game/wordle_game/wordle_game_binding.dart';
import 'package:EngKid/presentation/game/wordle_game/wordle_game_ui.dart';
import 'package:EngKid/presentation/game/puzzle_game/puzzle_game_binding.dart';
import 'package:EngKid/presentation/game/puzzle_game/puzzle_game_ui.dart';
import 'package:EngKid/presentation/game/memory_game/memory_game_binding.dart';
import 'package:EngKid/presentation/game/memory_game/memory_game_ui.dart';
import 'package:EngKid/presentation/home/home_screen_binding.dart';
import 'package:EngKid/presentation/home/home_screen_ui.dart';
import 'package:EngKid/presentation/management_space/management_space_binding.dart';
import 'package:EngKid/presentation/management_space/management_space_ui.dart';
import 'package:EngKid/presentation/management_space/personal_info/personal_info_binding.dart';
import 'package:EngKid/presentation/management_space/personal_info/personal_info_ui.dart';
import 'package:EngKid/presentation/management_space/profile/profile_child/profile_child_binding.dart';
import 'package:EngKid/presentation/management_space/profile/profile_child/profile_child_ui.dart';
import 'package:EngKid/presentation/management_space/profile/profile_parent/profile_parent_binding.dart';
import 'package:EngKid/presentation/management_space/profile/profile_parent/profile_parent_ui.dart';
import 'package:EngKid/presentation/management_space/report/report_binding.dart';
import 'package:EngKid/presentation/management_space/report/report_ui.dart';
import 'package:EngKid/presentation/management_space/setting/setting_binding.dart';
import 'package:EngKid/presentation/management_space/setting/setting_ui.dart';
import 'package:EngKid/presentation/my_library/my_library_binding.dart';
import 'package:EngKid/presentation/my_library/my_library_ui.dart';
import 'package:EngKid/presentation/notification_system/notification_system_binding.dart';
import 'package:EngKid/presentation/notification_system/notification_system_ui.dart';
import 'package:EngKid/presentation/question/question_binding.dart';
import 'package:EngKid/presentation/question/question_ui.dart';
import 'package:EngKid/presentation/reading_space/reading_space_binding.dart';
import 'package:EngKid/presentation/reading_space/reading_space_ui.dart';
import 'package:EngKid/presentation/register/register_binding.dart';
import 'package:EngKid/presentation/register/register_ui.dart';
import 'package:EngKid/presentation/validate_parent/validate_parent_binding.dart';
import 'package:EngKid/presentation/validate_parent/validate_parent_ui.dart';
import 'package:EngKid/presentation/game/game_binding.dart';
import 'package:EngKid/presentation/game/game_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:EngKid/di/injection.dart';
import 'package:EngKid/presentation/core/app_binding.dart';
import 'package:EngKid/presentation/login/login_binding.dart';
import 'package:EngKid/presentation/login/login_ui.dart';
import 'package:EngKid/utils/app_color.dart';
import 'package:EngKid/utils/app_config.dart';
import 'package:EngKid/utils/app_route.dart';
import 'package:EngKid/utils/localization/localization_service.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sizer/sizer.dart';
import 'package:wakelock/wakelock.dart';

Future<void> mainCommon(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.inject(config.baseUrl);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
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
            ),
            GetPage(
              name: AppRoute.home,
              page: () => const HomeScreen(),
              binding: HomeScreenBinding(),
            ),
            GetPage(
              name: AppRoute.readingSpace,
              page: () => const ReadingScreen(),
              binding: ReadingSpaceBinding(),
            ),
            GetPage(
              name: AppRoute.myLibrary,
              page: () => const MyLibraryScreen(),
              binding: MyLibraryBinding(),
            ),
            GetPage(
              name: AppRoute.managementSpace,
              page: () => const ManagementSpaceScreen(),
              binding: ManagementSpaceBinding(),
              children: [
                GetPage(
                    name: AppRoute.report,
                    page: () => const ReportScreen(),
                    binding: ReportBinding()),
                GetPage(
                    name: AppRoute.personalInfo,
                    page: () => const PersonalInfoScreen(),
                    binding: PersonalInfoBinding()),
                GetPage(
                  name: AppRoute.settings,
                  page: () => const SettingScreen(),
                  binding: SettingBinding(),
                ),
              ],
            ),
            GetPage(
              name: AppRoute.eLibrary,
              page: () => const ElibraryScreen(),
              binding: ElibraryBinding(),
            ),
            GetPage(
              name: AppRoute.eLibraryVideo,
              page: () => ElibraryVideoScreen(),
              binding: ElibraryVideoBinding(),
            ),
            GetPage(
              name: AppRoute.lesson,
              page: () => QuestionScreen(),
              binding: QuestionBinding(),
            ),
            GetPage(
              name: AppRoute.declareParentCode,
              page: () => const DeclareParentCodeScreen(),
              binding: DeclareParentCodeBinding(),
            ),
            GetPage(
              name: AppRoute.validateParentCode,
              page: () => const ValidateParentScreen(),
              binding: ValidateParentBinding(),
            ),
            GetPage(
                name: AppRoute.addChildrenCode,
                page: () => const AddChildAccountScreen(),
                binding: AddChildAccountBinding()),
            GetPage(
              name: AppRoute.profileParent,
              page: () => const ProfileParentScreen(),
              binding: ProfileParentBinding(),
            ),
            GetPage(
              name: AppRoute.profileChild,
              page: () => const ProfileChildScreen(),
              binding: ProfileChildBindings(),
            ),
            GetPage(
              name: AppRoute.game,
              page: () => const GameUI(),
              binding: GameBinding(),
            ),
            GetPage(
              name: AppRoute.wordleGame,
              page: () => const WordleGameUI(),
              binding: WordleGameBinding(),
            ),
            GetPage(
              name: AppRoute.puzzleGame,
              page: () => const PuzzleGameUI(),
              binding: PuzzleGameBinding(),
            ),
            GetPage(
              name: AppRoute.memoryGame,
              page: () => const MemoryGameUI(),
              binding: MemoryGameBinding(),
            ),
            GetPage(
              name: AppRoute.notificationSystem,
              page: () => const NotificationSystemScreen(),
              binding: NotificationSystemBinding(),
            ),
          ],
        ),
      ),
    );
  }
}
