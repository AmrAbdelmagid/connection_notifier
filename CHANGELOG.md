## 3.0.0

**Major Release - Navigator 2.0 & Web Support**

**BREAKING CHANGES** - This release contains breaking changes. Please read the migration guide below.

### New Features
- **Navigator 2.0 Support**: Full compatibility with GoRouter, AutoRoute, Beamer, and all modern routing solutions
- **Web Platform Support**: Now works on Flutter Web!
- **Simplified API**: Introduced `GlobalConnectionNotifier` as the single, simple way to add connection notifications
- **Better Architecture**: Removed MaterialApp wrapping limitation - now wraps MaterialApp instead of replacing it
- **Dependency Update**: Migrated from `internet_connection_checker` to `internet_connection_checker_plus` for better platform support
- **Improved Localization**: Added comprehensive documentation for handling localization before MaterialApp initialization

### BREAKING CHANGES
**ACTION REQUIRED:** This version contains breaking changes that will require code modifications in your app.

1. **Widget Renamed**: `ConnectionNotifier` (the old global widget) has been replaced with `GlobalConnectionNotifier`
   - ❌ Old: `ConnectionNotifier(child: MaterialApp(...))`
   - ✅ New: `GlobalConnectionNotifier(child: MaterialApp(...))`
   - The old `ConnectionNotifier` widget is still available for advanced use cases but most users should use `GlobalConnectionNotifier`

2. **Removed Properties**: Locale-related properties removed from the global widget (now configure in MaterialApp normally):
   - `locale` - Move to MaterialApp
   - `supportedLocales` - Move to MaterialApp
   - `localizationsDelegates` - Move to MaterialApp
   - `localeListResolutionCallback` - Move to MaterialApp
   - `localeResolutionCallback` - Move to MaterialApp

### Migration Required
**Please see the Migration Guide section in [README.md](README.md) for detailed step-by-step migration instructions from v2.x to v3.0.**

Quick migration summary:
1. Replace `ConnectionNotifier` with `GlobalConnectionNotifier`
2. Move locale properties to `MaterialApp`
3. Handle localization using documented approaches
4. Test your app thoroughly

### Improvements
- Fixed potential memory leaks with stream subscription management
- Added proper BuildContext handling with mounted checks
- Improved overlay state resolution for better compatibility
- Better documentation with examples for all navigation types
- Added localization guide for handling messages before Material context

### Bug Fixes
- Fixed "BuildContext across async gaps" warnings
- Fixed multiple stream subscriptions in build method
- Improved overlay detection with rootOverlay parameter

## 2.0.1
- Fix linter warning of missing case clause for hidden case in AppLifecycleState.

## 2.0.0
- Introducing the new `LocalConnectionNotifier` for showing local connection notification per specific screen.
- A breaking change: Move connection notification options into a separate object named `ConnectionNotificationOptions`.
## 1.0.1
- Updated readme.

## 1.0.0

- Added more options to the `ConnectionNotifier` widget for enhanced customization.
- Removed dependencies on `bloc`, `flutter_bloc`, and `oktoast` packages.
- Introduced new tools for connection management.
- The `ConnectionNotifierManager.isConnected(context)` method has been deprecated. Use `ConnectionNotifierTools.isConnected` instead. Refer to the documentation for more information.

## 0.0.1

- Initial release.