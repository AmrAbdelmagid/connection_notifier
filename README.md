# Connection Notifier

A simple way to notify your user about the connection status as well as providing simple tools that help tracking the internet connection status.

## Gallery


<table>
  <tr>
    <td><img src="https://user-images.githubusercontent.com/52869694/152056061-193a6a69-dbdd-48e0-bc10-892723b59478.gif" width=270 height=480></td>
    <td><img src="https://user-images.githubusercontent.com/52869694/152057700-71f9cccf-3fe0-435d-92c2-e20cddf6a7a3.gif" width=240 height=480></td>
  </tr>
    <tr>
    <td><img src="https://user-images.githubusercontent.com/52869694/204103379-2b83ab1b-d9e8-4e82-a98c-5afd60b6a084.gif" width=230 height=480></td>
  </tr>
 </table>
      

### ConnectionNotifier

```dart
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Wrap [MaterialApp] with [ConnectionNotifier], and that is it!
    return ConnectionNotifier( 
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
#### ConnectionNotificationOptions parameters catalog
---

| Option | Description | Type | Default Value | Required |
|---|---|---|---|:---:|
child | Child widget, typically [MaterialApp] or [CupertinoApp] | Widget | - |Yes
alignment | Alignment of the connection notification | AlignmentGeometry | AlignmentDirectional.topCenter |No
pauseConnectionListenerWhenAppInBackground | To pause listening to changes while app in background | bool | false |No
height | Height of the connection notification | double? | twice top padding |No
width | Width of the connection notification | double? | double.infinity |No
borderRadius | Border radius of the connection notification | BorderRadiusGeometry? | null |No
connectedBackgroundColor | Background color of the connection notification in connected state | Color? | Colors.green |No
disconnectedBackgroundColor | Background color of the connection notification in disconnected state | Color? | Colors.red |No
connectedDuration | Duration of the connection notification in connected state before it's auto dismissing | Duration? | 2 seconds |No
disconnectedDuration | Duration of the connection notification in disconnected state before it's auto dismissing | Duration? | infinity |No
overlayAnimationType | Overlay animation type of the connection notification | OverlayAnimationType | OverlayAnimationType.fadeAndSlide |No
animationCurve | Animation curve of the connection notification | Curve? | Curves.fastOutSlowIn |No
animationDuration | Animation duration of the connection notification | Duration? | 300 milliseconds |No
connectedContent | Content of connection notification in connected state. if this is given, it will override all the specific parameters for the default content in connected state, typically a [Row] widget | Widget? | null |No
disconnectedContent | Content of connection notification in disconnected state. if this is given, it will override all the specific parameters for the default content in disconnected state, typically a [Row] widget | Widget? | null |No
shouldAlwaysPullContentDownOnTopAlignment | If the content of the connection notification should be pulled down in case of top alignment and [height] is grater than twice of top padding only, to test it visually just set a [height] that is bigger than twice of top padding (300 for example) and toggle it between [true] and [false] to see it's effect | bool | true |No
hasIndicationIcon | If the default content has an indication icon | bool | true |No
textAndIconSeparationWidth | Distance between text and icon in default content | double? | 10 |No
connectedText | Text of the default content of the connection notification in connected state | String? | 'Back Online' |No
disconnectedText | Text of the default content of the connection notification in disconnected state | String? | 'Retrying' |No
connectedTextStyle | Text style of the default content of the connection notification in connected state | String? | null |No
disconnectedTextStyle | Text style of the default content of the connection notification in disconnected state | String? | null |No
connectedIcon | Icon of the default content of the connection notification in connected state | Icon? | Icon widget with [Icons.check] |No
disconnectedIcon | Icon of the default content of the connection notification in disconnected state | Icon? | Circular progress indicator |No
iconBoxSideLength | Length of each side (height and width) of the [SizedBox] that wraps the [Icon] of the default content of the connection notification | double? | 10 |No
connectedConnectionNotification | This is useful if you want to override default connection notification with a custom widget in connected state and it will use the alignment and animation | Widget? | null |No
disconnectedConnectionNotification | This is useful if you want to override default connection notification with a custom widget in disconnected state and it will use the alignment and animation | Widget? | null |No


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
---
#### LocalConnectionNotifier

If you want to show the connection notification for a specific screen only.

```dart
class LocalConnectionNotificationScreen extends StatelessWidget {
  const LocalConnectionNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
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


```
---
#### ConnectionNotifierTools

Tools that make it very easy to check on the internet connection status ANY WHERE inside your project.

At first you need to initialize it before using it's data. To do that, simply call this:

```dart
  await ConnectionNotifierTools.initialize();
```
Then you can use these tools as you want:

```dart
 /// A boolean that has the latest update about the connection status.
 ConnectionNotifierTools.isConnected;

 /// A broadcast stream that emits on every change in the connection status. 
 ConnectionNotifierTools.onStatusChange;
```

And that's it!


## Attribution

This package depends on the following (Big Thanks):

[internet_connection_checker](https://github.com/RounakTadvi/internet_connection_checker) <br />
[rxdart](https://github.com/ReactiveX/rxdart) <br />


## License

MIT License
