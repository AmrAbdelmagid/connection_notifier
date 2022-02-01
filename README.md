# Connection Notifier

A simple way to notify your user about the connection status.

## Gallery


#### Basic Usage: ConnectionNotifier

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(    /// Wrap [MaterialApp] with [ConnectionNotifier], and that is it!
      child: MaterialApp(
        title: 'Connection Notifier Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
```
#### ConnectionNotifierToggler

If you want to toggle between some widgets automatically based on connection state.

```dart
ConnectionNotifierToggler(
        onConnectionStatusChanged: (connected) {
          /// that means it is still in the initialization phase.
          if (connected == null) return;
          print(connected);
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
          child: const Text(
            'Disconnected',
            style: TextStyle(
              color: Colors.red,
              fontSize: 48,
            ),
          ),
        ),
      );

```
#### Check Anywhere inside UI for internet connection 

```dart
 ConnectionNotifierManager.isConnected(context); // you need to check if it is null (it will be null in initialization phase only).
```


## Attribution

This package depends on the following (Big Thanks):

[flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc)
[oktoast](https://github.com/OpenFlutter/flutter_oktoast)
[internet_connection_checker ](https://github.com/RounakTadvi/internet_connection_checker)


## License

MIT License
