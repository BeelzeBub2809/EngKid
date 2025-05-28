import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:EzLish/main_common.dart';
import 'package:EzLish/utils/app_config.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  final devConfig = FlavorConfig(
    flavor: Flavor.dev,
    baseUrl: dotenv.get('PROD_API_URL'),
  );
  mainCommon(devConfig);
}
