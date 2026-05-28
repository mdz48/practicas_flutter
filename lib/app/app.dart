import 'package:flutter/material.dart';
import 'package:noveno/app/core/di/app_container.dart';
import 'package:noveno/app/features/users/presentation/pages/login.dart';
import 'package:noveno/shared/theme/theme.dart';
import 'package:noveno/shared/theme/util.dart';

class MyApp extends StatelessWidget {
  final AppContainer appContainer = AppContainer();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Montserrat", "Roboto");
    MaterialTheme myTheme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Veterinaria',
      themeMode: ThemeMode.system,
      theme: myTheme.light(),
      darkTheme: myTheme.dark(),
      home: MyHomePage(appContainer: appContainer),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppContainer appContainer;
  const MyHomePage({super.key, required this.appContainer});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Veterinaria'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [LoginForm(usersModule: widget.appContainer.usersModule)],
        ),
      ),
    );
  }
}
