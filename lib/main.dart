import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/design/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'core/config/app_config_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app config provider
  final configProvider = AppConfigProvider();
  await configProvider.initialize();

  runApp(EducationalApp(configProvider: configProvider));
}

class EducationalApp extends StatelessWidget {
  final AppConfigProvider configProvider;

  const EducationalApp({
    super.key,
    required this.configProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: configProvider,
      builder: (context, _) {
        return MaterialApp.router(
          title: configProvider.config?.appName ?? 'STP',
          debugShowCheckedModeBanner: false,

          // RTL & Localization - Arabic only
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Theme - use API config if available
          theme: AppTheme.lightTheme(configProvider.config?.theme),

          // Router
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
