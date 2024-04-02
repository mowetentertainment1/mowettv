import 'package:flutter/services.dart';
import 'package:jellyflix/providers/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:matomo_tracker/matomo_tracker.dart';
import 'package:media_kit/media_kit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


// See the docker folder for instructions on how to get a
// test Matomo instance running
const _matomoEndpoint = 'https://analytics.smithandtech.com/matomo.php';
const _sideId = 3;
const _testUserId = 'mowetthedon';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MatomoTracker.instance.initialize(
    siteId: _sideId,
    url: _matomoEndpoint,
    verbosityLevel: Level.all,
    // dispatchSettings: dispatchSettingsEndToEndTest,
  );
  MatomoTracker.instance.setVisitorUserId(_testUserId);
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(ProviderScope(
    child: Shortcuts(shortcuts: <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
    }, child: const MyApp()),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.read(routerProvider).router;
    return MaterialApp.router(
      // localization
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // routing
      routeInformationParser: appRouter.routeInformationParser,
      routerDelegate: appRouter.routerDelegate,
      routeInformationProvider: appRouter.routeInformationProvider,
      debugShowCheckedModeBanner: false,
      title: "MoTV",
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.orange, brightness: Brightness.dark),
        useMaterial3: true,
      ),
    );
  }
}
