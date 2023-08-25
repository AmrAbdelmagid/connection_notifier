import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/material.dart';

void main() async {
  /// If you want to use [ConnectionNotifierTools] you must call this first.
  // await ConnectionNotifierTools.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Wrap [MaterialApp] with [ConnectionNotifier], and that is it!.
    return ConnectionNotifier(
      connectionNotificationOptions: const ConnectionNotificationOptions(
        alignment: AlignmentDirectional.bottomCenter,
      ),
      child: MaterialApp(
        title: 'Connection Notifier Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark(),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const LocalConnectionNotificationScreen()));
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connection Notifier Demo'),
        ),

        /// If you want to toggle some widgets based on connection state.
        body: ConnectionNotifierToggler(
          onConnectionStatusChanged: (connected) {
            /// that means it is still in the initialization phase.
            if (connected == null) return;
            debugPrint(connected.toString());
          },
          connected: Center(
            key: UniqueKey(),
            child: const Text(
              'Connected',
              style: TextStyle(
                color: Colors.green,
                fontSize: 48,
              ),
            ),
          ),
          disconnected: Center(
            key: UniqueKey(),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Disconnected',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 48,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LocalConnectionNotificationScreen extends StatelessWidget {
  const LocalConnectionNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    /// Use [LocalConnectionNotifier] if you want to show the connection
    /// notification on one screen only, like [LocalConnectionNotificationScreen]
    /// in this example.
    return LocalConnectionNotifier(
      connectionNotificationOptions: const ConnectionNotificationOptions(
        alignment: Alignment.bottomCenter,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Local connection Notifier Demo'),
        ),
      ),
    );
  }
}
