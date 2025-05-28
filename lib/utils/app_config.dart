enum Flavor { dev, prod }

class FlavorConfig {
  final Flavor flavor;
  final String baseUrl;

  FlavorConfig({
    required this.flavor,
    required this.baseUrl,
  });
}
