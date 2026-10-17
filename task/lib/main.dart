import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/app_theme.dart';
import 'core/s.dart';
import 'data/mock_api.dart';
import 'providers/apply_provider.dart';
import 'providers/connectivity_provider.dart';
import 'providers/job_list_provider.dart';
import 'providers/language_provider.dart';
import 'screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final api = MockApi();
  final language = LanguageProvider();
  final connectivity = ConnectivityProvider();
  final apply = ApplyProvider(api);

  await Future.wait([language.load(), connectivity.init(), apply.load()]);

  final jobList = JobListProvider(api, connectivity);
  jobList.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: language),
        ChangeNotifierProvider.value(value: connectivity),
        ChangeNotifierProvider.value(value: apply),
        ChangeNotifierProvider.value(value: jobList),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LanguageProvider>().locale;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      supportedLocales: SDelegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}
