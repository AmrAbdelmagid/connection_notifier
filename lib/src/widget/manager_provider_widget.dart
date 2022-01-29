part of connection_notifier_manager;

class _ConnectionNotifierProvider extends StatelessWidget {
  const _ConnectionNotifierProvider({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      child: child,
      providers: [
        BlocProvider<ConnectionNotifierManager>(
          create: (_) => ConnectionNotifierManager().._check(),
          lazy: false,
        ),
      ],
    );
  }
}
