import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:noveno/app/core/di/app_container.dart';
import 'package:noveno/app/features/users/presentation/pages/login.dart';
import 'package:noveno/app/features/users/presentation/viewmodels/login_viewmodel.dart';
import 'package:noveno/shared/theme/theme.dart';
import 'package:noveno/shared/theme/util.dart';

class MyApp extends StatelessWidget {
  final AppContainer appContainer = AppContainer();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Roboto");
    MaterialTheme myTheme = MaterialTheme(textTheme);
    return Provider<AppContainer>.value(
      value: appContainer,
      child: MaterialApp(
        title: 'Veterinaria',
        themeMode: ThemeMode.system,
        theme: myTheme.light(),
        darkTheme: myTheme.dark(),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appContainer = context.read<AppContainer>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Veterinaria'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChangeNotifierProvider<LoginViewModel>(
              create: (context) => LoginViewModel(
                loginUseCase: appContainer.usersModule.loginUseCase,
                checkSecurityUseCase:
                    appContainer.usersModule.checkSecurityUseCase,
              )..checkSecurity(),
              child: const LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}
